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
	import flash.utils.Dictionary;
	
	import starling.events.Event;
	
	/**
	 * The MoleStopEvent is fired when the mole stops moving as a result of decresed velocity.
	 * @author Johnny Nguyen - johnny [at] byxb [dot] com 
	 * 
	 */
	public class MoleStopEvent extends Event
	{
		/**
		 * The event type.
		 * @default 
		 */
		public static var MOLE_STOP:String="moleStop";
		
		/**
		 * Dictionary of total items collected during the level.
		 * @default
		 */
		public var itemDict:Dictionary;
		
		/**
		 * The MoleStopEvent is fired when the mole stops moving as a result of decresed velocity.
		 * @param type
		 * @param bubbles
		 */
		public function MoleStopEvent(bubbles:Boolean=false)
		{
			super(MOLE_STOP, bubbles);
		}
	}
}