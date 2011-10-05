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
	 * A 'java-style' collection interface.
	 */
	public interface Collection
	{
		/**
		 * Determines if the collection contains a given item.
		 * 
		 * @param obj The item to search for.
		 * 
		 * @return True if the item exists, otherwise false.
		 */
		function contains(obj:*):Boolean
		
		/**
		 * Clears all items.
		 */
		function clear():void
		
		/**
		 * Initializes an iterator object pointing to the first item in the
		 * collection.
		 *
		 * @return An iterator object.
		 */
		function getIterator():Iterator
		
		/**
		 * The total number of items.
		 * 
		 * @return The size.
		 */
		function get size():int;
		
		/**
		 * Checks if the collection is empty.
		 * 
		 * @return True if empty, otherwise false.
		 */
		function isEmpty():Boolean
		
		/**
		 * Converts the collection into an array.
		 * 
		 * @return An array.
		 */
		function toArray():Array
	}
}

