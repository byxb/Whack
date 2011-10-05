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

	import com.byxb.geom.Tiling;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * Takes multiple textures and adds them to the sprite.  Connects on X or Y axis.
	 * Useful for cases of re-joining a large textue that had to be split for whatever reason.
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class CompositeImage extends Sprite
	{
		/**
		 * 
		 * @param textures a Vector.<Texture> containin the various images to be linked
		 * @param linkAxis axis value to use for linking.  Use com.byxb.Tiling for values.
		 */
		public function CompositeImage(textures:Vector.<Texture>, linkAxis:uint=1)
		{
			super();
			var d:uint=0;
			for each (var texture:Texture in textures)
			{
				var img:Image=new Image(texture);
				if (Tiling.isTileX(linkAxis))
				{
					img.x=d;
					d+=texture.frame ? texture.frame.width : texture.width;

				}
				else
				{
					img.y=d;
					d+=texture.frame ? texture.frame.height : texture.height;
				}
				addChild(img)
			}
			this.flatten();
		}
	}
}
