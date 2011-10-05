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

package world
{

	import com.byxb.utils.*;
	
	import de.polygonal.ds.BinarySearchTree;
	import de.polygonal.ds.BinaryTreeNode;
	
	import flash.geom.Point;

	/**
	 * A Singleton class that returns the ground surface y value for any x.  The ground in the game is not flat, 
	 * so to get the actual surface position, I took the ground artwork in Flash Pro and created a motion guide 
	 * tween along the surface.  At every frame, the x and y position of the tweened MovieClip was recorded and
	 * turned into a Vector.<Point>.  
	 * 
	 * The vector is then converted into a Binary Search Tree to optimize the lookup speed (worst case of checking 
	 * 1/4 of elements rather than all). 
	 * 
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class GroundHeightOffsets extends BinarySearchTree
	{
		private static var _instance:GroundHeightOffsets=null;
		private static var instantiationLocked:Boolean=true;

		/**
		 * Creates or returns the existing instance of the singleton
		 * @return 
		 */
		public static function get instance():GroundHeightOffsets
		{
			if (!_instance)
			{
				instantiationLocked=false;
				_instance=new GroundHeightOffsets();
				instantiationLocked=true;
			}
			return _instance;
		}

		/**
		 * Do not use the constructor. The singleton instantiation is managed by the instance static property.
		 * @throws Error
		 */
		public function GroundHeightOffsets()
		{
			super(compare);
			if (instantiationLocked)
			{
				throw new Error("use the static property 'instance' to instantiate the singleton");
			}

			var vec:Vector.<Point>=new <Point>[new Point(0, 21), new Point(21, 21), new Point(42, 21), new Point(63, 20), new Point(84, 19), 
				new Point(105, 18), new Point(125, 14), new Point(146, 11), new Point(167, 8), new Point(187, 4), new Point(207, 1), 
				new Point(228, -2), new Point(249, -4), new Point(269, -1), new Point(290, 4), new Point(310, 8), new Point(331, 10), 
				new Point(352, 10), new Point(373, 9), new Point(394, 6), new Point(414, 2), new Point(435, -2), new Point(455, -8), 
				new Point(476, -9), new Point(497, -9), new Point(518, -7), new Point(539, -4), new Point(559, 0), new Point(580, 0), 
				new Point(601, -3), new Point(621, -7), new Point(640, -12), new Point(661, -18), new Point(681, -22), new Point(702, -25), 
				new Point(722, -28), new Point(742, -28), new Point(762, -28), new Point(783, -28), new Point(804, -27), new Point(824, -26), 
				new Point(845, -25), new Point(866, -22), new Point(887, -20), new Point(907, -16), new Point(928, -13), new Point(949, -11), 
				new Point(970, -11), new Point(991, -12), new Point(1012, -14), new Point(1032, -17), new Point(1053, -19), 
				new Point(1074, -21), new Point(1095, -22), new Point(1115, -23), new Point(1136, -24), new Point(1157, -25), 
				new Point(1178, -25), new Point(1199, -25), new Point(1220, -24), new Point(1241, -23), new Point(1261, -19), 
				new Point(1281, -13), new Point(1302, -7), new Point(1321, 0), new Point(1341, 7), new Point(1361, 11), new Point(1382, 10), 
				new Point(1403, 9), new Point(1424, 5), new Point(1444, 1), new Point(1465, -3), new Point(1484, -7), new Point(1505, -8), 
				new Point(1526, -7), new Point(1547, -5), new Point(1568, -2), new Point(1589, 1), new Point(1610, 1), new Point(1631, 2), 
				new Point(1652, 1), new Point(1672, -2), new Point(1692, -4), new Point(1713, -7), new Point(1734, -8), new Point(1755, -10), 
				new Point(1776, -11), new Point(1797, -11), new Point(1818, -11), new Point(1839, -11), new Point(1860, -11), 
				new Point(1881, -11), new Point(1902, -9), new Point(1923, -7), new Point(1943, -7), new Point(1964, -6), new Point(1985, -7), 
				new Point(2006, -7), new Point(2027, -8), new Point(2048, -8), new Point(2068, -9), new Point(2089, -9), new Point(2110, -9), 
				new Point(2131, -9), new Point(2152, -9), new Point(2173, -9), new Point(2194, -10), new Point(2215, -10), new Point(2235, -11), 
				new Point(2256, -10), new Point(2277, -8), new Point(2298, -5), new Point(2318, -1), new Point(2338, 5), new Point(2358, 9), 
				new Point(2379, 10), new Point(2400, 10), new Point(2422, 10), new Point(2442, 6), new Point(2463, 2), new Point(2483, -2), 
				new Point(2503, -7), new Point(2524, -8), new Point(2544, -8), new Point(2565, -6), new Point(2586, -3), new Point(2607, 0), 
				new Point(2628, 1), new Point(2649, 0), new Point(2669, 1), new Point(2690, -2), new Point(2711, -3), new Point(2731, -7), 
				new Point(2752, -9), new Point(2772, -6), new Point(2793, -3), new Point(2814, -1), new Point(2834, 3), new Point(2855, 6), 
				new Point(2875, 9), new Point(2896, 11), new Point(2917, 15), new Point(2937, 16), new Point(2958, 20), new Point(2979, 22), 
				new Point(2999, 24), new Point(3020, 25), new Point(3041, 24), new Point(3062, 23), new Point(3083, 23), new Point(3104, 22), 
				new Point(3125, 21), new Point(3146, 20), new Point(3166, 19), new Point(3187, 16), new Point(3208, 13), new Point(3227, 8), 
				new Point(3248, 6), new Point(3269, 2), new Point(3289, -1), new Point(3310, -3), new Point(3331, -4), new Point(3351, 2), 
				new Point(3372, 7), new Point(3392, 10), new Point(3413, 10), new Point(3434, 9), new Point(3454, 8), new Point(3475, 4), 
				new Point(3496, 0), new Point(3516, -4), new Point(3536, -8), new Point(3557, -8), new Point(3577, -8), new Point(3598, -5), 
				new Point(3619, -2), new Point(3640, 0), new Point(3661, 1), new Point(3682, 1), new Point(3703, 0), new Point(3723, -3), 
				new Point(3744, -5), new Point(3765, -8), new Point(3786, -9), new Point(3807, -11), new Point(3828, -11), 
				new Point(3849, -11), new Point(3869, -11), new Point(3890, -12), new Point(3911, -11), new Point(3932, -10), 
				new Point(3953, -7), new Point(3973, -3), new Point(3993, 3), new Point(4014, 7), new Point(4034, 11), new Point(4055, 15), 
				new Point(4075, 17), new Point(4096, 21),];
			
			addToBlist(vec);

		}

		/**
		 * basic comparison function.  compares on the x value.
		 * @param a
		 * @param b
		 * @return 
		 */
		private function compare(a:Point, b:Point):int
		{
			return a.x - b.x;
		}

		/**
		 * Returns the y value of the surface based on an x value. Loops based on the width of the ground graphic
		 * @param x The x value where you need to know how high the surface is.
		 * @return the y value of where the surface is.
		 */
		public function getHeightOffset(x:Number):Number
		{
			x=loop(x, 4096);
			return getInterpolated(new Point(x, 0)).y;
		}

		/**
		 * Extends the functionality of the BinarySearchTree, not just find an exact match, but find
		 * the values on either side of an imperfect match and interpolate a value from them
		 * @param p the desired point (Only the x value is used for this example
		 * @return an interpolated Point based on the surrounding near matches in the tree
		 */
		private function getInterpolated(p:Point):Point
		{
			var cur:BinaryTreeNode=root, i:int;
			var lastCur:BinaryTreeNode;
			while (cur)
			{
				i=compare(p, cur.data);
				if (i == 0)
					return cur.data as Point;
				lastCur=cur;
				cur=i < 0 ? cur.left : cur.right;
			}
			var pt1:Point=lastCur.data;
			var pt2:Point;
			var check:Boolean=compare(p, pt1) < 0 ? true : false;
			if (lastCur.isRight() == check)
			{
				pt2=lastCur.parent.data;
			}
			else
			{
				cur=lastCur.parent;
				while (cur.isLeft() == check && cur.parent)
				{
					cur=cur.parent;
				}
				pt2=cur.parent.data;
			}
			var ratio:Number=(p.x - pt2.x) / (pt1.x - pt2.x);
			return Point.interpolate(pt1, pt2, ratio);
		}

		/**
		 * This Btree does not re-organize based on new values.  To work around this, I recursively 
		 * add the middle item, divide the remaining items in two and recurse on each. This will create the most
		 * distributed possible tree meaning the fewest comparisons to the items
		 * @param points the vector of points to be added to the tree.
		 */
		private function addToBlist(points:Vector.<Point>):void
		{
			if (points.length)
			{
				var h:uint=points.length >> 1;
				insert(points[h]);

				addToBlist(points.slice(0, h));
				addToBlist(points.slice(h + 1));
			}
		}
	}
}
