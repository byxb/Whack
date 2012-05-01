//------------------------------------------------------------------------------
//
// Copyright 2011 BYXB LLC. All Rights Reserved. 
// 
// This software has been licensed to Adobe Systems Inc. for 
// use in educational, training, and for promotional and  
// demonstration purposes. All rights are otherwise retained 
// by BYXB LLC and subject to the following license: 
// 
// The software code contained herein is licensed under the Creative 
// Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.  
// To view this license, see http://creativecommons.org/licenses/by-nc- 
// sa/3.0/ or send a letter to Creative Commons, 444 Castro Street,  
// Suite 900, Mountain View, California, 94041, USA. 
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,  
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON- 
// INFRINGEMENT. IN NO EVENT SHALL BYXB LLC BE LIABLE FOR ANY CLAIM,  
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,  
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH  
// THE SOFTWARE OR THE USE, MISUSE, OR INABILITY TO USE THE SOFTWARE. 
// 
// For more information see http://www.byxb.com/. 
//
//------------------------------------------------------------------------------

package com.byxb.extensions.starling.display
{

	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.GraphicsTrianglePath;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Rectangle;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.errors.MissingContextError;
	import starling.textures.Texture;
	import starling.utils.VertexData;

	/**
	 * Extends Image to add drawTriangles capabilities similar to the Graphics object.
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class DrawImage extends DisplayObject
	{
        private static const PROGRAM_MIPMAP:String    = "DI_mm";
        private static const PROGRAM_NO_MIPMAP:String = "DI_nm";
        
        private var _vertexData:VertexData;
        private var _vertexBuffer:VertexBuffer3D;
        
        private var _indices:Vector.<uint>=new Vector.<uint>();
        private var _indexBuffer:IndexBuffer3D;
        
        private var _texture:Texture;
        
        /** Helper object. */
        private static var sRenderAlpha:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
        
		/**
		 * All triangle drawing will use the supplied texture as if a BeginBitmapFill were used.
		 * @param texture
		 */
		public function DrawImage(texture:Texture)
		{
			_texture = texture;
            registerPrograms();
		}

        private function createBuffers():void
        {
            var context:Context3D = Starling.context;
            if (context == null) throw new MissingContextError();
            
            if (_vertexBuffer) _vertexBuffer.dispose();
            if (_indexBuffer)  _indexBuffer.dispose();
            
            _texture.adjustVertexData(_vertexData, 0, _vertexData.numVertices);
            
            _vertexBuffer = context.createVertexBuffer(_vertexData.numVertices, VertexData.ELEMENTS_PER_VERTEX);
            _vertexBuffer.uploadFromVector(_vertexData.rawData, 0, _vertexData.numVertices);
            
            _indexBuffer = context.createIndexBuffer(_indices.length);
            _indexBuffer.uploadFromVector(_indices, 0, _indices.length);
        }
        
		/**
		 * Draws a collection of triangles filled with the texture supplied in the constructor
		 * @param vertices Vector.<Number> that alternates between X,Y values.
		 * @param uvData Vector.<Number> that alternates between U,V values.  Must be the same length as vertices.
		 * @param indices Vector.<uint> contains the vertex indices indicating how the triangles should be drawn.
		 * @throws Error
		 */
		public function drawTriangles(vertices:Vector.<Number>, uvData:Vector.<Number>, indices:Vector.<uint>=null):void
		{
			if (!_indices && !indices)
				return;
            
			_vertexData=new VertexData(vertices.length / 2, _texture.premultipliedAlpha);

			for (var i:uint=0; i < vertices.length; i+=2)
				_vertexData.setPosition(i >> 1, vertices[i], vertices[i + 1]);
            
			_vertexData.setUniformColor(0xffffff);
			_indices=indices.concat();

			if (uvData.length != vertices.length)
				throw new Error("uvData and vertices must be the same length.  Be sure that you are not supplying UVT data.");
            
			for (i=0; i < uvData.length; i+=2)
				_vertexData.setTexCoords(i >> 1, uvData[i], uvData[i + 1]);
			
            createBuffers();
		}

		/**
		 * draws triangles using the GraphicTrianglePath object from the Drawing API.  The index vector will automatically be converted from int to uint.
		 * @param trianglePath
		 */
		public function drawGraphicsTrianglePath(trianglePath:GraphicsTrianglePath):void
		{
			drawTriangles(trianglePath.vertices, trianglePath.uvtData, Vector.<uint>(trianglePath.indices));
		}

		/**
		 * @inherit
		 * @param targetSpace
		 * @return 
		 */
        public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
		{
            if (resultRect == null) resultRect = new Rectangle();
            resultRect.setTo(0, 0, 100, 200);
            return resultRect;
		}

		/**
		 * Renders the triangles.
		 * @param support
		 * @param alpha
		 * @throws MissingContextError
		 */
		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			if (_indices.length < 3 || _vertexData.numVertices < 3)
				return;
			
            var alpha:Number=this.alpha * parentAlpha;
			var pma:Boolean=_texture.premultipliedAlpha;
			var programName:String=_texture.mipMapping ? PROGRAM_MIPMAP : PROGRAM_NO_MIPMAP;
			var context:Context3D=Starling.context;

            if (_vertexBuffer == null) return;
			if (context == null) throw new MissingContextError();

            sRenderAlpha[0] = sRenderAlpha[1] = sRenderAlpha[2] = pma ? alpha : 1.0;
            sRenderAlpha[3] = alpha;
            
			support.applyBlendMode(pma);
            
			context.setProgram(Starling.current.getProgram(programName));
			context.setTextureAt(0, _texture.base);
			context.setVertexBufferAt(0, _vertexBuffer, VertexData.POSITION_OFFSET, Context3DVertexBufferFormat.FLOAT_3);
			context.setVertexBufferAt(1, _vertexBuffer, VertexData.COLOR_OFFSET, Context3DVertexBufferFormat.FLOAT_4);
			context.setVertexBufferAt(2, _vertexBuffer, VertexData.TEXCOORD_OFFSET, Context3DVertexBufferFormat.FLOAT_2);
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, support.mvpMatrix, true);
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, sRenderAlpha, 1);
			context.drawTriangles(_indexBuffer, 0, _indices.length / 3);

			context.setTextureAt(0, null);
			context.setVertexBufferAt(0, null);
			context.setVertexBufferAt(1, null);
			context.setVertexBufferAt(2, null);
		}

        /**
         * creates the AGAL programs that will draw the object.
         */ 
        private static function registerPrograms():void
        {
            var target:Starling = Starling.current;
            if (target.hasProgram(PROGRAM_MIPMAP)) return; // already registered
            
            for each (var mipmap:Boolean in [true, false])
            {            
                // create vertex and fragment programs - from assembly.
                
                var programName:String = mipmap ? PROGRAM_MIPMAP : PROGRAM_NO_MIPMAP;
                var textureOptions:String = "2d, repeat, linear, " + (mipmap ? "mipnearest" : "mipnone"); 
                
                var vertexProgramCode:String =
                    "m44 op, va0, vc0 \n" + // 4x4 matrix transform to output clipspace
                    "mul v0, va1, vc4 \n" + // multiply color with alpha and pass to fragment program
                    "mov v1, va2      \n";  // pass texture coordinates to fragment program
                
                var fragmentProgramCode:String =
                    "tex ft0, v1, fs0 <" + textureOptions + "> \n" + // sample texture 0
                    "mul oc, ft0, v0";                               // multiply color with texel color
                
                var vertexProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
                vertexProgramAssembler.assemble(Context3DProgramType.VERTEX, vertexProgramCode);
                
                var fragmentProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
                fragmentProgramAssembler.assemble(Context3DProgramType.FRAGMENT, fragmentProgramCode);
                
                target.registerProgram(programName, vertexProgramAssembler.agalcode,
                    fragmentProgramAssembler.agalcode);
            }
        }
   	}
}
