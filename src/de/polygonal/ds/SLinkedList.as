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
	import de.polygonal.ds.sort.compare.compareStringCaseInSensitive;
	import de.polygonal.ds.sort.compare.compareStringCaseInSensitiveDesc;
	import de.polygonal.ds.sort.compare.compareStringCaseSensitive;
	import de.polygonal.ds.sort.compare.compareStringCaseSensitiveDesc;
	import de.polygonal.ds.sort.sLinkedInsertionSort;
	import de.polygonal.ds.sort.sLinkedInsertionSortCmp;
	import de.polygonal.ds.sort.sLinkedMergeSort;
	import de.polygonal.ds.sort.sLinkedMergeSortCmp;	

	/**
	 * A singly linked list.
	 */
	public class SLinkedList implements Collection
	{
		public static const INSERTION_SORT:int = 1 << 1;
		public static const MERGE_SORT:int     = 1 << 2;
		public static const NUMERIC:int        = 1 << 3;
		public static const DESCENDING:int     = 1 << 4;
		
		private var _count:int;
		
		/**
		 * The head node being referenced. This is the first node in the list.
		 */
		public var head:SListNode;
		
		/**
		 * The tail node being referenced. This is the last node in the list.
		 */
		public var tail:SListNode;
		
		/**
		 * Initializes an empty list. You can add initial items by passing
		 * them as a comma-separated list of values.
		 * 
		 * @param args A list of comma-separated values to append.
		 */
		public function SLinkedList(...args)
		{
			head = tail = null;
			_count = 0;
			
			if (args.length > 0) append.apply(this, args);
		}
		
		/**
		 * Appends items to the list.
		 * 
		 * @param args A list of comma-separated values to append.
		 * 
		 * @return A SListNode object wrapping the data. If multiple values are
		 *         added, the returned node represents the node that stores the
		 *         data of the first argument.
		 */
		public function append(...args):SListNode
		{
			var k:int = args.length;
			
			var node:SListNode = new SListNode(args[0]);
			if (head)
			{
				tail.next = node;
				tail = node;
			}
			else
				head = tail = node;
			
			if (k > 1)
			{
				var t:SListNode = node;
				for (var i:int = 1; i < k; i++)
				{
					node = new SListNode(args[i]);
					tail.next = node;
					tail = node;
				}
				_count += k;
				return t;
			}
			
			_count++;
			return node;
		}
		
		/**
		 * Prepends items to the list.
		 * 
		 * @param args A list of one or more comma-separated values to prepend.
		 * 
		 * @return A SListNode object wrapping the data. If multiple values are
		 *         added, the returned node represents the node that stores the
		 *         data of the first argument.
		 */
		public function prepend(...args):SListNode
		{
			var k:int = args.length;
			var node:SListNode = new SListNode(args[int(k - 1)]);
			if (head)
			{
				node.next = head;
				head = node;
			}
			else
				head = tail = node;
			
			if (k > 1)
			{
				var t:SListNode = node;
				for (var i:int = k - 2; i >= 0; i--)
				{
					node = new SListNode(args[i]);
					node.next = head;
					head = node;
				}
				_count += k;
				return t;
			}
			
			_count++;
			return node;
		}
		
		/**
		 * Inserts an item after a given iterator or appends it if the
		 * iterator is invalid.
		 * 
		 * @param itr An iterator object pointing to the node after which the
		 *            given data is inserted.
		 * @param obj The data to insert.
		 * 
		 * @return A singly linked list node wrapping the data.
		 */
		public function insertAfter(itr:SListIterator, obj:*):SListNode
		{
			if (itr.list != this) return null;
			if (itr.node)
			{
				var node:SListNode = new SListNode(obj);
				itr.node.insertAfter(node);
				if (itr.node == tail)
					tail = itr.node.next;
				
				_count++;
				return node;
			}
			else
			{
				return append(obj);
			}
		}
		
		/**
		* Removes the node the iterator is pointing to while moving the
		* iterator to the next node.
		* 
		* @param itr An iterator object pointing to the node to remove.
		* 
		* @return True if the removal succeeded, otherwise false.
		*/
		public function remove(itr:SListIterator):Boolean
		{
			if (itr.list != this || !itr.node) return false;
			
			var node:SListNode = head;
			if (itr.node == head)
			{
				itr.forth();
				
				//inline
				//if (itr.node) itr.node = itr.node.next;
				
				//todo inline
				removeHead();
				return true;
			}
			
			while (node.next != itr.node) node = node.next;
			itr.forth();
			if (node.next == tail) tail = node;
			node.next = itr.node;
			
			_count--;
			return true;
		}
		
		/**
		 * Removes the head of the list and returns the head's data or null
		 * if the list is empty.
		 * 
		 * @return The data which was associated with the removed node.
		 */
		public function removeHead():*
		{
			if (head)
			{
				var obj:* = head.data;
				
				if (head == tail)
					head = tail = null;
				else
				{
					var node:SListNode = head;
					
					head = head.next;
					node.next = null;
					if (head == null) tail = null;
				}
				_count--;
				
				return obj;
			}
			return null;
		}
		
		/**
		 * Removes the tail of the list and returns the tail's data or null
		 * if the list is empty.
		 * 
		 * @return The data which was associated with the removed node.
		 */
		public function removeTail():*
		{
			if (tail)
			{
				var obj:* = tail.data;
				
				if (head == tail)
					head = tail = null;
				else
				{
					var node:SListNode = head;
					while (node.next != tail)
						node = node.next;
					
					tail = node;
					node.next = null;
				}
				_count--;
				
				return obj;
			}
			return null;
		}
		
		/**
		 * Merges the current list with all lists specified in the paramaters.
		 * The list is directly modified to reflect the changes.
		 * <i>Due to the rearrangement of the node pointers all passed lists
		 * become invalid and should be discarded</i>.
		 * 
		 * @see #concat
		 * 
		 * @param args A list of one or more comma-separated SLinkedList objects.
		 */
		public function merge(...args):void
		{
			if (args.length == 0) return;
			
			var a:SLinkedList;
			
			a = args[0];
			
			if (a.head)
			{
				if (head)
				{
					tail.next = a.head;
					tail = a.tail;
				}
				else
				{
					head = a.head;
					tail = a.tail;
				}
				_count += a.size;
			}
			
			var k:int = args.length;
			for (var i:int = 1; i < k; i++)
			{
				a = args[i];
				if (a.head)
				{
					tail.next = a.head;
					tail = a.tail;
					_count += a.size;
				}
			}
		}
		
		/**
		 * Concatenates the current list with all lists specified in the
		 * parameters and returns a new linked list.
		 * <i>The original list and all passed lists are left unchanged.</i>
		 * 
		 * @see #merge
		 * 
		 * @param args A list of one or more comma-separated SLinkedList objects.
		 * 
		 * @return A copy of the current list which also stores the values from
		 *         the passed lists.
		 */
		public function concat(...args):SLinkedList
		{
			var c:SLinkedList = new SLinkedList();
			var a:SLinkedList, n:SListNode;
			
			n = head;
			while (n)
			{
				c.append(n.data);
				n = n.next;
			}
			var k:int = args.length;
			for (var i:int = 0; i < k; i++)
			{
				a = args[i];
				n = a.head;
				while (n)
				{
					c.append(n.data);
					n = n.next;
				}
			}
			return c;
		}
		
		/**
		 * Sorts the list.
		 * 
		 * The default sorting algorithm is 'mergesort'.
		 * 
		 * If the LinkedList.INSERTION_SORT flag is used, the list is sorted
		 * using the insertion sort algorithm instead, which is much faster for
		 * nearly sorted lists.
		 * <ul><li>default sort behaviour: mergesort, numeric, ascending</li>
		 * <li>sorting is ascending (for character-strings: a precedes z)</li>
		 * <li>sorting is case-sensitive: Z precedes a</li>
		 * <li>the list is directly modified to reflect the sort order</li>
		 * <li>multiple elements that have identical values are placed
		 * consecutively in the sorted array in no particular order</li></ul>
		 * 
		 * @see http://www.chiark.greenend.org.uk/~sgtatham/algorithms/listsort.html
		 * 
		 * @param sortOptions
		 * 
		 * You pass an optional comparison function and/or one or more bitflags
		 * that determine the behavior of the sort method.<br/>
		 * Syntax: myList.sort(compareFunction, flags)<br/><br/>
		 * <i>compareFunction</i> - A comparison function used to determine the
		 *                          sorting order of elements in an array
		 *                          (optional).<br/>
		 *                          It should take two arguments and return a
		 *                          result of -1 if A < B, 0 if A == B and
		 *                          1 if A > B in the sorted sequence.
		 * <br/><br/>
		 * <i>flags</i> - One or more numbers or defined constants, separated by
		 *                the | (bitwise OR) operator, that change the behavior
		 *                of the sort from the default:<br/>
		 *                2  or SortOptions.INSERTION_SORT<br/>
		 *                4  or SortOptions.CHARACTER_STRING<br/>
		 *                8  or SortOptions.CASEINSENSITIVE<br/>
		 *                16 or SortOptions.DESCENDING<br/>
		 **/
		public function sort(...sortOptions):void
		{
			if (_count <= 1) return;
			if (sortOptions.length > 0)
			{
				var b:int = 0;
				var cmp:Function = null;
				
				var o:* = sortOptions[0];
				if (o is Function)
				{
					cmp = o;
					if (sortOptions.length > 1)
					{
						o = sortOptions[1];
						if (o is int)
							b = o;
					}
				}
				else
				if (o is int)
					b = o;
				
				if (Boolean(cmp))
				{
					if (b & 2)
						head = sLinkedInsertionSortCmp(head, cmp, b == 18);
					else
						head = sLinkedMergeSortCmp(head, cmp, b == 16);
				}
				else
				{
					if (b & 2)
					{
						if (b & 4)
						{
							if (b == 22)
								head = sLinkedInsertionSortCmp(head, compareStringCaseSensitiveDesc);
							else
							if (b == 14)
								head = sLinkedInsertionSortCmp(head, compareStringCaseInSensitive);
							else
							if (b == 30)
								head = sLinkedInsertionSortCmp(head, compareStringCaseInSensitiveDesc);
							else
								head = sLinkedInsertionSortCmp(head, compareStringCaseSensitive);
						}
						else
							head = sLinkedInsertionSort(head, b == 18);
					}
					else
					{
						if (b & 4)
						{
							if (b == 20)
								head = sLinkedMergeSortCmp(head, compareStringCaseSensitiveDesc);
							else
							if (b == 12)
								head = sLinkedMergeSortCmp(head, compareStringCaseInSensitive);
							else
							if (b == 28)
								head = sLinkedMergeSortCmp(head, compareStringCaseInSensitiveDesc);
							else
								head = sLinkedMergeSortCmp(head, compareStringCaseSensitive);
						}
						else
						if (b & 16)
							head = sLinkedMergeSort(head, true);
					}
				}
			}
			else
				head = sLinkedMergeSort(head);
		}
		
		/**
		 * Searches for an item in the list by using strict equality (===) and
		 * returns an iterator pointing to the node containing the item or null
		 * if the item was not found.
		 * 
		 * @param  obj  The item to search for
		 * @param  from A SListIterator object pointing to the node in the list
		 *         from which to start searching for the item.
		 *          
		 * @return A SListIterator object pointing to the node with the found
		 *         item or null if no item exists matching the input data or the
		 *         iterator is invalid.
		 */
		public function nodeOf(obj:*, from:SListIterator = null):SListIterator
		{
			if (from != null)
				if (from.list != null)
					return null;
			
			var node:SListNode = (from == null) ? head : from.node;
			while (node)
			{
				if (node.data === obj)
					return new SListIterator(this, node);
				node = node.next;
			}
			return null;
		}
		
		/**
		 * Adds nodes to and removes nodes from the list.
		 * This method directly modifies the list without making a copy.
		 * 
		 * @param start       A SListIterator object pointing to the node where
		 *                    the insertion or deletion begins. The iterator is
		 *                    updated so it still points to the original node,
		 *                    even if the node now belongs to another list.
		 * @param deleteCount An integer that specifies the number of nodes to
		 *                    delete. This number includes the node referenced
		 *                    by the iterator. If no value is specified for the
		 *                    deleteCount parameter, the method deletes all of
		 *                    the nodes from the start iterator to the tail
		 *                    of the list. If the value is 0, no nodes are
		 *                    deleted.
		 * @param args        Specifies the values to insert into the list,
		 *                    starting at the iterator's node.
		 * 
		 * @param return      A SListIterator object containing the nodes that
		 *                    were removed from the original list or null if the
		 *                    iterator is invalid.
		 */
		public function splice(start:SListIterator, deleteCount:uint = 0xffffffff, ...args):SLinkedList
		{
			if (start) if (start.list != this) return null;
			
			if (start.node)
			{
				var s:SListNode = start.node;
				var t:SListNode = head;
				while (t.next != s)
					t = t.next;
					
				var c:SLinkedList = new SLinkedList();
				var i:int, k:int;
				
				if (deleteCount == 0xffffffff)
				{
					if (start.node == tail) return c;
					while (start.node)
					{
						c.append(start.node.data);
						start.remove();
					}
					start.list = c;
					start.node = s;
					return c;
				}
				else
				{
					for (i = 0; i < deleteCount; i++)
					{
						if (start.node)
						{
							c.append(start.node.data);
							start.remove();
						}
						else
							break;
					}
				}
				
				k = args.length;
				if (k > 0)
				{
					if (_count == 0)
					{
						for (i = 0; i < k; i++)
							append(args[i]);
					}
					else
					{
						var n:SListNode;
						if (t == null)
						{
							n = prepend(args[0]);
							for (i = 1; i < k; i++)
							{
								n.insertAfter(new SListNode(args[i]));
								if (n == tail) tail = n.next;
								n = n.next;
								_count++;
							}
						}
						else
						{
							n = t;
							for (i = 0; i < k; i++)
							{
								n.insertAfter(new SListNode(args[i]));
								if (n == tail) tail = n.next;
								n = n.next;
								_count++;
							}
						}
					}
					start.node = n;
				}
				else
					start.node = s;
				
				start.list = c;
				return c;
			}
			return null;
		}
		
		/**
		 * Removes and appends the head node to the tail.
		 */
		public function shiftUp():void
		{
			var t:SListNode = head;
			
			if (head.next == tail)
			{
				head = tail;
				
				tail = t;
				tail.next = null;
				
				head.next = tail;
			}
			else
			{
				head = head.next;
				tail.next = t;
				t.next = null;
				tail = t;
			}
		}
		
		/**
		 * Removes and prepends the tail node to the head.
		 */
		public function popDown():void
		{
			var t:SListNode = tail;
			
			if (head.next == tail)
			{
				tail = head;
				head = t;
				
				tail.next = null;
				head.next = tail;
			}
			else
			{
				var node:SListNode = head;
				while (node.next != tail)
					node = node.next;
				
				tail = node;
				tail.next = null;
				
				t.next = head;
				head = t;
			}
		}
		
		/**
		 * Reverses the linked list in place.
		 */
		public function reverse():void
		{
			if (_count == 0) return;
			var a:Array = new Array(_count), i:int = 0;
			var node:SListNode = head;
			while (node)
			{
				a[i++] = node;
				node = node.next;
			}
			
			a.reverse();
			
			node = head = a[0];
			for (i = 1; i < _count ; i++)
				node = node.next = a[i];
			
			node.next = null;
			tail = node;
			a = null;
		}
		
		/**
		 * Converts the data in the linked list to strings, inserts the given
		 * separator between the elements, concatenates them, and returns the
		 * resulting string.
		 * 
		 * @return A string consisting of the data converted to strings and
		 *         separated by the specified parameter. 
		 */
		public function join(sep:*):String
		{
			if (_count == 0) return "";
			var s:String = "";
			var node:SListNode = head;
			while (node.next)
			{
				s += node.data + sep;
				node = node.next;
			}
			s += node.data;
			return s;
		}
		
		/**
		 * @inheritDoc
		 */
		public function contains(obj:*):Boolean
		{
			var node:SListNode = head;
			while (node)
			{
				if (node.data == obj) return true;
				node = node.next;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			var node:SListNode = head;
			head = null;
			
			var next:SListNode;
			while (node)
			{
				next = node.next;
				node.next = null;
				node = next;
			}
			_count = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getIterator():Iterator
		{
			return new SListIterator(this, head);
		}
		
		/**
		 * Creates a list iterator object pointing to the first node in the list.
		 * 
		 * @returns A SListIterator object.
		 */
		public function getListIterator():SListIterator
		{
			return new SListIterator(this, head);
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
			var a:Array = [];
			var node:SListNode = head;
			while (node)
			{
				a.push(node.data);
				node = node.next;
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
			return "[SlinkedList, size=" + size + "]";
		}
		
		/**
		 * Prints out all elements (for debug/demo purposes).
		 * 
		 * @return A human-readable representation of the structure.
		 */
		public function dump():String
		{
			if (!head)
				return "SLinkedList: (empty)";
			
			var s:String = "SLinkedList: has " + _count + " node" + (_count == 1 ? "" : "s") + "\n|< Head\n";
			
			var itr:SListIterator = getListIterator();
			for (; itr.valid(); itr.forth())
				s += "\t" + itr.data + "\n";
			
			s += "Tail >|";
			
			return s;
		}
	}
}