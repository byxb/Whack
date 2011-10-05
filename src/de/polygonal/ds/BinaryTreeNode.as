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
	 * A binary tree node from which you can build a binary tree.
	 * 
	 * A Binary Tree is a simplified tree structure in which every node is only
	 * allowed to have up to two children nodes, which are called the left and
	 * right child.
	 */
	public class BinaryTreeNode
	{
		/**
		 * Performs a <i>preorder traversal</i> on a tree.
		 * This processes the current tree node before its children.
		 * 
		 * @param node    The node to start from.
		 * @param process A process function applied to each traversed node.
		 */
		public static function preorder(node:BinaryTreeNode, process:Function):void
		{
			if (node)
			{
				process(node);
				
				if (node.left)
					BinaryTreeNode.preorder(node.left, process);
				
				if (node.right)
					BinaryTreeNode.preorder(node.right, process);
			}
		}
		
		/**
		 * Performs an <i>inorder traversal</i> on a tree.
		 * This processes the current node in between the child nodes.
		 * 
		 * @param node    The node to start from.
		 * @param process A process function applied to each traversed node.
		 */
		public static function inorder(node:BinaryTreeNode, process:Function):void
		{
			if (node)
			{
				if (node.left)
					BinaryTreeNode.inorder(node.left, process);
				
				process(node);
				
				if (node.right)
					BinaryTreeNode.inorder(node.right, process);
			}
		}
		
		/**
		 * Performs a <i>postorder traversal</i> on a tree.
		 * This processes the current node after its children.
		 * 
		 * @param node    The node to start from.
		 * @param process A process function applied to each traversed node.
		 */
		public static function postorder(node:BinaryTreeNode, process:Function):void
		{
			if (node)
			{
				if (node.left)
					BinaryTreeNode.postorder(node.left, process);
				
				if (node.right)
					BinaryTreeNode.postorder(node.right, process);
				
				process(node);
			}
		}
		
		/**
		 * The left child node being referenced.
		 */
		public var left:BinaryTreeNode;
		
		/**
		 * The right child node being referenced.
		 */
		public var right:BinaryTreeNode;
		
		/**
		 * The parent node being referenced.
		 */
		public var parent:BinaryTreeNode;
		
		/**
		 * The node's data.
		 */
		public var data:*;
		
		/**
		 * Creates an empty node.
		 * 
		 * @param obj The node's data.
		 */
		public function BinaryTreeNode(obj:*)
		{
			this.data = obj;
			parent = left = right = null;
		}
		
		/**
		 * Writes data into the left child.
		 * 
		 * @param obj The data.
		 */
		public function setLeft(obj:*):void
		{
			if (!left)
			{
				left = new BinaryTreeNode(obj);
				left.parent = this;
			}
			else
				left.data = data;
		}
		
		/**
		 * Writes data into the right child.
		 * 
		 * @param obj The data.
		 */
		public function setRight(obj:*):void
		{
			if (!right)
			{
				right = new BinaryTreeNode(obj);
				right.parent = this;
			}
			else
				right.data = data;
		}
		
		/**
		 * Checks if the node is a left node relative to its parent node.
		 * 
		 * @return True if this node is left, otherwise false.
		 */
		public function isLeft():Boolean
		{
			return this == parent.left;
		}
		
		/**
		 * Checks if the node is a right node relative to its parent node.
		 * 
		 * @return True if this node is right, otherwise false.
		 */
		public function isRight():Boolean
		{
			return this == parent.right;
		}
		
		/**
		 * Computes the depth of a tree.
		 * 
		 * @return The depth of the tree.
		 */
		public function getDepth(node:BinaryTreeNode = null):int
		{
			var left:int = -1, right:int = -1;
			
			if (node == null) node = this;
			
			if (node.left)
				left = getDepth(node.left);
			
			if (node.right)
				right = getDepth(node.right);
			
			return ((left > right ? left : right) + 1);
		}
		
		/**
		 * Recursively counts the total number of nodes including this node.
		 */
		public function count():int
		{
			var c:int = 1;
			
			if (left)
				c += left.count();
			
			if (right)
				c += right.count();
			
			return c;
		}
		
		/**
		 * Recursively clears the tree by deleting all child nodes underneath
		 * the node the method is called on.
		 */
		public function destroy():void
		{
			if (left)
				left.destroy();
			
			left = null;
			
			if (right)
				right.destroy();
			
			right = null;
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			return "[BinaryTreeNode, data= " + data + "]";
		}
	}
}