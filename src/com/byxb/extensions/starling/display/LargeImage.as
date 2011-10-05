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
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 * Extends image to allow for an images whose dimension is uncouples from the texture size.  
	 * Can support infinitely large images.  Can also be used as a form of masking.
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class LargeImage extends Image
	{

		protected var _boundingRect:Rectangle;
		protected var _drawArea:Rectangle=new Rectangle();

		protected var _uPerPixel:Number;
		protected var _vPerPixel:Number;

		protected var _baseViewport:Rectangle;
		protected var _transformedViewport:Rectangle;
		protected var _viewportDirty:Boolean=true;

		/**
		 * The viewport indicating what part of the image should be shown.
		 * @return 
		 */
		public function get viewport():Rectangle  { return computeViewport(); }
		public function set viewport(viewport:Rectangle):void  { _baseViewport=viewport; _viewportDirty=true; }

		/**
		 * Returns true if any part of the image intersects the viewport.
		 * @return 
		 */
		public function get isOnScreen():Boolean  { return _drawArea.width > 0 && _drawArea.height > 0; }

		/**
		 * Extends image to allow for an images whose dimension is uncouples from the texture size.  
		 * @param texture
		 * @param boundingRect
		 * @param viewport
		 */
		public function LargeImage(texture:Texture, boundingRect:Rectangle=null, viewport:Rectangle=null)
		{
			if (!boundingRect)
			{
				_boundingRect=new Rectangle(0, 0, texture.width, texture.height);
			}
			else
			{
				_boundingRect=boundingRect;
			}
			if (!viewport)
			{
				viewport=_boundingRect.clone();
			}
			_uPerPixel=1 / (texture.frame ? texture.frame.width : texture.width);
			_vPerPixel=1 / (texture.frame ? texture.frame.height : texture.height);
			super(texture);

			show(viewport);
		}

		/**
		 * Indicates what part of the viewport should be shown and refreshes the display.
		 * @param viewport
		 */
		public function show(viewport:Rectangle):void
		{
			this.viewport=viewport;
			buildImage();
		}

		/**
		 * Computes what part of the image intersects with the viewport
		 * @return 
		 */
		protected function updateView():Rectangle
		{
			return _drawArea=_boundingRect.intersection(viewport);
		}

		/**
		 * creates the vertices, indices and UVdata for the image portion that should be displayed.
		 */
		protected function buildImage():void
		{
			var drawArea:Rectangle=updateView();
			buildVertices(drawArea);
			buildIndices(drawArea);
			buildTextureCoords(drawArea);
			createVertexBuffer();
		}

		/**
		 * Builds the set of vertices needed to display the current portion of the image
		 * @param drawArea
		 */
		protected function buildVertices(drawArea:Rectangle):void
		{
			if (!isOnScreen)
				return;

			mVertexData.setPosition(0, _drawArea.left, _drawArea.top);
			mVertexData.setPosition(1, _drawArea.right, _drawArea.top);
			mVertexData.setPosition(2, _drawArea.left, _drawArea.bottom);
			mVertexData.setPosition(3, _drawArea.right, _drawArea.bottom);

		}

		/**
		 * This is not needed for LargeImage, but may be useful for future subclasses.
		 * @param drawArea
		 */
		protected function buildIndices(drawArea:Rectangle):void
		{
			//available for override
		}

		/**
		 * Builds the set of UV coordinates needed to display the current portion of the image
		 * @param drawArea
		 */
		protected function buildTextureCoords(drawArea:Rectangle):void
		{
			if (!isOnScreen)
				return;

			var left:Number=(_drawArea.left - _boundingRect.left) * _uPerPixel;
			var right:Number=left + _drawArea.width * _uPerPixel;
			var top:Number=(_drawArea.top - _boundingRect.top) * _vPerPixel;
			var bottom:Number=top + _drawArea.height * _vPerPixel;

			mVertexData.setTexCoords(0, left, top);
			mVertexData.setTexCoords(1, right, top);
			mVertexData.setTexCoords(2, left, bottom);
			mVertexData.setTexCoords(3, right, bottom);
		}

		/**
		 * Helper function to create the viewport rectangle
		 * @return 
		 */
		private function computeViewport():Rectangle
		{
			if (_viewportDirty)
			{
				var viewport:Rectangle=_baseViewport.clone();
				scaleRect(viewport, 1 / scaleX, 1 / scaleY);
				viewport.x-=this.x;
				viewport.y-=this.y;
				_transformedViewport=viewport;
				_viewportDirty=false;
			}
			return _transformedViewport;
		}

		public override function render(support:RenderSupport, alpha:Number):void
		{
			if (isOnScreen)
			{
				super.render(support, alpha);
			}
		}

		public override function getBounds(targetSpace:DisplayObject):Rectangle
		{
			var minX:Number=Number.MAX_VALUE, maxX:Number=-Number.MAX_VALUE;
			var minY:Number=Number.MAX_VALUE, maxY:Number=-Number.MAX_VALUE;
			var position:Vector3D;
			var i:int;

			if (targetSpace == this) // optimization
			{
				return _boundingRect.clone();
			}
			else
			{
				var transformationMatrix:Matrix=getTransformationMatrixToSpace(targetSpace);
				var point:Point=new Point();

				var corners:Vector.<Point>=new <Point>[_boundingRect.topLeft, new Point(_boundingRect.right, _boundingRect.top), new Point(_boundingRect.left, _boundingRect.bottom), _boundingRect.bottomRight];
				for (i=0; i < 4; ++i)
				{
					//position = mVertexData.getPosition(i);
					point.x=corners[i].x;
					point.y=corners[i].y;
					var transformedPoint:Point=transformationMatrix.transformPoint(point);
					minX=Math.min(minX, transformedPoint.x);
					maxX=Math.max(maxX, transformedPoint.x);
					minY=Math.min(minY, transformedPoint.y);
					maxY=Math.max(maxY, transformedPoint.y);
				}
				return new Rectangle(minX, minY, maxX - minX, maxY - minY);
			}

		}
	}
}
