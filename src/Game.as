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
	import flash.ui.Keyboard;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	import ui.HUD;
	
	import world.World;

	/**
	 * The Game class holds the main game play area and the UI for score and other stats
	 * This is the class that is passed to Starling for initialization.
	 * @author justinchurch
	 *
	 */
	public class Game extends Sprite
	{
		private var _hud:HUD;
		private var _world:World;
		
		/**
		 * Creates a new game with a Worls play area and HUD.
		 */
		public function Game()
		{
			super();
			_world=new World();
			_hud=HUD.instance;
			addChild(_world);
			addChild(_hud);
			_hud.addEventListener("tryAgain", resetLevel);
            
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		/**
		 * Builds a new World.  Will cause more churn for the GC than optimal.  
		 * Need to implement a call down into world that resets individual elements.
		 * @param e 
		 */
		private function resetLevel(e:Event = null):void
		{
			_world.removeFromParent(true);
			_world=new World()
			addChildAt(_world, 0);
		}
        
        private function onAddedToStage(event:Event):void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
        }
        
        private function onRemovedFromStage(event:Event):void
        {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
        }
        
        private function onKey(event:KeyboardEvent):void
        {
            // hit the space key to show FPS and MEM
            
            if (event.keyCode == Keyboard.SPACE)
                Starling.current.showStats = !Starling.current.showStats;
        }
	}
}
