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
	 * A tree iterator.
	 */
	public class TreeIterator implements Iterator
	{
		/**
		 * Performs a <i>preorder traversal</i> on a tree.
		 * This processes the current tree node before its children.
		 * 
		 * @param node    The tree node to start from.
		 * @param process A process function applied to each traversed node.
		 */
		public static function preorder(node:TreeNode, process:Function):void
		{
			process(node);
			
			var itr:DListIterator = node.children.getIterator() as DListIterator;
			for (; itr.valid(); itr.forth())
				TreeIterator.preorder(itr.data, process);
		}
		
		/**
		 * Performs a <i>postorder traversal</i> on a tree.
		 * This processes the current node after its children.
		 * 
		 * @param node    The tree node to start from.
		 * @param process A process function applied to each traversed node.
		 */
		public static function postorder(node:TreeNode, process:Function):void
		{
			var itr:DListIterator = node.children.getIterator() as DListIterator;
			for (; itr.valid(); itr.forth())
				postorder(TreeNode(itr.data), process);
			
			process(node);
		}
		
		/**
		 * The tree node being referenced.
		 */
		public var node:TreeNode;
		
		private var _childItr:DListIterator;
		private var _stack:LinkedStack;
		
		/**
		 * Initializes a tree iterator pointing to a given tree node.
		 * 
		 * @param node The node the iterator should point to.
		 */
		public function TreeIterator(node:TreeNode = null)
		{
			this.node = node;
			reset();
			
			_stack = new LinkedStack();
			_stack.push(_childItr);
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasNext():Boolean
		{
			if (_stack.size == 0)
				return false;
			else
			{
				var itr:DListIterator = _stack.peek();
				
				if (!itr.hasNext())
				{
					_stack.pop();
					return hasNext();
				}
				else
					return true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function next():*
		{
			if (hasNext())
			{
				var itr:DListIterator = _stack.peek();
				var node:TreeNode = itr.next();
				
				if (node.children.size > 0)
					_stack.push(node.children.getIterator());
				
				return node;
			}
			else
				return null;
		}
		
		/**
		 * Resets the vertical iterator so that it points to the root of the
		 * tree. Also make sures the horizontal iterator points to the first
		 * child.
		 */
		public function start():void
		{
			root();
			childStart();
			
			while (_stack.size > 0) _stack.pop();
			_stack.push(_childItr);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get data():*
		{
			return node.data;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set data(obj:*):void
		{
			node.data = obj;
		}
		
		/**
		 * The current child node being referenced.
		 */
		public function get childNode():TreeNode
		{
			return _childItr.data;
		}
		
		/**
		 * Returns the item the child iterator is pointing to.
		 */
		public function get childData():*
		{
			return TreeNode(_childItr.data).data;
		}

		/**
		 * Checks if the node is valid.
		 */
		public function valid():Boolean
		{
			return Boolean(node);
		}
		
		/**
		 * Moves the iterator to the root of the tree.
		 */
		public function root():void
		{
			if (node)
			{
				while (node.parent)
					node = node.parent;
			}
			reset();
		}
		
		/**
		 * Moves the iterator up by one level of the tree, so that it points to
		 * the parent of the current tree node.
		 */
		public function up():void
		{
			if (node) node = node.parent;
			reset();
		}
		
		/**
		 * Moves the iterator down by one level of the tree, so that it points
		 * to the first child of the current tree node.
		 */
		public function down():void
		{
			if (_childItr.valid())
			{
				node = _childItr.data;
				reset();
			}
		}
		
		/**
		 * Moves the child iterator forward by one position.
		 */
		public function nextChild():void
		{
			_childItr.forth();
		}
		
		/**
		 * Moves the child iterator back by one position.
		 */
		public function prevChild():void
		{
			_childItr.back();
		}
		
		/**
		 * Moves the child iterator to the first child.
		 */
		public function childStart():void
		{
			_childItr.start();
		}
		
		/**
		 * Moves the child iterator to the last child.
		 */
		public function childEnd():void
		{
			_childItr.end();
		}
		
		/**
		 * Determines if the child iterator is valid.
		 */
		public function childValid():Boolean
		{
			return _childItr.valid();
		}
		
		/**
		 * Appends a child node to the child list.
		 * 
		 * @param obj The data to append as a child node.
		 */
		public function appendChild(obj:*):void
		{
			new TreeNode(obj, node);
			
			if (node.children.size == 1)
				childStart();
		}
		
		/**
		 * Prepends a child node to the child list.
		 * 
		 * @param obj The data to prepend as a child node.
		 */
		public function prependChild(obj:*):void
		{
			var childNode:TreeNode = new TreeNode(obj, null);
			childNode.parent = node;
			node.children.prepend(childNode);
			
			if (node.children.size == 1)
				childStart();
		}
		
		/**
		 * Inserts a child node before the current child node.
		 * 
		 * @param obj The data to insert as a child node.
		 */
		public function insertBeforeChild(obj:*):void
		{
			var childNode:TreeNode = new TreeNode(obj, null);
			childNode.parent = node;
			node.children.insertBefore(_childItr, childNode);
			
			if (node.children.size == 1)
				childStart();
		}
		
		/**
		 * Inserts a child node after the current child node.
		 * 
		 * @param obj The data to insert as a child node.
		 */
		public function insertAfterChild(obj:*):void
		{
			var childNode:TreeNode = new TreeNode(obj, null);
			childNode.parent = node;
			node.children.insertAfter(_childItr, childNode);
			
			if (node.children.size == 1)
				childStart();
		}
		
		/**
		 * Unlinks the current child node from the tree.
		 * This does not delete the node.
		 */
		public function removeChild():void
		{
			if (node && _childItr.valid())
			{
				TreeNode(_childItr.data).parent = null;
				node.children.remove(_childItr);
			}
		}
		
		private function reset():void
		{
			if (node)
				_childItr = node.children.getListIterator();
			else
			{
				_childItr.node = null;
				_childItr.list = null;
			}
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			var s:String = "[TreeIterator > pointing to: [V] " + node + " [H] " + (_childItr.data || "(leaf node)");
			return s;
		}
	}
}
