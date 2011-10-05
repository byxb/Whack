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
	import flash.utils.Dictionary;
	
	/**
	 * A set is a collection of values, without any particular order and no
	 * repeated values. The value is its own key.
	 */
	public class Set implements Collection
	{
		private var _set:Dictionary = new Dictionary(true);
		private var _size:int;
		
		/**
		 * Creates a new empty set.
		 */
		public function Set()
		{
			_set = new Dictionary();			
		}
		
		/**
		 * Reads an item from the set.
		 * 
		 * @param obj The item to retrieve.
		 * @return The item matching the obj parameter or null if the item is
		 *         not part of the set.
		 */
		public function get(obj:*):*
		{
			var val:* = _set[obj];
			return val != undefined ? val : null;
		}

		/**
		 * Writes an item to the set.
		 * 
		 * @param obj The item to be added to the set.
		 */
		public function set(obj:*):void
		{
			if (obj == null) return;
			if (obj == undefined) return;
			if (_set[obj]) return;
			
			_set[obj] = obj;
			_size++;
		}
		
		/**
		 * Removes an item from the set.
		 * 
		 * @param  obj The item to remove
		 * @return The removed item or null if the item wasn't contained
		 *         by the set.
		 */
		public function remove(obj:*):Boolean
		{
			if (_set[obj] != undefined)
			{
				delete _set[obj];
				_size--;
				return true;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function contains(obj:*):Boolean
		{
			return _set[obj] != undefined;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			_set = new Dictionary();
			_size = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getIterator():Iterator
		{
			return new SetIterator(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get size():int
		{
			return _size;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isEmpty():Boolean
		{
			return _size == 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			var a:Array = new Array(_size), j:int;
			for (var i:* in _set) a[j++] = i;
			return a;
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			return "[Set, size=" + size + "]";
		}
		
		/**
		 * Prints out all elements (for debug/demo purposes).
		 * 
		 * @return A human-readable representation of the structure.
		 */
		public function dump():String
		{
			var s:String = "Set:\n";
			for each (var i:* in _set)
				s += "[val: " + i + "]\n";
			return s;
		}
	}
}

import de.polygonal.ds.Iterator;
import de.polygonal.ds.Set;

internal class SetIterator implements Iterator
{
	private var _s:Set;
	private var _a:Array;
	private var _cursor:int;
	private var _size:int;
	
	public function SetIterator(s:Set)
	{
		_s = s;
		_a = s.toArray();
		_cursor = 0;
		_size = s.size;
	}
	
	public function next():*
	{
		return _a[_cursor++];
	}
	
	public function hasNext():Boolean
	{
		return _cursor < _size;
	}
	
	public function start():void
	{
		_cursor = 0;
	}

	public function get data():*
	{
		return _a[_cursor];
	}
	
	public function set data(obj:*):void
	{
		_s.remove(_a[_cursor]);
		_s.set(obj);
	}	
}
