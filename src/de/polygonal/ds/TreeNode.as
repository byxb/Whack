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
	 * A tree node for building a tree data structure.
	 * 
	 * Every tree node has a linked list of child nodes and a pointer to its
	 * parent node. Note that a tree data structure is build of TreeNode
	 * objects, so there is no class that manages a tree structure. 
	 */
	public class TreeNode implements Collection
	{	
		/**
		 * The parent node being referenced.
		 */
		public var parent:TreeNode;
		
		/**
		 * A list of child nodes being referenced.
		 */
		public var children:DLinkedList;
		
		/**
		 * The data being referened.
		 */
		public var data:*;
		
		/**
		 * Creates a tree node.
		 * 
		 * @param obj The data to store inside the node.
		 * @param parent The node's parent.
		 */
		public function TreeNode(obj:* = null, parent:TreeNode = null)
		{
			data = obj;
			children = new DLinkedList();
			
			if (parent)
			{
				this.parent = parent;
				parent.children.append(this);
			}
		}
		
		/**
		 * Counts the total number of tree nodes starting from the current
		 * tree node.
		 */
		public function get size():int
		{
			var c:int = 1;
			var node:DListNode = children.head;
			while (node)
			{
				c += TreeNode(node.data).size;
				node = node.next;
			}
			return c;
		}
		
		/**
		 * Checks if the tree node is a root node.
		 */
		public function isRoot():Boolean
		{
			return !Boolean(parent);
		}
		
		/**
		 * Checks if the tree node is a leaf node.
		 */
		public function isLeaf():Boolean
		{
			return children.size == 0;
		}
		
		/**
		 * Checks if the tree node has child nodes.
		 */
		public function hasChildren():Boolean
		{
			return children.size > 0;
		}
		
		/**
		 * Checks if the tree node has siblings.
		 */
		public function hasSiblings():Boolean
		{
			if (parent)
				return parent.children.size > 1;
			return false;
		}
		
		/**
		 * Checks is the tree node is empty (has no children).
		 */
		public function isEmpty():Boolean
		{
			return children.size == 0;
		}
		
		/**
		 * Computes the depth of the tree, starting from this node.
		 */
		public function get depth():int
		{
			if (!parent) return 0;
			
			var node:TreeNode = this, c:int = 0;
			while (node.parent)
			{
				c++;
				node = node.parent;
			}
			return c;
		}
		
		/**
		 * The total number of children.
		 */
		public function get numChildren():int
		{
			return children.size;
		}
		
		/**
		 * The total number of siblings.
		 */
		public function get numSiblings():int
		{
			if (parent)
				return parent.children.size;
			return 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function contains(obj:*):Boolean
		{
			var found:Boolean = false;
			TreeIterator.preorder(this, function(node:TreeNode):void
			{
				if (obj == node.data)
					found = true;
			});
			return found;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			while (children.head)
			{
				var node:TreeNode = children.head.data;
				children.removeHead();
				node.clear();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getIterator():Iterator
		{
			return new TreeIterator(this);
		}
		
		/**
		 * Creates a tree iterator pointing at this tree node.
		 * 
		 * @returns A TreeIterator object.
		 */
		public function getTreeIterator():TreeIterator
		{
			return new TreeIterator(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			var a:Array = [];
			TreeIterator.preorder(this, function(node:TreeNode):void
			{
				a.push(node.data);
			});
			return a;
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			var s:String = "[TreeNode > " + (parent == null ? "(root)" : "");
			
			if (children.size == 0)
				s += "(leaf)";
			else
				s += " has " + children.size + " child node" + (size > 1 || size == 0 ? "s" : "");
			
			s += ", data=" + data + "]";	
			
			return s;
		}
		
		/**
		 * Prints out all elements (for debug/demo purposes).
		 * 
		 * @return A human-readable representation of the structure.
		 */
		public function dump():String
		{
			var s:String = "";
			TreeIterator.preorder(this, function(node:TreeNode):void
			{
				var d:int = node.depth;
				
				for (var i:int = 0; i < d; i++)
				{
					if (i == d - 1)
						s += "+---";
					else
						s += "|    ";
				}
				s += node + "\n";
			});
			return s;
		}
	}
}