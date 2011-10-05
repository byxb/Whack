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
	 * A graph node.
	 */
	public class GraphNode
	{
		/**
		 * The node's data being referenced.
		 */
		public var data:*;
		
		/**
		 * An array of arcs connecting this node to other nodes.
		 */
		public var arcs:Array;
		
		/**
		 * A flag indicating whether the node is marked or not. Used by the
		 * depthFirst and breadthFirst methods only.
		 * 
		 * @see Graph#depthFirst		 * @see Graph#breadthFirst
		 */
		public var marked:Boolean;
		
		private var _arcCount:int = 0;
		
		/**
		 * Creates a new graph node.
		 * 
		 * @param obj The data to store inside the node.
		 */
		public function GraphNode(obj:*)
		{
			data = obj;
			arcs = new Array(_arcCount = 0);
			marked = false;
		}
		
		/**
		 * Adds an arc to the current graph node, pointing to a different
		 * graph node and with a given weight.
		 * 
		 * @param target The destination node the arc should point to.
		 * @param weigth The arc's weight.
		 */
		public function addArc(target:GraphNode, weight:Number):void
		{
			arcs[int(_arcCount++)] = new GraphArc(target, weight);
		}

		/**
		 * Removes the arc that points to the given node.
		 * 
		 * @return True if removal was successful, otherwise false.
		 */
		public function removeArc(target:GraphNode):Boolean
		{
			for (var i:int = 0; i < _arcCount; i++)
			{
				if (arcs[i].node == target)
				{
					arcs.splice(i, 1);
					_arcCount--;
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Finds the arc that points to the given node.
		 * 
		 * @param  target The destination node.
		 * 
		 * @return A GraphArc object or null if the arc doesn't exist.
		 */
		public function getArc(target:GraphNode):GraphArc
		{
			for (var i:int = 0 ; i < _arcCount; i++)
			{
				var arc:GraphArc = arcs[i];
				if (arc.node == target) return arc;
			}
			return null;
		}
		
		/**
		 * The number of arcs extending from this node.
		 */
		public function get numArcs():int
		{
			return _arcCount;
		}
	}
}