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

	import flash.geom.Vector3D;

	import starling.events.Event;

	/**
	 * This event is fired when the FirstSwing hammer detects a touch event.  It is handled by World which then calls the whack action on Mole
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class HammerWhackEvent extends Event
	{
		/**
		 * The type of the event
		 */
		public static const HAMMER_WHACK:String="hammerWhack";
		/**
		 * The initial velocity and direction for the mole to move expressed as a vector.  The Z component is not used.
		 */
		public var direction:Vector3D;

		/**
		 * This event is fired when the FirstSwing hammer detects a touch event.  It is handled by World which then calls the whack action on Mole
		 * @param direction
		 * @param bubbles
		 */
		public function HammerWhackEvent(direction:Vector3D, bubbles:Boolean=false)
		{
			this.direction=direction;
			super(HAMMER_WHACK, bubbles);
		}
	}
}
