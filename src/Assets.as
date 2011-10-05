//------------------------------------------------------------------------------
//
// 
// Whack! Game 
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

package
{
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * The Assets class holds all embedded textures, fonts and sounds and other embedded files.  
	 * By using static access methods, only one instance of the asset file is instantiated. This 
	 * means that all Image types that use the same bitmap will use the same Texture on the video card.
	 * 
	 * @author Justin Church justin [at] byxb [dot] com
	 */
	public class Assets
	{

		[Embed(source="../media/textures/atlas.png")]
		/**
		 * 
		 * @default 
		 */
		public static const AtlasTexture:Class;


		// Fonts

		// The 'embedAsCFF'-part IS REQUIRED!!!!
		/*   [Embed(source="../media/fonts/Ubuntu-R.ttf", embedAsCFF="false", fontFamily="Ubuntu")]
		private static const UbuntuRegular:Class; */

		// Texture Atlas

		[Embed(source="../media/textures/atlas.xml", mimeType="application/octet-stream")]
		public static const AtlasXml:Class;

		//XML
		
		[Embed(source="../media/particles/dirt.pex", mimeType="application/octet-stream")]
		public static const DirtParticleDesign:Class;
		
		// Bitmaps
		
		[Embed(source="../media/textures/tiling_underground.png")]
		private static const ground:Class;
		
		private static var sSounds:Dictionary=new Dictionary();
		private static var sTextureAtlas:TextureAtlas;


		// Sounds

		/*[Embed(source="../media/audio/step.mp3")]
		public static const StepSound:Class;*/

		// Texture cache

		private static var sTextures:Dictionary=new Dictionary();

		/**
		 * Returns the Texture atlas instance.
		 * @return the TextureAtlas instance (there is only oneinstance per app)
		 */
		public static function getAtlas():TextureAtlas
		{
			if (sTextureAtlas == null)
			{
				var texture:Texture=getTexture("AtlasTexture");
				var xml:XML=XML(new AtlasXml());
				sTextureAtlas=new TextureAtlas(texture, xml);

			}

			return sTextureAtlas;
		}

		/**
		 * 
		 * @param name
		 * @return 
		 * @throws ArgumentError
		 */
		public static function getSound(name:String):Sound
		{
			var sound:Sound=sSounds[name] as Sound;
			if (sound)
				return sound;
			else
				throw new ArgumentError("Sound not found: " + name);
		}

		/**
		 * Returns a texture from a texture atlas based on a string key.
		 * 
		 * @param name A key that matches a static constant of Bitmap type.
		 * @return a starling texture.
		 */
		public static function getTexture(name:String):Texture
		{
			if (sTextures[name] == undefined)
			{
				var bitmap:Bitmap=new Assets[name]();
				sTextures[name]=Texture.fromBitmap(bitmap);
			}

			return sTextures[name];
		}

		/**
		 * 
		 */
		public static function prepareSounds():void
		{
			return;
			//sSounds["Step"] = new StepSound();   
		}
	}
}
