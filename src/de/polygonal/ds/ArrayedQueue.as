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
	 * A queue based on an array (circular queue).
	 * This is called a FIFO structure (First In, First Out).
	 * 
	 * @see LinkedQueue
	 */
	public class ArrayedQueue implements Collection
	{
		private var _que:Array;
		private var _size:int;
		private var _divisor:int;
		
		private var _count:int;
		private var _front:int;
		
		/**
		 * Initializes a queue object to match the given size.
		 * The size <b>must be a power of two</b> - if not the size is
		 * automatically rounded to the next largest power of 2.
		 * The initial value of all items is null.
		 * 
		 * @param size The queue's size.
		 */
		public function ArrayedQueue(size:int)
		{
			init(size);
		}
		
		/**
		 * The queue's maximum capacity. 
		 */
		public function get maxSize():int
		{
			return _size;
		}
		
		/**
		 * Indicates the front item.
		 * 
		 * @return The front item or null if the queue is empty.
		 */
		public function peek():*
		{
			return _que[_front];
		}
		
		/**
		 * Indicates the most recently added item.
		 * 
		 * @return The last item in the queue or null if the queue is empty.
		 */
		public function back():*
		{
			return _que[int((_count - 1 + _front) & _divisor)];
		}
		
		/**
		 * Enqueues some data.
		 * 
		 * @param  obj The data to enqueue.
		 * 
		 * @return True if the item fits into the queue, otherwise false.
		 */
		public function enqueue(obj:*):Boolean
		{
			if (_size != _count)
			{
				_que[int((_count++ + _front) & _divisor)] = obj;
				return true;
			}
			return false;
		}
		
		/**
		 * Dequeues and returns the front item.
		 * 
		 * @return The front item or null if the queue is empty.
		 */
		public function dequeue():*
		{
			if (_count > 0)
			{
				var data:* = _que[int(_front++)];
				if (_front == _size) _front = 0;
				_count--;
				return data;
			}
			return null;
		}
		
		/**
		 * Deletes the last dequeued item to free it for the garbage collector.
		 * <i>Use only directly after you have invoked dequeue()</i>.
		 * 
		 * @example The following code clears the dequeued item:
		 * <listing version="3.0">
		 * myQueue.dequeue();
		 * myQueue.dispose();
		 * </listing>
		 */
		public function dispose():void
		{
			if (!_front) _que[int(_size  - 1)] = null;
			else 		 _que[int(_front - 1)] = null;
		}
		
		/**
		 * Reads an item relative to the front index.
		 * 
		 * @param i The index of the item.
		 * 
		 * @return The item at the given index.
		 */
		public function getAt(i:int):*
		{
			if (i >= _count) return null;
			return _que[int((i + _front) & _divisor)];
		}
		
		/**
		 * Writes an item relative to the front index.
		 * 
		 * @param i   The index of the item.
		 * @param obj The data.
		 */
		public function setAt(i:int, obj:*):void
		{
			if (i >= _count) return;
			_que[int((i + _front) & _divisor)] = obj;
		}
		
		/**
		 * @inheritDoc
		 */
		public function contains(obj:*):Boolean
		{
			for (var i:int = 0; i < _count; i++)
			{
				if (_que[int((i + _front) & _divisor)] === obj)
					return true;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			_que = new Array(_size);
			_front = _count = 0;
			
			for (var i:int = 0; i < _size; i++) _que[i] = null;	
		}
		
		/**
		 * @inheritDoc
		 */
		public function getIterator():Iterator
		{
			return new ArrayedQueueIterator(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get size():int
		{
			return _count;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isEmpty():Boolean
		{
			return _count == 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			var a:Array = new Array(_count);
			for (var i:int = 0; i < _count; i++)
				a[i] = _que[int((i + _front) & _divisor)];
			return a;
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			return "[ArrayedQueue, size=" + size + "]";
		}
		
		/**
		 * Prints out all elements (for debug/demo purposes).
		 * 
		 * @return A human-readable representation of the structure.
		 */
		public function dump():String
		{
			var s:String = "[ArrayedQueue]\n";
			
			s += "\t" + getAt(i) + " -> front\n";
			for (var i:int = 1; i < _count; i++)
				s += "\t" + getAt(i) + "\n";
			
			return s;
		}
		
		/**
		 * @private
		 */
		private function init(size:int):void
		{
			//check if the size is a power of 2
			if (!(size > 0 && ((size & (size - 1)) == 0)))
			{
				//given a binary integer value x, the next largest power of 2
				//can be computed by a swar algorithm that recursively "folds"
				//the upper bits into the lower bits. this process yields a bit
				//vector with the same most significant 1 as x, but all 1's
				//below it. adding 1 to that value yields the next largest power
				//of 2. for a 32-bit value
				size |= (size >> 1);
				size |= (size >> 2);
				size |= (size >> 4);
				size |= (size >> 8);
				size |= (size >> 16);
				size++;
			}
			
			_size = size;
			_divisor = size - 1;
			clear();
		}
	}
}

import de.polygonal.ds.ArrayedQueue;
import de.polygonal.ds.Iterator;

internal class ArrayedQueueIterator implements Iterator
{
	private var _que:ArrayedQueue;
	private var _cursor:int;
	
	public function ArrayedQueueIterator(que:ArrayedQueue)
	{
		_que = que;
		_cursor = 0;
	}
	
	public function get data():*
	{
		return _que.getAt(_cursor);
	}
	
	public function set data(obj:*):void
	{
		_que.setAt(_cursor, obj);
	}
	
	public function start():void
	{
		_cursor = 0;
	}
	
	public function hasNext():Boolean
	{
		return _cursor < _que.size;
	}
	
	public function next():*
	{
		if (_cursor < _que.size)
			return _que.getAt(_cursor++);
		return null;
	}
}