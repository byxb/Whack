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

	import com.byxb.geom.InfiniteRectangle;
	import com.byxb.geom.Tiling;
	import com.byxb.utils.*;

	import de.polygonal.core.ObjectPool;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * An image that uses a Vector.<Texture> to create a composite image which is then tileable along at least one axis.
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class TileSprite extends Sprite
	{
		private var _boundingRect:Rectangle;
		private var _tilePool:ObjectPool;
		private var _factory:compositeImageFactory;
		private var _offset:Point;
		private var _tileX:Boolean;
		private var _tileY:Boolean;
		private var _tileH:uint;
		private var _tileW:uint;
		private var _tileCountX:uint=0;
		private var _tileCountY:uint=0;

		/**
		 * The size of a single composite tile.
		 * @return 
		 */
		public function get tileWidth():uint  { return _tileW; }
		public function get tileHeight():uint  { return _tileH; }

		public override function get width():Number { return _tileW * _tileCountX; }

		/**
		 * An image that uses a Vector.<Texture> to create a composite image which is then tileable along at least one axis.
		 * @param textures Vector.<Texture> holding textures that will be linked along an axis to make a composite texture.
		 * @param boundingRect Where the image should be displayed.
		 * @param viewport the initial viewable area of the image
		 * @param offset the upper left corner of the composite tile.
		 * @param tileAxis Indicates which axes are able to scroll.  Use com.byxb.geom.Tiling for axis constants
		 */
		public function TileSprite(textures:Vector.<Texture>, boundingRect:Rectangle=null, viewport:Rectangle=null, offset:Point=null, tileAxis:uint=1)
		{
			super();
			_boundingRect=boundingRect;
			_boundingRect||=InfiniteRectangle.FULL_RECT;
			_tilePool=new ObjectPool(true);

			_factory=new compositeImageFactory(textures);
			_tilePool.setFactory(_factory);
			_tilePool.allocate(1);
			_tileX=Tiling.isTileX(tileAxis);
			_tileY=Tiling.isTileY(tileAxis);
			var ci:Object=_tilePool.object;
			_tileW=ci.width;
			_tileH=ci.height;
			_tilePool.object=ci;
			_offset=offset;
			_offset||=new Point();
			_offset.x=_boundingRect.x == Number.NEGATIVE_INFINITY ? 0 : _boundingRect.x;
			_offset.y=_boundingRect.y == Number.NEGATIVE_INFINITY ? 0 : _boundingRect.y;
			show(viewport);
		}

		/**
		 * Sets the visible area of the image and builds as many tiles as needed.
		 * @param viewport
		 * @param offset
		 */
		public function show(viewport:Rectangle, offset:Point=null):void
		{
			offset||=new Point();
			if (!viewport)
			{
				this.addChild(_tilePool.object);
				return;
			}

			var xTilesNeeded:uint=_tileX ? Tiling.getTileCount(_tileW, viewport.width) : 1;
			var yTilesNeeded:uint=_tileY ? Tiling.getTileCount(_tileH, viewport.height) : 1;
			if (_tileCountX + _tileCountY == 0)
			{
				for (var j:uint=0; j < xTilesNeeded; j++)
				{
					for (var i:uint=0; i < yTilesNeeded; i++)
					{

						buildTile(j, i);

					}
				}
				_tileCountX=xTilesNeeded;
				_tileCountY=yTilesNeeded;
			}

			while (_tileCountX < xTilesNeeded)
			{
				for (i=0; i < _tileCountY; i++)
				{
					buildTile(_tileCountX, i);
				}
				_tileCountX++
			}

			while (_tileCountY < yTilesNeeded)
			{
				for (i=0; i < _tileCountX; i++)
				{
					buildTile(i, _tileCountY);
				}
				_tileCountY++
			}
		}

		/**
		 * pulls a tile from a pool of tiles.
		 * @param col
		 * @param row
		 */
		private function buildTile(col:uint, row:uint):void
		{
			var ci:CompositeImage=_tilePool.object as CompositeImage;
			ci.x=_offset.x + col * _tileW;
			ci.y=_offset.y + row * _tileH;
			ci.touchable=false;
			addChild(ci)
		}

		public override function dispose():void
		{
			_tilePool.deconstruct();
		}
	}

}
import de.polygonal.core.ObjectPoolFactory;

import com.byxb.extensions.starling.display.CompositeImage;

import starling.textures.Texture;

/**
 * builds the pool elements
 * @author Justin Church  - Justin [at] byxb [dot] com 
 * 
 */
internal class compositeImageFactory implements ObjectPoolFactory
{
	private var _textures:Vector.<Texture>;


	public function compositeImageFactory(textures:Vector.<Texture>)
	{
		_textures=textures;
	}

	/**
	 * creates a new Composite image for the pool manager.
	 * @return 
	 */
	public function create():*
	{
		return new CompositeImage(_textures);
	}
}
