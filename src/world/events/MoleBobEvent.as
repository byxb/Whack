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

	import starling.events.Event;

	/**
	 * At the beginning of the round, the mole bobs up and down like an arcade whack-a-mole which determines the intensity of the hit.  
	 * This information is used by the FirstSwing class so the event is handled by the World class instance and the data is then communicated 
	 * to the FirstSwing instance.
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class MoleBobEvent extends Event
	{
		/**
		 * The event type
		 */
		public static var MOLE_BOB:String="moleBob";
		/**
		 * A ratio that ultimately determines the magnitude of the whack vector.
		 */
		public var intensity:Number;

		/**
		 * At the beginning of the round, the mole bobs up and down like an arcade whack-a-mole which determines the intensity of the hit.  
		 * This information is used by the FirstSwing class so the event is handled by the World class instance and the data is then communicated.
		 * @param intensity A ratio indicating the power of a hit at this moment.
		 * @param bubbles
		 */
		public function MoleBobEvent(intensity:Number, bubbles:Boolean=false)
		{
			this.intensity=intensity;
			super(MOLE_BOB, bubbles);
		}
	}
}
