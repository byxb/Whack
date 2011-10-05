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



package ui.modals
{

	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;

	/**
	 * Creates the button for starting the level over again
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class LevelEnd extends Modal
	{
		private var _tryAgain:Button;

		/**
		 * Creates the button for starting the level over again
		 */
		public function LevelEnd()
		{
			super();
			_tryAgain=new Button(Assets.getAtlas().getTexture("menus/button_tryAgain"));
			_tryAgain.addEventListener(Event.TRIGGERED, onTryAgain);
			addChild(_tryAgain);

		}

		/**
		 * When the button is clicked, dispatch an event that the level should restart. This event is handled by the Game class
		 * @param e
		 */
		public function onTryAgain(e:Event):void
		{
			this.dispatchEvent(new Event("tryAgain", true));//the event has to bubble since LevelEnd will be a child instance of HUD
			this.removeFromParent(true);
		}
	}
}
