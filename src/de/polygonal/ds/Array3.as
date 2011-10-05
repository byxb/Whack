/**
 * DATA STRUCTURES FOR GAME PROGRAMMERS
 * Copyright (c) 2007 Michael Baczynski, http://www.polygonal.de
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package de.polygonal.ds
{
	/**
	 * A three-dimensional array.
	 */
	public class Array3 implements Collection
	{
		private var _a:Array;
		private var _w:int, _h:int, _d:int;
		
		/**
		 * Initializes a three-dimensional array to match the given width,
		 * height and depth. The smallest possible size is a 1x1x1 matrix.
		 * The initial value of all items is null.
		 * 
		 * @param w The width (equals number of columns).
		 * @param h The height (equals number of rows).
		 * @param d The depth (equals number of layers).
		 */
		public function Array3(w:int, h:int, d:int)
		{
			if (w < 1 || h < 1 || h < 1)
				throw new Error("illegal size");
			
			_a = new Array((_w = w) * (_h = h) * (_d = d));
			
			fill(null);
		}
		
		/**
		 * Indicates the width (columns).
		 * If a new width is set, the three-dimensional array
		 * is resized accordingly.
		 */
		public function get width():int
		{
			return _w;
		}
		
		/**
		 * @private
		 */
		public function set width(w:int):void
		{
			resize(w, _h, _d);
		}
		
		/**
		 * Indicates the height (rows).
		 * If a new height is set, the three-dimensional array
		 * is resized accordingly.
		 */
		public function get height():int
		{
			return _h;
		}
		
		/**
		 * @private
		 */
		public function set height(h:int):void
		{
			resize(_w, h, _d);
		}
		
		/**
		 * Indicates the depth (layers).
		 * If a new depth is set, the three-dimensional array
		 * is resized accordingly.
		 */
		public function get depth():int
		{
			return _d;
		}
		
		/**
		 * @private
		 */
		public function set depth(d:int):void
		{
			resize(_w, _h, d);
		}
		
		/**
		 * Writes a given value into each cell of the three-dimensional array.
		 * 
		 * @param item The item to be written into each cell.
		 */
		public function fill(obj:*):void
		{
			var k:int = size;
			for (var i:int = 0; i < k; i++)
				_a[i] = obj;
		}
		
		/**
		 * Reads a value from a given x/y/z index. No boundary check is done, so
		 * you have to make sure that the input coordinates do not exceed the
		 * width, height or depth of the three-dimensional array.
		 *
		 * @param x The x index (column).
		 * @param y The y index (row).		 * @param z The z index (layer).
		 * 
		 * @return The value at the given x/y/z index.
		 */
		public function get(x:int, y:int, z:int):*
		{
			return _a[int((z * _w * _h) + (y * _w) + x)];
		}
		
		/**
		 * Writes a value into a cell at the given x/y/z index. No boundary
		 * check is done, so you have to make sure that the input coordinates do
		 * not exceed the width, height or depth of the two-dimensional array.
		 *
		 * @param x   The x index (column).
		 * @param y   The y index (row).
		 * @param z   The z index (layer).
		 * @param obj The item to be written into the cell.
		 */
		public function set(x:int, y:int, z:int, obj:*):void
		{
			_a[int((z * _w * _h) + (y * _w) + x)] = obj;
		}
		
		/**
		 * Resizes the array to match the given width, height and depth. If the
		 * new size is smaller than the existing size, values are lost because
		 * of truncation, otherwise all values are preserved.
		 * 
		 * @param w The new width (cols).
		 * @param h The new height (rows).		 * @param d The new depth (layers).
		 */
		public function resize(w:int, h:int, d:int):void
		{
			if (width < 1 || height < 1 || height < 1)
				throw new Error("illegal size");
			
			var tmp:Array = _a.concat();
			
			_a.length = 0;
			_a.length = w * h * d;
			
			if (_a.length == 0)
				return;
			
			var xMin:int = w < _w ? w : _w;
			var yMin:int = h < _h ? h : _h;
			var zMin:int = d < _d ? d : _d;
			
			var x:int, y:int, z:int;
			var t1:int, t2:int, t3:int, t4:int;
			
			for (z = 0; z < zMin; z++)
			{
				t1 = z *  w  * h;
				t2 = z * _w * _h;
				
				for (y = 0; y < yMin; y++)
				{
					t3 = y *  w;
					t4 = y * _w;
					
					for (x = 0; x < xMin; x++)
						_a[t1 + t3 + x] = tmp[t2 + t4 + x];
				}
			}
			
			_w = w;
			_h = h;
			_d = d;
		}
		
		/**
		 * Copies the data from a given depth (layer) into a
		 * two-dimensional array.
		 * 
		 * @param z The layer to extract.
		 * 
		 * @return The layer's data.
		 */
		public function getLayer(z:int):Array2
		{
			var a:Array2 = new Array2(_w, _h);
			var offset:int =  z * _w * _h;
			
			for (var x:int = 0; x < _w; x++)
				for (var y:int = 0; y < _h; y++)
					a.set(x, y, _a[int(offset + (y * _w) + x)]);
			
			return a;
		}
		
		/**
		 * Extracts a row from a given y index and depth (layer).
		 *
		 * @param z The layer containing the row
		 * @param y The row index.
		 * 
		 * @return An array storing the values of the row.
		 */
		public function getRow(z:int, y:int):Array
		{
			var offset:int =  z * _w * _h + y * _w;
			return _a.slice(offset, offset + _w);
		}
		
		/**
		 * Inserts new values into a complete row at a given depth into the
		 * three-dimensional array. The new row is truncated if it exceeds
		 * the existing width.
		 *
		 * @param z The layer containing the existing row.
		 * @param y The row index.
		 * @param a The row's new values.
		 */
		public function setRow(z:int, y:int, a:Array):void
		{
			var offset:int =  z * _w * _h + y * _w;
			for (var i:int = 0; i < _w; i++)
				_a[int(offset + i)] = a[i];
		}

		/**
		 * Extracts a colum from a given index and depth (layer).
		 * 
		 * @param z The layer containing the column.
		 * @param x The column index.
		 * 
		 * @return An array storing the values of the column.
		 */
		public function getCol(z:int, x:int):Array
		{
			var t:Array = [];
			var offset:int = z * _w * _h;
			for (var i:int = 0; i < _h; i++)
				t[i] = _a[int(offset + (i * _w + x))];
			return t;
		}
		
		/**
		 * Inserts new values into a complete column at a given depth into the
		 * three-dimensional array. The new column is truncated if it exceeds
		 * the existing height.
		 *
		 * @param z The layer containing the existing column.
		 * @param x The column index.
		 * @param a The column's new values.
		 */
		public function setCol(z:int, x:int, a:Array):void
		{
			var offset:int = z * _w * _h;
			for (var i:int = 0; i < _h; i++)
				_a[int(offset + (i * _w + x))] = a[i];
		}
		
		/**
		 * Extracts a pile going through the given x,y index.
		 * The order is from bottom to top (lowest to highest layer).
		 *
		 * @param x The column index.
		 * @param y The row index.
		 * 
		 * @return An array storing the values of the pile.
		 */
		public function getPile(x:int, y:int):Array
		{
			var t:Array = [];
			var offset1:int = _w * _h;			var offset2:int = (y * _w + x);
			for (var i:int = 0; i < _d; i++)
				t[i] = _a[int(i * offset1 + offset2)];
			return t;
		}
		
		/**
		 * Inserts new values into a complete pile of the three-dimensional
		 * array going through the given x, y index.
		 * The pile is truncated if it exceeds the existing depth.
		 *
		 * @param x The column index.
		 * @param y The row index.
		 * @param a The pile's new values.
		 */
		public function setPile(x:int, y:int, a:Array):void
		{
			var offset1:int = _w * _h;
			var offset2:int = (y * _w + x);
			for (var i:int = 0; i < _d; i++)
				_a[int(i * offset1 + offset2)] = a[i];
		}
		
		/**
		 * @inheritDoc
		 */
		public function contains(obj:*):Boolean
		{
			var k:int = size;
			for (var i:int = 0; i < k; i++)
			{
				if (_a[i] === obj)
					return true;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			_a = new Array(size);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getIterator():Iterator
		{
			return new Array3Iterator(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get size():int
		{
			return _w * _h * _d;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isEmpty():Boolean
		{
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			var a:Array = _a.concat();
			
			var k:int = size;
			if (a.length > k) a.length = k;
			return a;
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			return "[Array3, size=" + size + "]";
		}
		
		/**
		 * Prints out all elements (for debug/demo purposes).
		 * 
		 * @param z The layer to dump.
		 * @return A human-readable representation of the structure.
		 */
		public function dump(z:int):String
		{
			return getLayer(z).dump();
		}
	}
}

import de.polygonal.ds.Array3;
import de.polygonal.ds.Iterator;

internal class Array3Iterator implements Iterator
{
	private var _values:Array;
	private var _length:int;
	private var _cursor:int;
	
	public function Array3Iterator(a3:Array3)
	{
		_values = a3.toArray();
		_length = _values.length;
		_cursor = 0;
	}
	
	public function get data():*
	{
		return _values[_cursor];
	}
	
	public function set data(obj:*):void
	{
		_values[_cursor] = obj;
	}
	
	public function start():void
	{
		_cursor = 0;
	}
	
	public function hasNext():Boolean
	{
		return _cursor < _length;
	}
	
	public function next():*
	{
		return _values[_cursor++];
	}
}