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
	 * A stack based on a linked list. It's basically a wrapper class for a
	 * linked list to provide LIFO-like access.
	 * 
	 * @see ArrayedStack 
	 */
	public class LinkedStack implements Collection
	{
		private var _list:DLinkedList;
		
		/**
		 * Initializes a new stack. You can pass an existing doubly
		 * linked list to provide stack-like access.
		 * 
		 * @param list An existing list to become the stack.
		 */
		public function LinkedStack(list:DLinkedList = null)
		{
			if (list == null)
				_list = new DLinkedList();
			else
				_list = list;
		}

		/**
		 * Indicates the top item.
		 *
		 * @return The top item.
		 */
		public function peek():*
		{
			return _list.size > 0 ? _list.tail.data : null;
		}

		/**
		 * Pushes data onto the stack.
		 * 
		 * @param obj The data to insert.
		 */
		public function push(obj:*):void
		{
			_list.append(obj);
		}

		/**
		 * Pops data off the stack.
		 * 
		 * @return A reference to the top item or null if the stack is empty.
		 */
		public function pop():*
		{
			var o:* = _list.size > 0 ? _list.tail.data : null;
			_list.removeTail();
			return o;
		}

		/**
		 * @inheritDoc
		 */
		public function contains(obj:*):Boolean
		{
			return _list.contains(obj);
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			_list.clear();
		}
		
		/**
		 * @inheritDoc
		 */
		public function getIterator():Iterator
		{
			return _list.getIterator();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get size():int
		{
			return _list.size;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isEmpty():Boolean
		{
			return _list.size == 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			return _list.toArray();
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			return "[LinkedStack > " + _list + "]";
		}
		
		/**
		 * Prints out all elements (for debug/demo purposes).
		 * 
		 * @return A human-readable representation of the structure.
		 */
		public function dump():String
		{
			return "LinkedStack:\n" + _list.dump();
		}
	}
}