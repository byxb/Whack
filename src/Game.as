//------------------------------------------------------------------------------
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

	import data.GameData;
	import data.SavedGame;
	import data.Stats;
	
	import flash.utils.*;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	import store.*;
	import store.events.StoreCloseEvent;
	
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
		private var _storeView:Store;
		
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
//TODO: update Stat's public propertics with total play time and session time;
//TODO: start session play time by calling [pseudo code] Stats.getSessionPlayTime();
//TODO: start total play time by calling [pseudo code] Stats.getTotalPlayTimes();
//TODO: start getTimer();
			
			// testing GameData so
			/*GameData.loadGame(0);
			var stats:Stats = GameData.game.stats;
			var game:SavedGame = GameData.game;*/
			//GameData.clear();
			//trace("game");
			//GameData.clear();
			GameData.loadGame(0);
			if (GameData.game.stats.firstPlay == null) GameData.game.stats.firstPlay = new Date();
			
			/*_storeView = new Store();
			_storeView.addEventListener(StoreCloseEvent.STORE_CLOSE, removeStore);
			addChild(_storeView);*/
		}
		
		private function removeStore(e:StoreCloseEvent):void 
		{
			removeChild(_storeView, true);
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
//TODO: call save() on GameData.
		}
	}
}
