package {
import flash.geom.*;
import flash.display.*;
import flash.utils.*;

public class PNGEnc {

    public static function encode(img:BitmapData):ByteArray {
        // Create output byte array
        var png:ByteArray = new ByteArray();
        // Write PNG signature
        png.writeUnsignedInt(0x89504e47);
        png.writeUnsignedInt(0x0D0A1A0A);
        // Build IHDR chunk
        var IHDR:ByteArray = new ByteArray();
        IHDR.writeInt(img.width);
        IHDR.writeInt(img.height);
        IHDR.writeUnsignedInt(0x08060000); // 32bit RGBA
        IHDR.writeByte(0);
        writeChunk(png,0x49484452,IHDR);
        // Build IDAT chunk
        var IDAT:ByteArray= new ByteArray();
        for(var i:int=0;i < img.height;i++) {
            // no filter
            IDAT.writeByte(0);
            var p:uint;
            if ( !img.transparent ) {
                for(var j:int=0;j < img.width;j++) {
                    p = img.getPixel(j,i);
                    IDAT.writeUnsignedInt(
                        uint(((p&0xFFFFFF) << 8)|0xFF));
                }
				
            } else {
                for( j=0;j < img.width;j++) {
                    p = img.getPixel32(j,i);
                    IDAT.writeUnsignedInt(
                        uint(((p&0xFFFFFF) << 8)|
                        (p>>>24)));
                }
            }
        }
        IDAT.compress();
        writeChunk(png,0x49444154,IDAT);
        // Build IEND chunk
        writeChunk(png,0x49454E44,null);
        // return PNG
        return png;
    }

    private static var crcTable:Array;
    private static var crcTableComputed:Boolean = false;

    private static function writeChunk(png:ByteArray, 
            type:uint, data:ByteArray) {
        if (!crcTableComputed) {
            crcTableComputed = true;
            crcTable = [];
            for (var n:uint = 0; n < 256; n++) {
                var c:uint = n;
                for (var k:uint = 0; k < 8; k++) {
                    if (c & 1) {
                        c = uint(uint(0xedb88320) ^ 
                            uint(c >>> 1));
                    } else {
                        c = uint(c >>> 1);
                    }
                }
                crcTable[n] = c;
            }
        }
        var len:uint = 0;
        if (data != null) {
            len = data.length;
        }
        png.writeUnsignedInt(len);
        var p:uint = png.position;
        png.writeUnsignedInt(type);
        if ( data != null ) {
            png.writeBytes(data);
        }
        var e:uint = png.position;
        png.position = p;
        c = 0xffffffff;
        for (var i:int = 0; i < (e-p); i++) {
            c = uint(crcTable[
                (c ^ png.readUnsignedByte()) & 
                uint(0xff)] ^ uint(c >>> 8));
        }
        c = uint(c^uint(0xffffffff));
        png.position = e;
        png.writeUnsignedInt(c);
    }
}
}