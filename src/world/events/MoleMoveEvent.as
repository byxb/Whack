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

package world.events
{

	import flash.geom.Point;
	import flash.geom.Vector3D;

	import starling.events.Event;

	/**
	 * When the mole moves, the Mole instance fires this event with its current location, its velocity and a ratio 
	 * of its current speed to the maximum speeed. This is used for moving the camera and drawing the tunnel.
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class MoleMoveEvent extends Event
	{
		
		/**
		 * The event type
		 * @default 
		 */
		public static const MOLE_MOVE:String="moleMove";
		
		/**
		 * The current location of the mole
		 */
		public var location:Point;
		
		/**
		 * A Vector3D of the current velocity
		 */
		public var velocity:Vector3D;
		
		/**
		 * A ratio of the current speed to the maximum speed.  
		 */
		public var speedRatio:Number;
		
		/**
		 * The minSpeedRatio is lowest speed ratio that should be used for many speed-sensetive operations.  The minimum is intended to allow speed-sensetive 
		 * animated MovieClips to fall below a threshold where they are no longer seen as animations.
		 */
		public var minSpeedRatio:Number

		/**
		 * When the mole moves, the Mole instance fires this event with its current location, its velocity and a ratio 
		 * of its current speed to the maximum speeed. This is used for moving the camera and drawing the tunnel.
		 *
		 * @param location
		 * @param velocity
		 * @param speedRatio
		 * @param bubbles
		 */
		public function MoleMoveEvent(location:Point, velocity:Vector3D, speedRatio:Number, bubbles:Boolean=false)
		{
			this.location=location;
			this.velocity=velocity;
			this.speedRatio=speedRatio;
			this.minSpeedRatio=Const.MOLE_SLOW_SPEED / Const.MOLE_FAST_SPEED;
			super(MOLE_MOVE, bubbles);
		}
	}
}
