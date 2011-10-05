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
	import com.byxb.utils.*;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.textures.SubTexture;
	import starling.textures.Texture;

	/**
	 * An Image that stretches the texture to fit the required size.
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class StretchImage extends LargeImage
	{

		/**
		 * An Image that stretches the texture to fit the required size.
		 * @param texture  A texture that will be stretched
		 * @param boundingRect  Where the image should be displayed.
		 * @param viewport the initial viewable area of the image
		 * @param trimTexture how much of the texture to trim to solve for UV imprecision issues with thin textures.
		 */
		public function StretchImage(texture:Texture, boundingRect:Rectangle=null, viewport:Rectangle=null, trimTexture:uint=0):void
		{ 
			//very thin textures frequently have blurry edges due to precision issues with UV.  Trimming a pixel off each side can overcome the issue.
			var trimTextureW:uint = Math.floor(clamp(trimTexture, 0, Math.floor((texture.width-1)/2)));
			var trimTextureH:uint = Math.floor(clamp(trimTexture, 0, Math.floor((texture.height-1)/2)));
			var r:Rectangle = new Rectangle(0,0, texture.width, texture.height);
			r.inflate(-trimTextureW,-trimTextureH); 
			texture = new SubTexture(texture, r);
			
			super(texture, boundingRect, viewport);
			_uPerPixel =1/boundingRect.width;
			_vPerPixel =1/boundingRect.height;
		}
		protected override function buildTextureCoords(drawArea:Rectangle):void{
			
			if(!isOnScreen) return;
		
			var left:Number =_boundingRect.width==Number.POSITIVE_INFINITY?0:(drawArea.left-_boundingRect.left)*_uPerPixel;
			var right:Number = _boundingRect.width==Number.POSITIVE_INFINITY?1:left + drawArea.width*_uPerPixel;
			var top:Number = _boundingRect.height==Number.POSITIVE_INFINITY?0:(drawArea.top-_boundingRect.top)*_vPerPixel;
			var bottom:Number = _boundingRect.height==Number.POSITIVE_INFINITY?1:top + drawArea.height*_vPerPixel;

			mVertexData.setTexCoords(0, left, top );
			mVertexData.setTexCoords(1, right, top);
			mVertexData.setTexCoords(2, left, bottom);
			mVertexData.setTexCoords(3, right, bottom);
		}
	}
}