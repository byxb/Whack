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
	 * A queue based on a linked list. It's basically a wrapper class for a
	 * linked list to provide FIFO-like access.
	 * 
	 * @see ArrayedQueue
	 */
	public class LinkedQueue implements Collection
	{
		private var _list:SLinkedList;
		
		/**
		 * Initializes a new queue. You can pass an existing singly linked list
		 * to provide queue-like access.
		 * 
		 * @param list An existing list to become the queue.
		 */
		public function LinkedQueue(list:SLinkedList = null)
		{
			if (list == null)
				_list = new SLinkedList();
			else
				_list = list;
		}
		
		/**
		 * Indicates the front item.
		 * 
		 * @return The front item or null if the queue is empty.
		 */
		public function peek():*
		{
			return _list.size > 0 ? _list.head.data : null;
		}
		
		/**
		 * Indicates the most recently added item.
		 * 
		 * @return The last item in the queue or null if the queue is empty.
		 */
		public function back():*
		{
			return _list.size > 0 ? _list.tail.data : null;
		}
		
		/**
		 * Enqueues some data.
		 * 
		 * @param obj The data to enqueue. 
		 */
		public function enqueue(obj:*):void
		{
			_list.append(obj);
		}
		
		/**
		 * Dequeues and returns the front item.
		 * 
		 * @return The front item or null if the queue is empty.
		 */
		public function dequeue():*
		{
			if (_list.size > 0)
			{
				var front:* = _list.head.data;
				_list.removeHead();
				return front;
			}
			return null;
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
			return "[LinkedQueue > " + _list + "]";
		}
		
		/**
		 * Prints out all elements (for debug/demo purposes).
		 * 
		 * @return A human-readable representation of the structure.
		 */
		public function dump():String
		{
			return "LinkedQueue:\n" + _list.dump();
		}
	}
}