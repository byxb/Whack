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


package world.items
{

	import com.byxb.utils.*;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.*;
	
	import starling.display.Sprite;
	
	import ui.HUD;
	
	import world.items.items.Item;
	import world.items.zones.ItemZone;
	import world.items.zones.NearGroundZone;
	import world.items.zones.ShallowGroundZone;

	/**
	 * The ItemManager defines the grid on which items are placed.  It controls updating items that are visible in the viewport determining which zone controls a grid cell.
	 * The ItemManager also handles collision between the mole and an item. 
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class ItemManager extends Sprite
	{
		private var _zones:Vector.<ItemZone>=new <ItemZone>[];
		private var _items:Vector.<Item>=new <Item>[];
		private var _lastCollisionStart:uint;
		private var _itemHead:uint=0;
		private var _cellSize:uint=Const.ITEMS_CELL_SIZE;
		private var _cellRows:uint=Math.ceil(Const.cameraMaxRect.height / Const.ITEMS_CELL_SIZE);
		private var _cellCols:uint=Math.ceil(Const.cameraMaxRect.width / Const.ITEMS_CELL_SIZE);
		private var _cellGrid:Vector.<Vector.<Item>>;
		private var _topLeftCell:Point=new Point();
		private var _gridHead:Point=new Point();

		/**
		 * creates a new ItemManager with zones and items populated near 0,0
		 */
		public function ItemManager()
		{
			super();
			addZone(new NearGroundZone());
			addZone(new ShallowGroundZone());
			populateItems();

		}

		/**
		 * A reset functionality for level reset.  Currently not used.
		 */
		public function reset():void
		{
			removeChildren(0, -1, true);
			populateItems();
			_lastCollisionStart=0;
			_itemHead=0;
		}

		/**
		 * Create the initial grid and populate it with items.
		 */
		private function populateItems():void
		{
			// display items in the grid for the maximum camera size so that there is no item 
			// creation/destruction on zoom in and out of the camera.  This would let see an 
			// item temporarily when zomed out, but not still be there when moved over at a smaller zoom.
			var leftPx:Number=Const.cameraMaxRect.x;
			var topPx:Number=Const.cameraMaxRect.y;
			var newLeft:int=Math.floor(leftPx / _cellSize);
			var newTop:int=Math.floor(topPx / _cellSize);
			_topLeftCell=new Point(newLeft, newTop);
			_cellGrid=new Vector.<Vector.<Item>>(_cellCols, true);
			//creating a cache for already computed zones.  At a single Y, for each X in the grid, the zone will be the same.
			var zones:Vector.<ItemZone>=new Vector.<ItemZone>(_cellRows, true);

			for (var i:uint=0; i < _cellCols; i++)
			{
				_cellGrid[i]=new Vector.<Item>(_cellRows, true);
				for (var j:uint=0; j < _cellRows; j++)
				{
					zones[j]||=findZone(_topLeftCell.y + j);
					var item:Item=zones[j].createItem();
					_cellGrid[i][j]=item;
					if (item)
					{
						item.x=(_topLeftCell.x + i) * _cellSize + _cellSize / 2;
						item.y=(_topLeftCell.y + j) * _cellSize + _cellSize / 2;
						addChild(item);
					}
				}
			}
		}

		/**
		 * Adds a new ItemZone to the ItemManager.
		 * @param zone an ItemZone that indicates what type of items should be in a vertical range of grid cells
		 */
		private function addZone(zone:ItemZone):void
		{
			_zones.push(zone);
			//TODO: add Sort to make sure that zones are sorted from highest top value to lowest.
		}

		/**
		 * Given the Y of the grid cell, return the controlling ItemZone.
		 * @param y the Y grid coordinate (not the Y pixel value of the grid area)
		 * @return An ItemZone to use for choosing an item
		 */
		private function findZone(y:Number):ItemZone
		{
			var z:ItemZone
			for (var i:uint=0; i < _zones.length; i++)
			{
				if (y >= _zones[i].top)
				{
					z=_zones[i];
				}
			}
			return z;
		}

		/**
		 * Update the grid cells based on the center of the camera (a viewport is not used here since it always uses the camera max)
		 * @param point The center point of the viewport
		 */
		public function show(point:Point):void
		{

			var leftPx:Number=point.x + Const.cameraMaxRect.x;
			var newLeft:int=Math.floor(leftPx / _cellSize);
			var diffX:int=newLeft - _topLeftCell.x;
			var topPx:Number=point.y + Const.cameraMaxRect.y;
			var newTop:int=Math.floor(topPx / _cellSize);
			var diffY:int=newTop - _topLeftCell.y;

			// if the center point has moved enough that the topLeft cell is different from the last run, the edges need
			// to wrap around to the other side.
			
			while (diffX > 0)
			{
				shiftGridRight();
				diffX--;

			}
			
			
			//the mole does not move to the left, so ther is not loop for that behavior
			
			
			while (diffY > 0)
			{
				shiftGridDown();
				diffY--;

			}
			while (diffY < 0)
			{
				shiftGridUp();
				diffY++;

			}

			//process collision
			var collisionRadius:Number=Const.BASE_REACH_RADIUS;

			var startX:int=-1;
			var endX:int=-1;
			
			// determine which cells are close enough to the center to merit running 
			// collision detection.  This radius has to be calculated because future 
			// upgrades for a treasure magnet will change the radius
			
//TODO: this code should be able to be optimized to a calculation rather than a loop
			for (var i:int=0; i < _cellCols; i++)
			{
				var gridX:uint=loop(_gridHead.x + i, _cellCols)
				if (leftPx + gridX * _cellSize > point.x - collisionRadius)
				{
					startX=i;
					break;
				}
			}
			for (i=startX; i < _cellCols; i++)
			{
				gridX=loop(_gridHead.x + i, _cellCols)
				if (leftPx + gridX * _cellSize < point.x + collisionRadius)
				{
					endX=i;
				}
			}

			var startY:int=-1;
			var endY:int=-1;
			for (i=0; i < _cellRows; i++)
			{
				var gridY:uint=loop(_gridHead.y + i, _cellRows);
				if (topPx + gridY * _cellSize > point.y - collisionRadius)
				{
					startY=i;
					break;
				}
			}
			for (i=startY; i < _cellRows; i++)
			{
				gridY=loop(_gridHead.y + i, _cellRows);
				if (topPx + gridY * _cellSize < point.y + collisionRadius)
				{
					endY=i;
				}
			}

			//now run the collision detection 
			for (i=startX; i <= endX; i++)
			{
				gridX=loop(_gridHead.x + i, _cellCols)
				for (var j:uint=startY; j <= endY; j++)
				{
					gridY=loop(_gridHead.y + j, _cellRows);
					var item:Item=_cellGrid[gridX][gridY];
					// avoiding un-needed Square root calls.  I don't actually need the distance, I just need to know if the
					// item is in range
					if (item && Math.pow(point.x - item.x, 2) + Math.pow(point.y - item.y, 2) < Math.pow(collisionRadius, 2))
					{
						item.hit(point);
						HUD.instance.score+=item.VALUE;
						// removing the item from the grid, but not killing the item.  
						// This just means that the next move will not collision detect against the object again.
						_cellGrid[gridX][gridY]=null; 
					}
				}
			}

		}

		/**
		 * Take everything in the left-most column, destroy them and add new items positioned on the right.
		 */
		public function shiftGridRight():void
		{

			var zones:Vector.<ItemZone>=new Vector.<ItemZone>(_cellRows, true);

			for (var j:uint=0; j < _cellRows; j++)
			{
				// The _gridHead property may seem a bit confusing, but it is an index that says which index of the 
				// vector is currently the left-most and the top-most. This is much more efficient that unshifting and pushing.
				var gridY:int=loop(j + _gridHead.y, _cellRows);

				zones[j]||=findZone(j + _topLeftCell.y);
				
				// if there is currently an item in the grid cell, kill it.
				if (_cellGrid[_gridHead.x][gridY])
				{
					_cellGrid[_gridHead.x][gridY].removeFromParent(true);
				}
				
				// see if a new item should be inserted into the gridCell
				var item:Item=_cellGrid[_gridHead.x][gridY]=zones[j].createItem();

				//if so, position and add the item
				if (item)
				{
					item.x=(_topLeftCell.x + _cellCols) * _cellSize + _cellSize / 2;
					item.y=(_topLeftCell.y + j) * _cellSize + _cellSize / 2;
					addChild(item);
				}

			}
			//update the top left cell and the index for showing which vector index is now left-most.
			_topLeftCell.x++;
			_gridHead.x=loop(_gridHead.x + 1, _cellCols)
		}

		/**
		 * Take everything in the Top-most row, destroy them and add new items positioned on the bottom.
		 */
		private function shiftGridDown():void
		{
			//see siftGridRight for details on what the function does.  They are very similar
			var zones:Vector.<ItemZone>=new Vector.<ItemZone>(_cellRows, true);
			for (var j:uint=0; j < _cellCols; j++)
			{
				var gridX:uint=loop((_gridHead.x + j), _cellCols);

				zones[0]||=findZone(_topLeftCell.y + _cellRows);
				if (_cellGrid[gridX][_gridHead.y])
				{
					_cellGrid[gridX][_gridHead.y].removeFromParent(true);
				}
				var item:Item=_cellGrid[gridX][_gridHead.y]=zones[0].createItem();
				if (item)
				{
					item.x=(_topLeftCell.x + j) * _cellSize + _cellSize / 2;
					item.y=(_topLeftCell.y + _cellRows) * _cellSize + _cellSize / 2;
					addChild(item);
				}
			}
			_topLeftCell.y++;
			_gridHead.y=loop(_gridHead.y + 1, _cellRows)
		}

		/**
		 * Take everything in the bottom-most row, destroy them and add new items positioned on the top.
		 */
		private function shiftGridUp():void
		{
			//see siftGridRight for details on what the function does.  They are very similar
			var zones:Vector.<ItemZone>=new Vector.<ItemZone>(_cellRows, true);
			var gridY:uint=loop(_gridHead.y - 1, _cellRows);
			for (var j:uint=0; j < _cellCols; j++)
			{
				var gridX:int=loop(j + _gridHead.x, _cellCols);

				zones[0]||=findZone(_topLeftCell.y - 1);
				if (_cellGrid[gridX][gridY])
				{
					_cellGrid[gridX][gridY].removeFromParent(true);
				}
				var item:Item=_cellGrid[gridX][gridY]=zones[0].createItem();
				if (item)
				{
					item.x=(_topLeftCell.x + j) * _cellSize + _cellSize / 2;
					item.y=(_topLeftCell.y - 1) * _cellSize + _cellSize / 2;
					addChild(item);
				}
			}
			_topLeftCell.y--;
			_gridHead.y=loop(_gridHead.y - 1, _cellRows)
		}
	}
}
