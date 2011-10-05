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
	 * A heap is a special kind of binary tree in which every node is greater
	 * than all of its children. The implementation is based on an arrayed
	 * binary tree. It can be used as an efficient priority queue.
	 * 
	 * @see PriorityQueue
	 */
	public class Heap implements Collection
	{
		public var _heap:Array;
		
		private var _size:int;
		private var _count:int;
		private var _compare:Function;
		
		/**
		 * Initializes a new heap.
		 * 
		 * @param size The heap's maximum capacity.
		 * @param compare A comparison function for sorting the heap's data.
		 *                If no function is passed, the heap uses a function for
		 *                comparing numbers.
		 */
		public function Heap(size:int, compare:Function = null)
		{
			_heap = new Array(_size = size + 1);
			_count = 0;
			
			if (compare == null)
				_compare = function(a:int, b:int):int { return a - b; };
			else
				_compare = compare;
		}
		
		/**
		 * The heap's front item.
		 */
		public function get front():*
		{
			return _heap[1];
		}
		
		/**
		 * The heap's maximum capacity.
		 */
		public function get maxSize():int
		{
			return _size;
		}
		
		/**
		 * Enqueues some data.
		 * 
		 * @param obj The data to enqueue.
		 * @return False if the queue is full, otherwise true.
		 */
		public function enqueue(obj:*):Boolean
		{
			if (_count + 1 < _size)
			{
				_heap[++_count] = obj;
				
				var i:int = _count;
				var parent:int = i >> 1;
				var tmp:* = _heap[i];
				var v:*;
				
				if (_compare != null)
				{
					while (parent > 0)
					{
						 v = _heap[parent];
						if (_compare(tmp, v) > 0)
						{
							_heap[i] = v;
							i = parent;
							parent >>= 1;
						}
						else break;
					}
				}
				else
				{
					while (parent > 0)
					{
						v = _heap[parent];
						if (tmp - v > 0)
						{
							_heap[i] = v;
							i = parent;
							parent >>= 1;
						}
						else break;
					}
				}
				
				_heap[i] = tmp;
				return true;
			}
			return false;
		}
		
		/**
		 * Dequeues and returns the front item.
		 * 
		 * @return The heap's front item or null if it is empty.
		 */
		public function dequeue():*
		{
			if (_count >= 1)
			{
				var o:* = _heap[1];
				
				_heap[1] = _heap[_count];
				delete _heap[_count];
				
				var i:int = 1;
				var child:int = i << 1;
				var tmp:* = _heap[i];
				var v:*;
				
				if (_compare != null)
				{
					while (child < _count)
					{
						if (child < _count - 1)
						{
							if (_compare(_heap[child], _heap[int(child + 1)]) < 0)
								child++;
						}
						v = _heap[child];
						if (_compare(tmp, v) < 0)
						{
							_heap[i] = v;
							i = child;
							child <<= 1;
						}
						else break;
					}
				}
				else
				{
					while (child < _count)
					{
						if (child < _count - 1)
						{
							if (_heap[child] - _heap[int(child + 1)] < 0)
								child++;
						}
						v = _heap[child];
						if (tmp - v < 0)
						{
							_heap[i] = v;
							i = child;
							child <<= 1;
						}
						else break;
					}
				}
				_heap[i] = tmp;
				
				_count--;
				return o;
			}
			return null;
		}
		
		/**
		 * Checks if a given item exists.
		 * 
		 * @return True if the item is found, otherwise false.
		 */
		public function contains(obj:*):Boolean
		{
			for (var i:int = 1; i <= _count; i++)
			{
				if (_heap[i] === obj)
					return true;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			_heap = new Array(_size);
			_count = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getIterator():Iterator
		{
			return new HeapIterator(this);
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
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			return _heap.slice(1, _count + 1);
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			return "[Heap, size=" + _size +"]";
		}
		
		/**
		 * Prints out all elements (for debug/demo purposes).
		 * 
		 * @return A human-readable representation of the structure.
		 */
		public function dump():String
		{
			var s:String = "Heap\n{\n";
			var k:int = _count + 1;
			for (var i:int = 1; i < k; i++)
				s += "\t" + _heap[i] + "\n";
			s += "\n}";
			return s;
		}
	}
}

import de.polygonal.ds.Heap;
import de.polygonal.ds.Iterator;

internal class HeapIterator implements Iterator
{
	private var _values:Array;
	private var _length:int;
	private var _cursor:int;
	
	public function HeapIterator(heap:Heap)
	{
		_values = heap.toArray();
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