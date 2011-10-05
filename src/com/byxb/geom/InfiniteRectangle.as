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

	import com.byxb.utils.clamp;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * An extension of Rectangle that allows for x, y, width and height to be infinite
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class InfiniteRectangle extends Rectangle
	{
		/**
		 * a fully infinite rectangle
		 * @return 
		 */
		public static function get FULL_RECT():InfiniteRectangle  { return new InfiniteRectangle(Number.NEGATIVE_INFINITY, Number.NEGATIVE_INFINITY, Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY); }

		/**
		 * An extension of Rectangle that allows for x, y, width and height to be infinite
		 * @param x X postion
		 * @param y Y position
		 * @param width the width of the rectangle
		 * @param height the height of the rectangle
		 */
		public function InfiniteRectangle(x:Number=0, y:Number=0, width:Number=0, height:Number=0)
		{
			super(x, y, width, height);
		}

		public override function intersection(toIntersect:Rectangle):Rectangle
		{
			var l:Number=clamp(toIntersect.left, this.left, this.right);
			var r:Number=clamp(toIntersect.right, this.left, this.right);
			var t:Number=clamp(toIntersect.top, this.top, this.bottom);
			var b:Number=clamp(toIntersect.bottom, this.top, this.bottom);

			if (t >= b || l >= r) // don't bother rendering if the texture is off screen
			{
				return new InfiniteRectangle();
			}
			else
			{
				return new InfiniteRectangle(l, t, r - l, b - t);
			}
		}

		public override function clone():Rectangle
		{
			return new InfiniteRectangle(this.x, this.y, this.width, this.height);
		}

		public override function get right():Number
		{
			return this.left == Number.NEGATIVE_INFINITY ? this.width : super.right;
		}

		public override function get bottom():Number
		{
			return this.top == Number.NEGATIVE_INFINITY ? this.height : super.bottom;
		}

		public override function get bottomRight():Point
		{
			return new Point(this.bottom, this.right);
		}

		public override function get size():Point
		{
			return new Point(this.width, this.height);
		}
	}
}

