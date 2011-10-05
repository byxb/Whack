//------------------------------------------------------------------------------
//
// 
// Whack! Game 
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

package
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 
	 *  @author Justin Church justin [at] byxb [dot] com
	 * 
	 */
	public class Const
	{
		//General
		public static const FPS:uint=60;
		public static const GRAVITY:Number=.2;
		public static const BASE_REACH_RADIUS:uint=60

		private static var _width:uint=800;

		/**
		 * The width of the stage (as last set)
		 * @return the stage width settings
		 */
		public static function get stageWidth():uint
		{
			return _width;
		}
		
		private static var _height:uint=450;
		/**
		 * The height of the stage (as last set)
		 * @return the stage height settings
		 */
		public static function get stageHeight():uint
		{
			return _height;
		}

		/**
		 * Sets the size of the display area.
		 * @param w Stage width
		 * @param h Stage height
		 */
		public static function setSize(w:uint, h:uint):void
		{
			_width=w;
			_height=h;

		}

		//Ground &Tunnel
		public static const TUNNEL_LENGTH_SEGMENTS:uint=250;
		public static const TUNNEL_CROSS_SEGMENTS:uint=1;
		public static const TUNNEL_MOLEHILL_FPS:uint=20;
		public static const TUNNEL_MOLEHILL_Y_OFFSET:uint=5;
		public static const TUNNEL_PIXEL_BUFFER:uint=5;
		public static const MAX_TUNNEL_LENGTH:uint=1000;
		public static const GROUND1_WIDTH:uint=4096;

		//Mole		
		public static const MOLE_FPS:uint=30;
		public static const MOLE_BOB_FPS:uint=15;
		public static const MOLE_MAX_FPS:uint=60;
		public static const MOLE_COSTUME_NAME:Vector.<String>=new <String>["mole/bobbing", "mole/digging", "mole/cannonball", "mole/flailIntoDive", "mole/intoDive", "mole/surfacing"];
		public static const MOLE_SLOW_SPEED:Number=10;
		public static const MOLE_FAST_SPEED:Number=35;

		//Camera
		public static const CAMERA_MIN_SCALE:Number=.4;
		public static const CAMERA_MAX_SCALE:Number=1;
		public static const CAMERA_SHAKE_INTERVAL:Number=.016666666;
		/**
		 * The largest potential viewport that may be shown in the camera.
		 * 
		 * @return a Rectangle centered on (0,0).
		 */
		public static function get cameraMaxRect():Rectangle
		{
			return new Rectangle(-(stageWidth / 2) * (1 / CAMERA_MIN_SCALE), -(stageHeight / 2) * (1 / CAMERA_MIN_SCALE), stageWidth * (1 / CAMERA_MIN_SCALE), stageHeight * (1 / CAMERA_MIN_SCALE));
		}

		//Hammer
		public static const HAMMER_WHACK_PREVIEW_SEGMENTS:uint=50;

		//items
		public static const ITEMS_CELL_SIZE:uint=100;



	}
}
