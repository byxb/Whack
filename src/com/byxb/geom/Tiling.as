//------------------------------------------------------------------------------
//
// Copyright 2011 BYXB LLC. All Rights Reserved. 
// 
// This software has been licensed to Adobe Systems Inc. for 
// use in educational, training, and for promotional and  
// demonstration purposes. All rights are otherwise retained 
// by BYXB LLC and subject to the following license: 
// 
// The software code contained herein is licensed under the Creative 
// Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.  
// To view this license, see http://creativecommons.org/licenses/by-nc- 
// sa/3.0/ or send a letter to Creative Commons, 444 Castro Street,  
// Suite 900, Mountain View, California, 94041, USA. 
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,  
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON- 
// INFRINGEMENT. IN NO EVENT SHALL BYXB LLC BE LIABLE FOR ANY CLAIM,  
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,  
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH  
// THE SOFTWARE OR THE USE, MISUSE, OR INABILITY TO USE THE SOFTWARE. 
// 
// For more information see http://www.byxb.com/. 
//
//------------------------------------------------------------------------------


package com.byxb.geom
{

	/**
	 * Tiling Constants and utilities
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class Tiling
	{
		public static const TILE_X:uint=1;
		public static const TILE_Y:uint=2;
		public static const TILE_NONE:Number=0;

		public function Tiling()
		{

		}

		/**
		 * Returns whether or not a uint indicating a combined set of axis data indicated for X tiling
		 * @param axisValue
		 * @return 
		 */
		public static function isTileX(axisValue:uint):Boolean
		{
			return Boolean(axisValue & 1);
		}

		/**
		 * Returns whether or not a uint indicating a combined set of axis data indicated for Y tiling
		 * @param axisValue
		 * @return 
		 */
		public static function isTileY(axisValue:uint):Boolean
		{
			return Boolean(axisValue >> 1 & 1);
		}

		/**
		 * Returns the number of tiles it would take to cover a width of pixels
		 * @param tileSide
		 * @param coverRange
		 * @return 
		 */
		public static function getTileCount(tileSide:Number, coverRange:Number):uint
		{
			return Math.ceil((coverRange) / tileSide) + 1;
		}
	}
}
