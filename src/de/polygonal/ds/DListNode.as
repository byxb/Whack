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
	 * A doubly linked list node.
	 * 
	 * Each node acts as a data container and stores a reference to next and
	 * previous node in the list.
	 */
	public class DListNode implements LinkedListNode
	{
		/**
		 * The node's data.
		 */
		public var data:*;
		
		/**
		 * The next node in the list being referenced.
		 */
		public var next:DListNode;
		
		/**
		 * The previous node in the list being referenced.
		 */
		public var prev:DListNode;
		
		/**
		 * Creates a new node storing a given item.
		 * 
		 * @param obj The data to store inside the node.
		 */
		public function DListNode(obj:*)
		{
			next = prev = null;
			data = obj;
		}
		
		/**
		 * A helper function used solely by the DLinkedList class for inserting
		 * a given node after this node.
		 * 
		 * @param node The node to insert.
		 */
		public function insertAfter(node:DListNode):void
		{
			node.next = next;
			node.prev = this;
			if (next) next.prev = node;
			next = node;
		}
		
		/**
		 * A helper function used solely by the DLinkedList class for inserting
		 * this node in front of a given node.
		 * 
		 * @param node A doubly linked list node.
		 */
		public function insertBefore(node:DListNode):void
		{
			node.next = this;
			node.prev = prev;
			if (prev) prev.next = node;
			prev = node;
		}
		
		/**
		 * A helper function used solely by the DLinkedList class to unlink the
		 * node from the list.
		 */
		public function unlink():void
		{
			if (prev) prev.next = next;
			if (next) next.prev = prev;
			next = prev = null;
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			return "[DListNode, data=" + data + "]";
		}
	}
}