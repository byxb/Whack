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
	import com.byxb.utils.*;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.*;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * A parallax system that accepts different types of textures to create multiple planes
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class ParallaxSprite extends Sprite
	{

		private var _planes:Dictionary;
		private var _viewport:Rectangle;

		private var _parallaxScale:Point;

		/**
		 * Initializes the Parallax engine
		 * @param viewport the initial viewable area
		 * @param parallaxScaleX allows parralax to be scaled per axis. A low value is better when the primary scrolling is vertical
		 * @param parallaxScaleY allows parralax to be scaled per axis. A low value is better when the primary scrolling is horizontal
		 */
		public function ParallaxSprite(viewport:Rectangle, parallaxScaleX:Number=1, parallaxScaleY:Number=1)
		{
			_planes=new Dictionary(true);
			_viewport=viewport;

			_parallaxScale=new Point(clamp(parallaxScaleX, 0, 1), clamp(parallaxScaleY, 0, 1));
			super();
		}

		/**
		 * returns a modified point based on the parallax engine.  Useful for getting parallax 
		 * data for display objects that live outside the engine.
		 * @param point location
		 * @param speedRatio How close to actual speed (1:1 ratio).
		 * @return point with a position that is the supplied point affected by parallax.
		 */
		public function getParallax(point:Point, speedRatio:Number):Point
		{
			var center:Point=rectCenter(_viewport);
			var parallax:Point=new Point(speedRatio * _parallaxScale.x + 1 - _parallaxScale.x, speedRatio * _parallaxScale.y + 1 - _parallaxScale.y);
			return new Point(interpolate(center.x, point.x, parallax.x), interpolate(center.y, point.y, parallax.y));
		}

		/**
		 * Adds a plane to the parallax system based on a texture that will be stretched to fill the viewport (unless limited by a boundign rectangle).
		 * @param texture the texture to stretch
		 * @param speedRatio How close to actual speed (1:1 ratio).
		 * @param boundingRect Where the stretched image should be displayed.
		 */
		public function addStretchable(texture:Texture, speedRatio:Number=0, boundingRect:Rectangle=null):void
		{
			var img:Image=new StretchImage(texture, boundingRect, _viewport, 20);
			var pd:PlaneData=new PlaneData(img, speedRatio);
			_planes[img]=pd;
			super.addChildAt(img, this.numChildren);
		}

		/**
		 * Adds a plane to the parallax system based on a texture that will be scrolled and tiled using UVdata to fill the viewport (unless limited by a boundign rectangle).
		 * @param texture A texture that tiles along one or bothe axes and fills the texture on that dimension.
		 * @param speedRatio How close to actual speed (1:1 ratio).
		 * @param boundingRect Where the image should be displayed.
		 * @param textureOffset how much to move the texture.  Expressed in pixels and converted to UV
		 * @param tileAxis Indicates which axes are able to scroll.  Use com.byxb.geom.Tiling for axis constants
		 */
		public function addScrollable(texture:Texture, speedRatio:Number=0, boundingRect:Rectangle=null, textureOffset:Point=null, tileAxis:uint=0):void
		{
			if (!textureOffset)
			{
				textureOffset=new Point();
			}
			Tiling.isTileX(tileAxis);
			var tileX:Boolean=Tiling.isTileX(tileAxis);
			var tileY:Boolean=Tiling.isTileY(tileAxis);
			var img:ScrollImage=new ScrollImage(texture, tileAxis, boundingRect, textureOffset, _viewport);
			var pd:PlaneData=new PlaneData(img, speedRatio);
			_planes[img]=pd;
			super.addChildAt(img, this.numChildren);

		}

		/**
		 * Adds a plane to the parallax system based on a texture that will be scrolled and tiled using UVdata to fill the viewport (unless limited by a boundign rectangle).
		 * @param textures a Vector.<Texture> that holds a series of tiles be linked together along an axis. The composite tile itself should be tileable along at lease one axis
		 * @param speedRatio How close to actual speed (1:1 ratio).
		 * @param boundingRect Where the image should be displayed.
		 * @param textureOffset how much to move the texture.  Expressed in pixels and converted to UV
		 * @param tileAxis Indicates which axes are able to scroll.  Use com.byxb.geom.Tiling for axis constants
		 */
		public function addTileable(textures:Vector.<Texture>, speedRatio:Number=0, boundingRect:Rectangle=null, textureOffset:Point=null, tileAxis:uint=0):void
		{

			if (!textureOffset)
				textureOffset=new Point();
			var tile:TileSprite=new TileSprite(textures, null, _viewport, textureOffset, tileAxis);
			var tileX:Boolean=Boolean(tileAxis & 1);
			var tileY:Boolean=Boolean(tileAxis >> 1 & 1);
			super.addChildAt(tile, this.numChildren);
			var pd:PlaneData=new PlaneData(tile, speedRatio, Tiling.isTileX(tileAxis), Tiling.isTileY(tileAxis), boundingRect.x == Number.NEGATIVE_INFINITY ? 0 : boundingRect.x, boundingRect.y == Number.NEGATIVE_INFINITY ? 0 : boundingRect.y, tile.tileWidth, tile.tileHeight);
			_planes[tile]=pd;
		}

		/**
		 * updates each plane according to the plane type to show the areas that is visible within the viewport.
		 * @param viewport
		 */
		public function show(viewport:Rectangle):void
		{
			_viewport=viewport;
			var point:Point=viewport.topLeft;
			var center:Point=rectCenter(viewport);
			var parallax:Point=new Point();
			for (var i:uint=0; i < this.numChildren; i++)
			{
				var img:DisplayObject=this.getChildAt(i) as DisplayObject;
				var pd:PlaneData=_planes[img];
				parallax.setTo(pd.speedRatio * _parallaxScale.x + 1 - _parallaxScale.x, pd.speedRatio * _parallaxScale.y + 1 - _parallaxScale.y);
				switch (pd.type)
				{
					case "ScrollImage":
						var sImg:ScrollImage=img as ScrollImage;
						parallax.x=-(1 - parallax.x);
						parallax.y=-(1 - parallax.y);
						sImg.scrollTo(new Point(center.x * parallax.x, point.y * parallax.y), _viewport);
						break;
					case "TileSprite":
						parallax.x=(1 - parallax.x);
						parallax.y=(1 - parallax.y);
						var tile:TileSprite=img as TileSprite;
						tile.show(_viewport);
						if (pd.tileX)
						{
							var baseX:Number=center.x * parallax.x;
							var halfVP:Number=pd.width * Math.ceil(_viewport.width / 2 / pd.width);
							img.x=baseX - halfVP + Math.round((center.x - baseX) / pd.width) * pd.width;
						}
						else
						{
							img.x=pd.xOffset + interpolate(0, center.x, parallax.x);
						}
						if (pd.tileY)
						{
							var baseY:Number=center.y * parallax.y;
							var halfVPY:Number=pd.height * Math.ceil(_viewport.height / 2 / pd.height);
							img.y=baseY - halfVPY + Math.round((center.y - baseY) / pd.height) * pd.height;
						}
						else
						{
							img.y=pd.yOffset + interpolate(0, center.y, parallax.y);
						}
						break;
					case "StretchImage":
					case "LargeImage":
						parallax.x=interpolate(center.x, 0, parallax.x);
						parallax.y=interpolate(center.y, 0, parallax.y);
						var stImg:StretchImage=img as StretchImage;
						stImg.x=parallax.x;
						stImg.y=parallax.y;
						stImg.show(_viewport);
						break;
				}
			}
		}

		public override function dispose():void
		{
			_planes=null;
			super.dispose();
		}

		public override function addChildAt(child:DisplayObject, index:int):void
		{
			throw new Error("Use addTileable, addScrollable or addStretchable to add a new parallax plane.");
		}
	}

}

import flash.utils.*;

import starling.display.DisplayObject;

/**
 * A data object for storing information about each plane.
 * @author Justin Church  - Justin [at] byxb [dot] com 
 * 
 */
class PlaneData
{

	public var dispObj:DisplayObject;
	public var xOffset:Number;
	public var yOffset:Number;
	public var loopX:Number;
	public var loopY:Number;
	public var speedRatio:Number;
	public var tileX:Boolean;
	public var tileY:Boolean;
	public var width:Number;
	public var height:Number;
	public var type:String;

	/**
	 * A data object for storing information about each plane.
	 * @param displayObject
	 * @param speedRatio
	 * @param tileX
	 * @param tileY
	 * @param xOffset
	 * @param yOffset
	 * @param width
	 * @param height
	 * @param loopX
	 * @param loopY
	 */
	public function PlaneData(displayObject:DisplayObject, speedRatio:Number=1, tileX:Boolean=false, tileY:Boolean=false, xOffset:Number=0, yOffset:Number=0, width:Number=1, height:Number=1, loopX:Number=0, loopY:Number=0)
	{
		this.dispObj=displayObject;
		this.speedRatio=speedRatio;
		this.tileX=tileX;
		this.tileY=tileY;
		this.xOffset=xOffset;
		this.yOffset=yOffset;
		this.width=width;
		this.height=height;
		this.loopX=loopX;
		this.loopY=loopY;
		this.type=getQualifiedClassName(displayObject).split("::")[1];
	}
}

