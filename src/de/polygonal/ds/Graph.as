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
	 * A linked uni-directional weighted graph structure.
	 * 
	 * The Graph class manages all graph nodes. Each graph node has an array
	 * of arcs, pointing to different nodes.
	 */
	public class Graph implements Collection
	{
		/**
	 	 * The graph's nodes.
	 	 */
		public var nodes:Array;
		
		private var _nodeCount:int;
		private var _maxSize:int;
		
		/**
		 * Creates an empty graph.
		 * 
		 * @param size The total number of nodes the graph can hold.
		 */
		public function Graph(size:int)
		{
			nodes = new Array(_maxSize = size);
			_nodeCount = 0;
		}
		
		/**
		 * The number of nodes the graph can store.
		 */
		public function get maxSize():int
		{
			return _maxSize;
		}
		
		/**
		 * Performs an iterative depth-first traversal starting at a given node.
		 * 
		 * @example The following code shows an example callback function.
		 * The graph traversal runs until the value '5' is found in the data
		 * property of a node instance.
		 * <listing version="3.0">
		 * var visitNode:Function = function(node:GraphNode):Boolean
		 * {
		 *     if (node.data == 5)
		 *         return false; //terminate traversal
		 *     return true;
		 * }
		 * myGraph.depthFirst(graph.nodes[0], visitNode);
		 * </listing>
		 * 
		 * @param node  The graph node at which the traversal starts.
		 * @param visit A callback function which is invoked every time a node
		 *              is visited. The visited node is accessible through
		 *              the function's first argument. You can terminate the
		 *              traversal by returning false in the callback function.
		 */
		public function depthFirst(node:GraphNode, visit:Function):void
		{
			if (!node) return;
			
			var stack:Array = [node];
			var c:int = 1, k:int, i:int;
			var arcs:Array;
			
			var n:GraphNode;
			
			while (c > 0)
			{
				n = stack[--c];
				
				if (n.marked) continue;
				n.marked = true;
				
				visit(n);
				
			    k = n.numArcs, arcs = n.arcs; 
				for (i = 0; i < k; i++)
					stack[c++] = arcs[i].node;
			}
		}
		
		/**
		 * Performs a breadth-first traversal starting at a given node.
		 * 
		 * @example The following code shows an example callback function.
		 * The graph traversal runs until the value '5' is found in the data
		 * property of a node instance.
		 * <listing version="3.0">
		 * var visitNode:Function = function(node:GraphNode):Boolean
		 * {
		 *     if (node.data == 5)
		 *         return false; //terminate traversal
		 *     return true;
		 * }
		 * myGraph.breadthFirst(graph.nodes[0], visitNode);
		 * </listing>
		 * 
		 * @param node  The graph node at which the traversal starts.
		 * @param visit A callback function which is invoked every time a node
		 *              is visited. The visited node is accessible through
		 *              the function's first argument. You can terminate the
		 *              traversal by returning false in the callback function.
		 */
		public function breadthFirst(node:GraphNode, visit:Function):void
		{
			if (!node) return;
			
			var que:Array = new Array(0x10000);
			var divisor:int = 0x10000 - 1;
			var front:int = 0;
			
			que[0] = node; 
			
			node.marked = true;
			
			var c:int = 1, k:int, i:int;
			var arcs:Array;
			
			var v:GraphNode;
			var w:GraphNode;
			
			while (c > 0)
			{
				v = que[front];
				if (!visit(v)) return;				
				arcs = v.arcs, k = v.numArcs;
				for (i = 0; i < k; i++)
				{
					w = arcs[i].node;
					
					if (w.marked) continue;
					w.marked = true;
					que[int((c++ + front) & divisor)] = w;				}
				
				if (++front == 0x10000) front = 0;
				c--;
			}
		}
		
		/**
		 * Adds a node at a given index to the graph.
		 * 
		 * @param obj The data to store in the node.
		 * @param i   The index the node is stored at.
		 * 
		 * @return True if a node was added, otherwise false.
		 */
		public function addNode(obj:*, i:int):Boolean
		{
			if (nodes[i]) return false;
			
			nodes[i] = new GraphNode(obj);
			_nodeCount++;
			return true;
		}
		
		/**
		 * Removes a node from the graph at a given index.
		 * 
		 * @param index The node's index.
		 * 
		 * @return True if removal was successful, otherwise false.
		 */
		public function removeNode(i:int):Boolean
		{
			var node:GraphNode = nodes[i];
			if (!node) return false;
			
			for (var j:int = 0; j < _maxSize; j++)
			{
				var t:GraphNode = nodes[j];
				if (t && t.getArc(node))
					removeArc(j, i);
			}
			
			nodes[i] = null;
			_nodeCount--;
			return true;
		}
		
		/**
		 * Finds an arc pointing to the node at the 'from' index to the node
		 * at the 'to' index.
		 * 
		 * @param from The originating graph node index.
		 * @param to   The ending graph node index.
		 * 
		 * @return A GraphArc object or null if it doesn't exist.
		 */
		public function getArc(from:int, to:int):GraphArc
		{
			var node0:GraphNode = nodes[from];
			var node1:GraphNode = nodes[to];
			if (node0 && node1) return node0.getArc(node1);
			return null;
		}
		
		/**
		 * Adds an arc pointing to the node located at the 'from' index
		 * to the node at the 'to' index.
		 * 
		 * @param from   The originating graph node index.
		 * @param to     The ending graph node index.
		 * @param weight The arc's weight
		 *
		 * @return True if the arc was added, otherwise false.
		 */
		public function addArc(from:int, to:int, weight:int = 1):Boolean
		{
			var node0:GraphNode = nodes[from];
			var node1:GraphNode = nodes[to];
			
			if (node0 && node1)
			{
				if (node0.getArc(node1)) return false;
			
				node0.addArc(node1, weight);
				return true;
			}
			return false;
		}
		
		/**
		 * Removes an arc pointing to the node located at the
		 * 'from' index to the node at the 'to' index.
		 * 
		 * @param from The originating graph node index.
		 * @param to   The ending graph node index.
		 * 
		 * @return True if the arc was removed, otherwise false.
		 */
		public function removeArc(from:int, to:int):Boolean
		{
			var node0:GraphNode = nodes[from];
			var node1:GraphNode = nodes[to];
			
			if (node0 && node1)
			{
				node0.removeArc(node1);
				return true;
			}
			return false;
		}
		
		/**
		 * Marks are used to keep track of the nodes that have been visited
		 * during a depth-first or breadth-first traversal. You must call this
		 * method to clear all markers before starting a new traversal.
		 */
		public function clearMarks():void
		{
			for (var i:int = 0; i < _maxSize; i++)
			{
				var node:GraphNode = nodes[i];
				if (node) node.marked = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		public function contains(obj:*):Boolean
		{
			var n:GraphNode, k:int = _nodeCount;
			for (var i:int = 0; i < k; i++)
			{
				n = nodes[i];
				if (n && n.data == obj) return true;  
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			nodes = new Array(_maxSize);
			_nodeCount = 0;
		}

		/**
		 * @inheritDoc
		 */
		public function getIterator():Iterator
		{
			return new GraphIterator(this);		
		}
		
		/**
		 * @inheritDoc
		 */
		public function get size():int
		{
			return _nodeCount;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isEmpty():Boolean
		{
			return size == 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			var a:Array = [];
			var n:GraphNode, k:int = _nodeCount;
			for (var i:int = 0, j:int = 0; i < k; i++)
			{
				n = nodes[i];
				if (n) a[j++] = n.data;
			}
			return a;
		}
	}
}

import de.polygonal.ds.Graph;
import de.polygonal.ds.GraphNode;
import de.polygonal.ds.Iterator;

internal class GraphIterator implements Iterator
{
	private var _nodes:Array;
	private var _cursor:int;
	private var _size:int;

	public function GraphIterator(graph:Graph)
	{
		_nodes = graph.nodes;
		_size = graph.maxSize;
	}
	
	public function get data():*
	{
		var n:GraphNode = _nodes[_cursor];
		if (n) return n.data;
	}

	public function set data(obj:*):void
	{
		var n:GraphNode = _nodes[_cursor];
		if (n) n.data = obj;
	}
	
	public function start():void
	{
		_cursor = 0;
	}
	
	public function hasNext():Boolean
	{
		return _cursor < _size;
	}

	public function next():*
	{
		if (_cursor < _size)
		{
			var item:* = _nodes[_cursor];
			if (item)
			{
				_cursor++;
				return item;
			}
			
			while (_cursor < _size)
			{
				item = _nodes[_cursor++];
				if (item) return item;
			}
		}
		return null;
	}
}