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
	 * A priority queue to manage prioritized data.
	 * The implementation is based on the heap structure.
	 * 
	 * @see Heap
	 */
	public class PriorityQueue implements Collection
	{
		private var _heap:Array;
		private var _size:int;
		private var _count:int;
		private var _posLookup:Dictionary;
		
		/**
		 * Initializes a priority queue with a given size.
		 * 
		 * @param size The size of the priority queue.
		 */
		public function PriorityQueue(size:int)
		{
			_heap = new Array(_size = size + 1);
			_posLookup = new Dictionary(true);
			_count = 0;
		}
		
		/**
		 * The front item or null if the heap is empty.
		 */
		public function get front():Prioritizable
		{
			return _heap[1];
		}
		
		/**
		 * The maximum capacity.
		 */
		public function get maxSize():int
		{
			return _size;
		}
		
		/**
		 * Enqueues a prioritized item.
		 * 
		 * @param obj The prioritized data.
		 * @return False if the queue is full, otherwise true.
		 */
		public function enqueue(obj:Prioritizable):Boolean
		{
			if (_count + 1 < _size)
			{
				_count++;
				_heap[_count] = obj;
				_posLookup[obj] = _count;
				walkUp(_count);
				return true;
			}
			return false;
		}
		
		/**
		 * Dequeues and returns the front item.
		 * This is always the item with the highest priority.
		 * 
		 * @return The queue's front item or null if the heap is empty.
		 */
		public function dequeue():Prioritizable
		{
			if (_count >= 1)
			{
				var o:* = _heap[1];
				delete _posLookup[o];
				
				_heap[1] = _heap[_count];
				walkDown(1);
				
				delete _heap[_count];
				_count--;
				return o;
			}
			return null;
		}
		
		/**
		 * Reprioritizes an item.
		 * 
		 * @param obj         The object whose priority is changed.
		 * @param newPriority The new priority.
		 * @return True if the repriorization succeeded, otherwise false.
		 */
		public function reprioritize(obj:Prioritizable, newPriority:int):Boolean
		{
			if (!_posLookup[obj]) return false;
			
			var oldPriority:int = obj.priority;
			obj.priority = newPriority;
			var pos:int = _posLookup[obj];
			newPriority > oldPriority ? walkUp(pos) : walkDown(pos);
			return true;
		}
		
		/**
		 * Removes an item.
		 * 
		 * @param obj The item to remove.
		 * @return True if removal succeeded, otherwise false.
		 */
		public function remove(obj:Prioritizable):Boolean
		{
			if (_count >= 1)
			{
				var pos:int = _posLookup[obj];
				
				var o:* = _heap[pos];
				delete _posLookup[o];
				
				_heap[pos] = _heap[_count];
				
				walkDown(pos);
				
				delete _heap[_count];
				delete _posLookup[_count];
				_count--;
				return true;
			}
			
			return false;
		}
		
		/**
		 * @inheritDoc
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
			_posLookup = new Dictionary(true);
			_count = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getIterator():Iterator
		{
			return new PriorityQueueIterator(this);
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
			return _heap.slice(1, _count + 1);
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			return "[PriorityQueue, size=" + _size +"]";
		}
		
		/**
		 * Prints all elements (for debug/demo purposes only).
		 */
		public function dump():String
		{
			if (_count == 0) return "PriorityQueue (empty)";
			
			var s:String = "PriorityQueue\n{\n";
			var k:int = _count + 1;
			for (var i:int = 1; i < k; i++)
			{
				s += "\t" + _heap[i] + "\n";
			}
			s += "\n}";
			return s;
		}
		
		private function walkUp(index:int):void
		{
			var parent:int = index >> 1;
			var parentObj:Prioritizable;
			
			var tmp:Prioritizable = _heap[index];
			var p:int = tmp.priority;
			
			while (parent > 0)
			{
				parentObj = _heap[parent];
				
				if (p - parentObj.priority > 0)
				{
					_heap[index] = parentObj;
					_posLookup[parentObj] = index;
					
					index = parent;
					parent >>= 1;
				}
				else break;
			}
			
			_heap[index] = tmp;
			_posLookup[tmp] = index;
		}
		
		private function walkDown(index:int):void
		{
			var child:int = index << 1;
			var childObj:Prioritizable;
			
			var tmp:Prioritizable = _heap[index];
			var p:int = tmp.priority;
			
			while (child < _count)
			{
				if (child < _count - 1)
				{
					if (_heap[child].priority - _heap[int(child + 1)].priority < 0)
						child++;
				}
				
				childObj = _heap[child];
				
				if (p - childObj.priority < 0)
				{
					_heap[index] = childObj;
					_posLookup[childObj] = index;
					
					_posLookup[tmp] = child;
					
					index = child;
					child <<= 1;
				}
				else break;
			}
			_heap[index] = tmp;
			_posLookup[tmp] = index;
		}
    }
}

import de.polygonal.ds.Iterator;
import de.polygonal.ds.PriorityQueue;

internal class PriorityQueueIterator implements Iterator
{
	private var _values:Array;
	private var _length:int;
	private var _cursor:int;
	
	public function PriorityQueueIterator(pq:PriorityQueue)
	{
		_values = pq.toArray();
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