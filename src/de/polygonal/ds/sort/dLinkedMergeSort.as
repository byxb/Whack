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
	import de.polygonal.ds.DListNode;	
	public function dLinkedMergeSort(node:DListNode, descending:Boolean = false):DListNode
	{
		if (!node) return null;
		
		var h:DListNode = node, p:DListNode, q:DListNode, e:DListNode, tail:DListNode;
		var insize:int = 1, nmerges:int, psize:int, qsize:int, i:int;
		
		if (descending)
		{
			while (true)
			{
				p = h;
				h = tail = null;
				nmerges = 0;
				
				while (p)
				{
					nmerges++;
					
					for (i = 0, psize = 0, q = p; i < insize; i++)
					{
						psize++;
						q = q.next;
						if (!q) break;
					}
					
					qsize = insize;
					
					while (psize > 0 || (qsize > 0 && q))
					{
						if (psize == 0)
						{
							e = q; q = q.next; qsize--;
						}
						else
						if (qsize == 0 || !q)
						{
							e = p; p = p.next; psize--;
						}
						else
						if (p.data - q.data >= 0)
						{
							e = p; p = p.next; psize--;
						} 
						else
						{
							e = q; q = q.next; qsize--;
						}
						
						if (tail)
							tail.next = e;
						else
							h = e;
						
						e.prev = tail;
						tail = e;
					}
					p = q;
				}
				
				tail.next = null;
				if (nmerges <= 1)
				{
					return h;
					break;
				}
				insize <<= 1;
			}
		}
		else
		{
			while (true)
			{
				p = h;
				h = tail = null;
				nmerges = 0;
				
				while (p)
				{
					nmerges++;
					
					for (i = 0, psize = 0, q = p; i < insize; i++)
					{
						psize++;
						q = q.next;
						if (!q) break;
					}
					
					qsize = insize;
					
					while (psize > 0 || (qsize > 0 && q))
					{
						if (psize == 0)
						{
							e = q; q = q.next; qsize--;
						}
						else
						if (qsize == 0 || !q)
						{
							e = p; p = p.next; psize--;
						}
						else
						if (p.data - q.data <= 0)
						{
							e = p; p = p.next; psize--;
						} 
						else
						{
							e = q; q = q.next; qsize--;
						}
						
						if (tail)
							tail.next = e;
						else
							h = e;
						
						e.prev = tail;
						tail = e;
					}
					p = q;
				}
				
				tail.next = null;
				if (nmerges <= 1)
				{
					return h;
					break;
				}
				insize <<= 1;
			}
		}
		
		return null;
	}
}
