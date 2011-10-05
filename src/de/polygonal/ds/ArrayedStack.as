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
	 * An arrayed stack.
	 * This is called a LIFO structure (Last In, First Out).
	 * 
	 * @see LinkedStack
	 */
	public class ArrayedStack implements Collection
	{
		private var _stack:Array;
		private var _size:int;
		private var _top:int;
		
		/**
		 * Initializes a stack to match the given size.
		 * 
		 * @param size The maximum allowed size.
		 */
		public function ArrayedStack(size:int)
		{
			_size = size;
			clear();
		}
		
		/**
		 * The stack's maximum capacity. 
		 */
		public function get maxSize():int
		{
			return _size;
		}
		
		/**
		 * Indicates the top item.
		 *
		 * @return The top item.
		 */
		public function peek():*
		{
			return _stack[int(_top - 1)];
		}
		
		/**
		 * Pushes data onto the stack.
		 * 
		 * @param obj The data.
		 */
		public function push(obj:*):Boolean
		{
			if (_size != _top)
			{
				_stack[_top++] = obj;
				return true;
			}
			return false;
		}
		
		/**
		 * Pops data off the stack.
		 * 
		 * @return A reference to the top item or null if the stack is empty.
		 */
		public function pop():*
		{
			if (_top > 0)
				return _stack[--_top];
			return null;
		}
		
		/**
		 * Reads an item at a given index.
		 * 
		 * @param i The index.
		 * 
		 * @return The item at the given index.
		 */
		public function getAt(i:int):*
		{
			if (i >= _top) return null;
			return _stack[i];
		}
		
		/**
		 * Writes an item at a given index.
		 * 
		 * @param i   The index.
		 * @param obj The data.
		 */
		public function setAt(i:int, obj:*):void
		{
			if (i >= _top) return;
			_stack[i] = obj;
		}
		
		/**
		 * @inheritDoc
		 */
		public function contains(obj:*):Boolean
		{
			for (var i:int = 0; i < _top; i++)
			{
				if (_stack[i] === obj)
					return true;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			_stack = new Array(_size);
			_top = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getIterator():Iterator
		{
			return new ArrayedStackIterator(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get size():int
		{
			return _top;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isEmpty():Boolean
		{
			return _top == 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			return _stack.concat();
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			return "[ArrayedStack, size= " + _top + "]";
		}
		
		/**
		 * Prints out all elements (for debug/demo purposes).
		 * 
		 * @return A human-readable representation of the structure.
		 */
		public function dump():String
		{
			var s:String = "[ArrayedStack]";
			if (_top == 0) return s;
			
			var k:int = _top - 1;
			s += "\n\t" + _stack[k--] + " -> front\n";
			for (var i:int = k; i >= 0; i--)
				s += "\t" + _stack[i] + "\n";
			return s;
		}
	}
}

import de.polygonal.ds.ArrayedStack;
import de.polygonal.ds.Iterator;

internal class ArrayedStackIterator implements Iterator
{
	private var _stack:ArrayedStack;
	private var _cursor:int;
	
	public function ArrayedStackIterator(stack:ArrayedStack)
	{
		_stack = stack;
		start();
	}
	
	public function get data():*
	{
		return _stack.getAt(_cursor);
	}
	
	public function set data(obj:*):void
	{
		_stack.setAt(_cursor, obj);
	}
	
	public function start():void
	{
		_cursor = _stack.size - 1;
	}
	
	public function hasNext():Boolean
	{
		return _cursor >= 0;
	}
	
	public function next():*
	{
		if (_cursor >= 0)
			return _stack.getAt(_cursor--);
		return null;
	}
}