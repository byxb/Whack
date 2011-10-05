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
	 * A 'java-style' iterator interface.
	 */
	public interface Iterator
	{
		/**
		 * Returns the current item and moves the iterator to the next item
		 * in the collection. Note that the next() method returns the
		 * <i>first</i> item in the collection when it's first called.
		 * 
		 * @return The next item in the collection.
		 */
		function next():*
		
		/**
		 * Checks if a next item exists.
		 * 
		 * @return True if a next item exists, otherwise false.
		 */
		function hasNext():Boolean
		
		/**
		 * Moves the iterator to the first item in the collection.
		 */
		function start():void
		
		/**
		 * Grants access to the current item being referenced by the iterator.
		 * This provides a quick way to read or write the current data.
		 */
		function get data():*
		
		/**
		 * @private
		 */
		function set data(obj:*):void
	}
}

