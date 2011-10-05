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
	 * A bit-vector.
	 * 
	 * A bit-vector is meant to condense bit values (or booleans) into an array
	 * as close as possible so that no space is wasted.
	 */
	public class BitVector
	{
		private var _bits:Array;
		private var _arrSize:int;
		private var _bitSize:int;
		
		/**
		 * Creates a bit-vector with a given number of bits. Each cell holds an
		 * int, allowing to store 32 flags each. 
		 * 
		 * @param bits The total number of bits.
		 */
		public function BitVector(bits:int)
		{
			_bits = [];
			_arrSize = 0;
			
			resize(bits);
		}
		
		/**
		 * The total number of bits.
		 */
		public function get bitCount():int
		{
			return _arrSize * 31;
		}
		
		/**
		 * The total number of cells.
		 */
		public function get cellCount():int
		{
			return _arrSize;
		}
		
		/**
		 * Gets a bit from a given index.
		 * 
		 * @param index The index of the bit.
		 */
		public function getBit(index:int):int
		{
			var bit:int = index % 31;
			return (_bits[(index / 31) >> 0] & (1 << bit)) >> bit;
		}
		
		/**
		 * Sets a bit at a given index.
		 * 
		 * @param index The index of the bit.
		 * @param b     The boolean flag to set.
		 */
		public function setBit(index:int, b:Boolean):void
		{
			var cell:int = index / 31;
			var mask:int = 1 << index % 31;
			_bits[cell] = b ? (_bits[cell] | mask) : (_bits[cell] & (~mask));
		}
		
		/**
		 * Resizes the bit-vector to an appropriate number of bits.
		 * 
		 * @param size The total number of bits.
		 */
		public function resize(size:int):void
		{
			if (size == _bitSize) return;
			_bitSize = size;
			
			//convert the bit-size to integer-size
			if (size % 31 == 0)
				size /= 31;
			else
				size = (size / 31) + 1;
			
			if (size < _arrSize)
			{
				_bits.splice(size);
				_arrSize = size;
			}
			else
			{
				_bits = _bits.concat(new Array(size - _arrSize));
				_arrSize = _bits.length;
			}
		}
		
		/**
		 * Resets all bits to 0;
		 */
		public function clear():void
		{
			var k:int = _bits.length;
			for (var i:int = 0; i < k; i++)
				_bits[i] = 0;
		}
		
		/**
		 * Sets each bit to 1.
		 */
		public function setAll():void
		{
			var k:int = _bits.length;
			for (var i:int = 0; i < k; i++)
				_bits[i] = int.MAX_VALUE;
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			return "[BitVector, size=" + _bitSize + "]";
		}
	}
}