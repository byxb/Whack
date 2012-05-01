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

package world.effects
{

	import com.byxb.utils.*;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;

	/**
	 * A Pow explosion used for various effects.
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class Pow extends MovieClip
	{
		/**
		 * Creates a Pow animation that plays then removes itself
		 */
		public function Pow()
		{
			super(Assets.getAtlas().getTextures("hammer/pow"), 30);
			addEventListener(Event.ADDED_TO_STAGE, startAnim);
			addEventListener(Event.REMOVED_FROM_STAGE, stopAnim);
			addEventListener(Event.COMPLETE, remove);
			centerPivot(this);
		}

		/**
		 * When the Pow is added to stage, it will start automatically
		 * @param e Event
		 */
		public function startAnim(e:Event=null):void
		{
			Starling.juggler.add(this);
		}

		/**
		 * Removes the Pow from the juggler, stopping the animation
		 * @param e Event
		 */
		public function stopAnim(e:Event):void
		{
			Starling.juggler.remove(this);
		}

		/**
		 * Removes the Pow from its parent and disposes itself 
		 * @param e
		 */
		private function remove(e:Event):void
		{
			this.removeFromParent(true);
		}

		public override function dispose():void
		{
			Starling.juggler.remove(this);
		}
	}
}
