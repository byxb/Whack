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
package de.polygonal.ds.sort 
{
	public class SortOptions
	{
		/**
		 * A flag that specifies the insertion sort algorithm. You can use this
		 * constant for the options parameter in the sort() method.
		 *
		 * @see de.polygonal.ds.SLinkedList#sort()
		 * @see de.polygonal.ds.DLinkedList#sort()
		 */
		public static const INSERTION_SORT:int   = 1 << 1;
		
		/**
		 * A flag that Specifies character-string sorting. You can use this
		 * constant for the options parameter in the sort() method.
		 * 
		 * @see de.polygonal.ds.SLinkedList#sort()
		 * @see de.polygonal.ds.DLinkedList#sort()
		 */
		public static const CHARACTER_STRING:int = 1 << 2;
		
		/**
		 * A flag that specifies case-insensitive sorting. You can use this
		 * constant for the options parameter in the sort() method.
		 *
		 * @see de.polygonal.ds.SLinkedList#sort()		 * @see de.polygonal.ds.DLinkedList#sort()
		 */
		public static const CASEINSENSITIVE:int = 1 << 3;
		
		/**
		 * A flag that specifies descending sorting. You can use this
		 * constant for the options parameter in the sort() method.
		 *
 		 * @see de.polygonal.ds.SLinkedList#sort()
		 * @see de.polygonal.ds.DLinkedList#sort()
		 */
		public static const DESCENDING:int = 1 << 4;
	}
}
