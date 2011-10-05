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
	 * A hash table using direct lookup (perfect hashing).
	 * Each key can only map one value at a time and multiple keys can map the
	 * same value. The HashMap is preallocated according to an initial size, but
	 * afterwards automatically resized if the number of key-value pairs exceeds
	 * the predefined size.
	 */
	public class HashMap implements Collection
	{
		private var _keyMap:Dictionary;
		private var _dupMap:Dictionary;
		
		private var _initSize:int;
		private var _maxSize:int;
		private var _size:int;

		private var _pair:PairNode;
		private var _head:PairNode;
		private var _tail:PairNode;
		
		/**
		 * Initializes a new HashMap instance.
		 * 
		 * @param size The initial capacity of the HashMap. 
		 */
		public function HashMap(size:int = 500)
		{
			_initSize = _maxSize = Math.max(10, size);
			
			_keyMap = new Dictionary(true);
			_dupMap = new Dictionary(true);
			_size = 0;
			
			var node:PairNode = new PairNode();
			_head = _tail = node;
			
			var k:int = _initSize + 1;
			for (var i:int = 0; i < k; i++)
			{
				node.next = new PairNode();
				node = node.next;
			}
			_tail = node;
		}
		
		/**
		 * Inserts a key/data couple into the table.
		 * 
		 * @param key The key.
		 * @param obj The data associated with the key.
		 */
		public function insert(key:*, obj:*):Boolean
		{
			if (key == null)  return false;
			if (obj == null)  return false;
			if (_keyMap[key]) return false;
			
			if (_size++ == _maxSize)
			{
				var k:int = (_maxSize += _initSize) + 1;
				for (var i:int = 0; i < k; i++)
				{
					_tail.next = new PairNode();
					_tail = _tail.next;
				}
			}
			
			var pair:PairNode = _head;
			_head = _head.next;
			pair.key = key;
			pair.obj = obj;
			
			pair.next = _pair;
			if (_pair) _pair.prev = pair;
			_pair = pair;
			
			_keyMap[key] = pair;
			_dupMap[obj] ? _dupMap[obj]++ : _dupMap[obj] = 1;
			
			return true;
		}
		
		/**
		 * Finds the value that is associated with the given key.
		 * 
		 * @param  key The key mapping a value.
		 * @return The data associated with the key or null if no matching
		 *         entry was found.
		 */
		public function find(key:*):*
		{
			var pair:PairNode = _keyMap[key];
			if (pair) return pair.obj;
			return null;
		}
		
		/**
		 * Removes a value based on a given key.
		 * 
		 * @param  key The entry's key.
		 * @return The data associated with the key or null if no matching
		 *         entry was found.
		 */
		public function remove(key:*):*
		{
			var pair:PairNode = _keyMap[key];
			if (pair)
			{
				var obj:* = pair.obj;
				
				delete _keyMap[key];
				
				if (pair.prev) pair.prev.next = pair.next;
				if (pair.next) pair.next.prev = pair.prev;
				if (pair == _pair) _pair = pair.next;
				
				pair.prev = null;
				pair.next = null;
				_tail.next = pair;
				_tail = pair;
				
				if (--_dupMap[obj] <= 0)
					delete _dupMap[obj];
				
				if (--_size <= (_maxSize - _initSize))
				{
					var k:int = (_maxSize -= _initSize) + 1;
					for (var i:int = 0; i < k; i++)
						_head = _head.next;
				}
				
				return obj;
			}
			return null;
		}
		
		/**
		 * Checks if a mapping exists for the given key.
		 * 
		 * @return True if key exists, otherwise false.
		 */
		public function containsKey(key:*):Boolean
		{
			return _keyMap[key] != undefined;
		}
		
		/**
		 * Writes all keys into an array.
		 * 
		 * @return An array containing all keys.
		 */
		public function getKeySet():Array
		{
			var a:Array = new Array(_size), i:int;
			for each (var p:PairNode in _keyMap)
				a[i++] = p.key;
			return a;
		}
		
		/**
		 * @inheritDoc
		 */
		public function contains(obj:*):Boolean
		{
			return _dupMap[obj] > 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			_keyMap = new Dictionary(true);
			_dupMap = new Dictionary(true);
			
			var t:PairNode;
			var n:PairNode = _pair;
			while (n)
			{
				t = n.next;
				
				n.next = n.prev = null;
				n.key = null;
				n.obj = null;
				_tail.next = n;
				_tail = _tail.next;
				
				n = t;
			}
			
			_pair = null;
			_size = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getIterator():Iterator
		{
			return new HashMapIterator(_pair);
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
			var a:Array = new Array(_size), i:int;
			for each (var p:PairNode in _keyMap)
				a[i++] = p.obj;
			return a;
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			return "[HashMap, size=" + size + "]";
		}
		
		/**
		 * Prints out all elements (for debug/demo purposes).
		 * 
		 * @return A human-readable representation of the structure.
		 */
		public function dump():String
		{
			var s:String = "HashMap:\n";
			for each (var p:PairNode in _keyMap)
				s += "[key: " + p.key + ", val:" + p.obj + "]\n";
			return s;
		}
	}
}

import de.polygonal.ds.HashMap;
import de.polygonal.ds.Iterator;

internal class PairNode
{
	public var key:*;
	public var obj:*;
	
	public var prev:PairNode;
	public var next:PairNode;
}

internal class HashMapIterator implements Iterator
{
	private var _pair:PairNode;
	private var _walker:PairNode;
	
	public function HashMapIterator(pairList:PairNode)
	{
		_pair = _walker = pairList;
	}
	
	public function get data():*
	{
		return _walker.obj;
	}

	public function set data(obj:*):void
	{
		_walker.obj = obj;
	}

	public function start():void
	{
		_walker = _pair;
	}
	
	public function hasNext():Boolean
	{
		return _walker != null;
	}

	public function next():*
	{
		var obj:* = _walker.obj;
		_walker = _walker.next;
		return obj;
	}
}