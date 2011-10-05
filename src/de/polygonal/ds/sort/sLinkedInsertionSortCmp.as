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
	import de.polygonal.ds.SListNode;	
	public function sLinkedInsertionSortCmp(node:SListNode, cmp:Function, descending:Boolean = false):SListNode
	{
		var a:Array = [];
		var k:int = 0;
		
		var h:SListNode = node;
		var n:SListNode = node;
		while (n)
		{
			a[k++] = n.data;
			n = n.next;
		}
		
		var j:int, i:int, val:*;
		
		if (descending)
		{
			if (k <= 1) return h;
			
			for (i = 1; i < k; i++)
			{
				val = a[i]; j = i;
				while ((j > 0) && (cmp(a[int(j - 1)], val) < 0))
				{
					a[j] = a[int(j - 1)];
					j--;
				}
				a[j] = val;
			}
		}
		else
		{
			if (k <= 1) return h;
		
			for (i = 1; i < k; i++)
			{
				val = a[i]; j = i;
				while ((j > 0) && (cmp(a[int(j - 1)], val) > 0))
				{
					a[j] = a[int(j - 1)];
					j--;
				}
				a[j] = val;
			}
		}
		
		n = h, i = 0;
		while (n)
		{
			n.data = a[i++];
			n = n.next;
		}
		return h;
	}
}
