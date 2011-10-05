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
	 * A hash table using linked overflow for collision resolving.
	 * <i>Depricated, use the HashMap class instead</i>.
	 * 
	 * @see HashMap
	 */
	public class HashTable implements Collection
	{
		/**
		 * A simple function for hashing strings.
		 */
		public static function hashString(s:String):int
		{
			var hash:int = 0, i:int, k:int = s.length;
			for (i = 0; i < k; i++) hash += (i + 1) * s.charCodeAt(i);
			return hash;
		}
		
		/**
		 * A simple function for hashing integers.
		 */
		public static function hashInt(i:int):int
		{
			return hashString(i.toString());
		}
		
		private var _table:Array;
		private var _hash:Function;
		
		private var _size:int;
		private var _divisor:int;
		private var _count:int;
		
		/**
		 * Initializes a new hash table.
		 * 
		 * @param size The size of the hash table.
		 * @param hash A hashing function.
		 */
		public function HashTable(size:int, hash:Function = null)
		{
			_count = 0;
			
			_hash = (hash == null) ? function(key:int):int { return key; } : hash;
			_table = new Array(_size = size);
			
			for (var i:int = 0; i < size; i++)
				_table[i] = [];
			
			_divisor = _size - 1;
		}
		
		/**
		 * The hash table's maximum capacity.
		 */
		public function get maxSize():int
		{
			return _size;
		}
		
		/**
		 * Inserts a key/data couple into the table.
		 * 
		 * @param key The key.
		 * @param obj The data associated with the key.
		 */
		public function insert(key:*, obj:*):void
		{
			var e:HashEntry = new HashEntry();
			e.key = key;
			e.obj = obj;
			
			_table[int(_hash(key) & _divisor)].push(e);
			_count++;
		}
		
		/**
		 * Finds the entry that is associated with the given key.
		 * 
		 * @param  key The key to search for.
		 * @return The data associated with the key or null if no matching
		 *         entry was found.
		 */
		public function find(key:*):*
		{
			var list:Array = _table[int(_hash(key) & _divisor)];
			var k:int = list.length, entry:HashEntry;
			for (var i:int = 0; i < k; i++)
			{
				entry = list[i];
				if (entry.key === key)
					return entry.obj;
			}
			return null;
		}
		
		/**
		 * Removes an entry based on a given key.
		 * 
		 * @param  key The entry's key.
		 * @return The data associated with the key or null if no matching
		 *         entry was found.
		 */
		public function remove(key:*):*
		{
			var list:Array = _table[int(_hash(key) & _divisor)];
			var k:int = list.length;
			for (var i:int = 0; i < k; i++)
			{
				var entry:HashEntry = list[i];
				if (entry.key === key)
				{
					list.splice(i, 1);
					_count--;
					return entry.obj;
				}
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function contains(obj:*):Boolean
		{
			var list:Array, k:int = size;
			for (var i:int = 0; i < k; i++)
			{
				list = _table[i];
				var l:int = list.length; 
				
				for (var j:int = 0; j < l; j++)
					if (list[j].data === obj) return true;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			_table = new Array(_size);
			_count = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getIterator():Iterator
		{
			return new NullIterator();
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
			return _size == 0;
		}

		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			var a:Array = [], list:Array, k:int = size;
			for (var i:int = 0; i < k; i++)
			{
				list = _table[i];
				var l:int = list.length; 
				
				for (var j:int = 0; j < l; j++)
					a.push(list[j]);
			}
			return a;
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			return "[HashTable, size=" + size + "]";
		}
		
		/**
		 * Prints out all elements (for debug/demo purposes).
		 * 
		 * @return A human-readable representation of the structure.
		 */
		public function dump():String
		{
			var s:String = "HashTable:\n";
			for (var i:int = 0; i < _size; i++)
			{
				if (_table[i])
					s += "[" + i + "]" + "\n" + _table[i];
			}
			return s;
		}
	}
}

/**
 * Simple container class for storing a key/data couple.
 */
internal class HashEntry
{
	public var key:*;
	public var obj:*;
}