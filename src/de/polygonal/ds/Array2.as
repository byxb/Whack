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
	 * A two-dimensional array.
	 */
	public class Array2 implements Collection
	{
		private var _a:Array;
		private var _w:int, _h:int;
		
		/**
		 * Initializes a two-dimensional array to match a given width and
		 * height. The smallest possible size is a 1x1 matrix. The initial value
		 * of all elements is null.
		 * 
		 * @param w The width  (equals number of colums).
		 * @param h The height (equals number of rows).
		 */
		public function Array2(w:int, h:int)
		{
			if (w < 1 || h < 1)
				throw new Error("illegal size");
			
			_a = new Array(_w = w, _h = h);
			
			fill(null);
		}
		
		/**
		 * Indicates the width (colums).
		 * If a new width is set, the two-dimensional array is resized
		 * accordingly. The minimum value is 2.
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
			resize(w, _h);
		}
		
		/**
		 * Indicates the height (rows).
		 * If a new height is set, the two-dimensional array is resized
		 * accordingly. The minimum value is 2.
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
			resize(_w, h);
		}
		
		/**
		 * Writes a given value into each cell of the two-dimensional array. If
		 * the obj parameter if of type Class, the method creates individual
		 * instances of this class for all array cells.
		 * 
		 * @param item The item to be written into each cell.
		 */
		public function fill(obj:*):void
		{
			var k:int = _w * _h;
			var i:int;
			
			if (obj is Class)
			{
				var c:Class = obj as Class;
				for (i = 0; i < k; i++)
					_a[i] = new c();	
			}
			else
			{
				for (i = 0; i < k; i++)
					_a[i] = obj;
			}
		}
		
		/**
		 * Reads a value from a given x/y index. No boundary check is done, so
		 * you have to make sure that the input coordinates do not exceed the
		 * width or height of the two-dimensional array.
		 *
		 * @param x The x index (column).
		 * @param y The y index (row).
		 * 
		 * @return The value at the given x/y index.
		 */
		public function get(x:int, y:int):*
		{
			return _a[int(y * _w + x)];
		}
		
		/**
		 * Writes a value into a cell at the given x/y index. Because of
		 * performance reasons no boundary check is done, so you have to make
		 * sure that the input coordinates do not exceed the width or height of
		 * the two-dimensional array.
		 *
		 * @param x   The x index (column).
		 * @param y   The y index (row).
		 * @param obj The item to be written into the cell.
		 */
		public function set(x:int, y:int, obj:*):void
		{
			_a[int(y * _w + x)] = obj;
		}
		
		/**
		 * Resizes the array to match the given width and height. If the new
		 * size is smaller than the existing size, values are lost because of
		 * truncation, otherwise all values are preserved. The minimum size
		 * is a 1x1 matrix.
		 * 
		 * @param w The new width (cols).
		 * @param h The new height (rows).
		 */
		public function resize(w:int, h:int):void
		{
			if (w < 1 || h < 1)
				throw new Error("illegal size");
			
			var copy:Array = _a.concat();
			
			_a.length = 0;
			_a.length = w * h;
			
			var minx:int = w < _w ? w : _w;
			var miny:int = h < _h ? h : _h;
			
			var x:int, y:int, t1:int, t2:int;
			for (y = 0; y < miny; y++)
			{
				t1 = y *  w;
				t2 = y * _w;
				
				for (x = 0; x < minx; x++)
					_a[int(t1 + x)] = copy[int(t2 + x)];
			}
			
			_w = w;
			_h = h;
		}
		
		/**
		 * Extracts a row from a given index.
		 * 
		 * @param y The row index.
		 * 
		 * @return An array storing the values of the row.
		 */
		public function getRow(y:int):Array
		{
			var offset:int = y * _w;
			return _a.slice(offset, offset + _w);
		}
		
		/**
		 * Inserts new values into a complete row of the two-dimensional array. 
		 * The new row is truncated if it exceeds the existing width.
		 *
		 * @param y The row index.
		 * @param a The row's new values.
		 */
		public function setRow(y:uint, a:Array):void
		{
			if (y < 0 || y > _h) throw new Error("row index out of bounds");
			
			var offset:int = y * _w;
			for (var x:int = 0; x < _w; x++)
				_a[int(offset + x)] = a[x];	
		}
		
		/**
		 * Extracts a column from a given index.
		 * 
		 * @param x The column index.
		 * 
		 * @return An array storing the values of the column.
		 */
		public function getCol(x:int):Array
		{
			var t:Array = [];
			for (var i:int = 0; i < _h; i++)
				t[i] = _a[int(i * _w + x)];
			return t;
		}
		
		/**
		 * Inserts new values into a complete column of the two-dimensional
		 * array. The new column is truncated if it exceeds the existing height.
		 *
		 * @param x The column index.
		 * @param a The column's new values.
		 */
		public function setCol(x:int, a:Array):void
		{
			if (x < 0 || x > _w) throw new Error("column index out of bounds");
			
			for (var y:int = 0; y < _h; y++)
				_a[int(y * _w + x)] = a[y];	
		}
		
		/**
		 * Shifts all columns by one column to the left. Columns are wrapped,
		 * so the column at index 0 is not lost but appended to the rightmost
		 * column.
		 */
		public function shiftLeft():void
		{
			if (_w == 1) return;
			
			var j:int = _w - 1, k:int;
			for (var i:int = 0; i < _h; i++)
			{
				k = i * _w + j;
				_a.splice(k, 0, _a.splice(k - j, 1));
			}
		}
		
		/**
		 * Shifts all columns by one column to the right. Columns are wrapped,
		 * so the column at the last index is not lost but appended to the
		 * leftmost column.
		 */
		public function shiftRight():void
		{
			if (_w == 1) return;
			
			var j:int = _w - 1, k:int;
			for (var i:int = 0; i < _h; i++)
			{
				k = i * _w + j;
				_a.splice(k - j, 0, _a.splice(k, 1));
			}
		}
		
		/**
		 * Shifts all rows up by one row. Rows are wrapped, so the first row
		 * is not lost but appended to bottommost row.
		 */
		public function shiftUp():void
		{
			if (_h == 1) return;
			
			_a = _a.concat(_a.slice(0, _w));
			_a.splice(0, _w);
		}
		
		/**
		 * Shifts all rows down by one row. Rows are wrapped, so the last row
		 * is not lost but appended to the topmost row.
		 */
		public function shiftDown():void
		{
			if (_h == 1) return;
			
			var offset:int = (_h - 1) * _w;
			_a = _a.slice(offset, offset + _w).concat(_a);
			_a.splice(_h * _w, _w);
		}
		
		/**
		 * Appends a new row. If the new row doesn't match the current width,
		 * the inserted row gets truncated or widened to match the existing
		 * width.
		 *
		 * @param a The row to append.
		 */
		public function appendRow(a:Array):void
		{
			a.length = _w;
			_a = _a.concat(a);
			_h++;
		}
		
		/**
		 * Prepends a new row. If the new row doesn't match the current width,
		 * the inserted row gets truncated or widened to match the existing
		 * width.
		 *
		 * @param a The row to prepend.
		 */
		public function prependRow(a:Array):void
		{
			a.length = _w;
			_a = a.concat(_a);
			_h++;
		}
		
		/**
		 * Appends a new column. If the new column doesn't match the current
		 * height, the inserted column gets truncated or widened to match the
		 * existing height.
		 *
		 * @param a The column to append.
		 */
		public function appendCol(a:Array):void
		{
			a.length = _h;
			for (var y:int = 0; y < _h; y++)
				_a.splice(y * _w + _w + y, 0, a[y]);
			_w++;
		}
		
		/**
		 * Prepends a new column. If the new column doesn't match the current
		 * height, the inserted column gets truncated or widened to match the
		 * existing height.
		 *
		 * @param a The column to prepend.
		 */
		public function prependCol(a:Array):void
		{	
			a.length = _h;
			for (var y:int = 0; y < _h; y++)
				_a.splice(y * _w + y, 0, a[y]);
			_w++;
		}
		
		/**
		 * Flips rows with cols and vice versa.
		 */
		public function transpose():void
		{
			var a:Array = _a.concat();
			for (var y:int = 0; y < _h; y++)
			{
				for (var x:int = 0; x < _w; x++)
					_a[int(x * _w + y)] = a[int(y * _w + x)];
			}
		}
		
		/**
		 * Grants access to the the linear array which is used internally to
		 * store the data in the two-dimensional array. Use with care for
		 * advanced operations.
		 */
		public function getArray():Array
		{
			return _a;
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
			return new Array2Iterator(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get size():int
		{
			return _w * _h;
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
			return "[Array2, width=" + width + ", height=" + height + "]";
		}
		
		/**
		 * Prints out all elements (for debug/demo purposes).
		 * 
		 * @return A human-readable representation of the structure.
		 */
		public function dump():String
		{
			var s:String = "Array2\n{";
			var offset:int, value:*;
			for (var y:int = 0; y < _h; y++)
			{
				s += "\n" + "\t";
				offset = y * _w;
				for (var x:int = 0; x < _w; x++)
				{
					value = _a[int(offset + x)];
					s += "[" + (value != undefined ? value : "?") + "]";
				}
			}
			s += "\n}";
			return s;
		}
	}
}

import de.polygonal.ds.Array2;
import de.polygonal.ds.Iterator;

internal class Array2Iterator implements Iterator
{
	private var _a2:Array2;
	private var _xCursor:int;
	private var _yCursor:int;
	
	public function Array2Iterator(a2:Array2)
	{
		_a2 = a2;
		_xCursor = _yCursor = 0;
	}
	
	public function get data():*
	{
		return _a2.get(_xCursor, _yCursor);
	}
	
	public function set data(obj:*):void
	{
		_a2.set(_xCursor, _yCursor, obj);
	}
	
	public function start():void
	{
		_xCursor = _yCursor = 0;
	}
	
	public function hasNext():Boolean
	{
		return (_yCursor * _a2.width + _xCursor < _a2.size);
	}
	
	public function next():*
	{
		var item:* = data;
		
		if (++_xCursor == _a2.width)
		{
			_yCursor++;
			_xCursor = 0;
		}
		
		return item;
	}
}