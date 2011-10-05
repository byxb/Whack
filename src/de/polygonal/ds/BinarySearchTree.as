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
	 * A Binary Search Tree (BST).
	 * 
	 * A BST stores data in a recursive manner so that you can access it quickly
	 * by using a key. Therefore, a BST automatically sorts data as it is
	 * inserted. For a BST to be valid, every node has to follow two rules:
	 * <ol><li>The data value in the left subtree must be less than the data
	 * value in the current node.</li><li>The data value in the right subtree
	 * must be greater than the data value in the current node.</li></ol> 
	 */
	public class BinarySearchTree implements Collection
	{
		/**
		 * The root node being referenced.
		 */
		public var root:BinaryTreeNode;
		
		private var _compare:Function;
		
		/**
		 * Initializes a BST tree with a given comparison function. The function
		 * should return -1 if the left is 'less than' the right, 0 if they are
		 * equal, and 1 if the left is 'greater than' the right. If the function
		 * is omitted, the BST uses a default function for comparing integers.
		 * 
		 * @param compare The comparison function.
		 */
		public function BinarySearchTree(compare:Function = null)
		{
			root = null;
			
			if (compare == null)
			{
				_compare = function(a:int, b:int):int
				{
					return a - b;
				};
			}
			else
				_compare = compare;
		}
		
		/**
		 * Inserts an item into the tree.
		 * 
		 * @param obj The data.
		 */
		public function insert(obj:*):void
		{
			var cur:BinaryTreeNode = root;
			
			if (!root) root = new BinaryTreeNode(obj);
			else
			{
				while (cur)
				{
					if (_compare(obj, cur.data) < 0)
					{
						if (cur.left)
							cur = cur.left;
						else
						{
							cur.setLeft(obj);
							return;
						}
					}
					else
					{
						if (cur.right)
							cur = cur.right;
						else
						{
							cur.setRight(obj);
							return;
						}
					}
				}
			}
		}
		
		/**
		 * Finds a piece of data in the tree and returns a reference to the node
		 * that contains a match, or null if no match is found.
		 * 
		 * @param obj The data to find.
		 * 
		 * @return A node containing the data or null if the data wasn't found.
		 */
		public function find(obj:*):BinaryTreeNode
		{
			var cur:BinaryTreeNode = root, i:int;
			while (cur)
			{
				i = _compare(obj, cur.data);
				trace("I" + i);
				if (i == 0) return cur;
				cur = i < 0 ? cur.left : cur.right;
			}
			return null;
		}
		
		/**
		 * Removes a node from the BST.
		 *
		 * @param node The node to remove.
		 */
		public function remove(node:BinaryTreeNode):void
		{
			if (node.left && node.right)
			{
				var t:BinaryTreeNode = node;
				while (t.right) t = t.right;
				
				if (node.left == t)
				{
					t.right = node.right;
					t.right.parent = t;
				}
				else
				{
					t.parent.right = t.left;
					if (t.left) t.left.parent = t.parent;
					
					t.left = node.left;
					t.left.parent = t;
					t.right = node.right;
					t.right.parent = t;
				}
				
				if (node == root)
					root = t;
				else
				{
					if (node.isLeft())
						node.parent.left = t;
					else
						node.parent.right = t;
				}
				
				t.parent = node.parent;
				node.left = null;
				node.right = null;
				node = null;
			}
			else
			{
				var child:BinaryTreeNode = null;
				
				if (node.left)
					child = node.left;
				else
				if (node.right)
					child = node.right;
					
				if (node == root)
					root = child;
				else
				{
					if (node.isLeft())
						node.parent.left = child;
					else
						node.parent.right = child;
				}
				
				if (child) child.parent = node.parent;
				node.left = node.right = node.parent = null;
				node = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function contains(obj:*):Boolean
		{
			return find(obj) != null;
		}
		
		/**
		 * The tree is cleared recursively, starting from the node on which the
		 * method is called.
		 * 
		 * @copy Collection#clear()
		 */
		public function clear():void
		{
			if (root)
			{
				root.destroy();
				root = null;
			}
		}
		
		/**
		 * An iterator is not supported, use BinaryTreeNode.preorder(),
		 * inorder() and postorder() instead.
		 * 
		 * @see BinaryTreeNode#preorder		 * @see BinaryTreeNode#inorder		 * @see BinaryTreeNode#postorder
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
			return root ? root.count() : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isEmpty():Boolean
		{
			return root ? (root.count() == 0) : true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			var a:Array = [];
			var copy:Function = function(node:BinaryTreeNode):void
			{
				a.push(node.data);
			};
			BinaryTreeNode.inorder(root, copy);
			return a;
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			return "[BST, size=" + size + "]";
		}
		
		/**
		 * Prints out all elements (for debug/demo purposes).
		 * 
		 * @return A human-readable representation of the structure.
		 */
		public function dump():String
		{
			var s:String = "";
			var dumpNode:Function = function (node:BinaryTreeNode):void
			{
				s += node + "\n";
			};
			BinaryTreeNode.inorder(root, dumpNode);
			return s;
		}
	}
}