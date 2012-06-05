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

package data {
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	import flash.net.registerClassAlias;
	
	/**
	 * Records all game data into a SharedObejct.
	 * @author Johnny Nguyen - Johnny [at] byxb [dot] com 
	 */	
	public class GameData extends EventDispatcher {
		private static var _gameData:GameData;
		private static var _isOkayToCreate:Boolean = false;
		private static var _game:SavedGame;
		
		public static function get preferences():Preferences {
			createInstance(); 
			return _gameData.preferences;
		}
		
		public static function get savedGames():Vector.<SavedGame> {
			createInstance(); 
			return new Vector.<SavedGame>(_gameData.savedGames);
		}
		
		public static function get game():SavedGame {
			if (_game) {
				return _game;
			} else {
				throw new Error("loadGame() must be called before game can be accessed.");
			}
		}
		
		/**
		 * Loads a game of a specified slot. 
		 * @param savedSlot The specified slot.
		 * @return The game of the specified slot.
		 */
		public static function loadGame(savedSlot:uint):SavedGame {
			createInstance();
			return _game = _gameData.savedGames[savedSlot];
		} 
		
		/**
		 * Saves the SharedObject.
		 */
		public static function save():void {
			createInstance();
			_gameData.so.flush();
		}
		
		/**
		 * 
		 * @param savedSlot
		 * 
		 */
		public static function clear(savedSlot:int = -1):void {
			createInstance();
			
			if (savedSlot < 0) {
				_gameData.so.clear();	
			} else {
				//savedGames[savedSlot] = new SavedGame(savedSlot);
			}
		}
		
		/**
		 * Creates a GameData instance.
		 */
		private static function createInstance():void {
			if (!_gameData) {
				_isOkayToCreate = true;
				_gameData = new GameData();
				_isOkayToCreate = false;
			}
		}
		
		public var preferences:Preferences;
		public var savedGames:Array;
		public var so:SharedObject;
		
		/**
		 * Creates a new game data.
		 */
		public function GameData() {
			if (!_isOkayToCreate) throw new Error(this + " is a Singleton.");

// TODO: Look into sharedObject issues.  Game currency/achievements sporadically being reset when the browser is closed and then re-opened.			
			registerClassAlias("preferences", Preferences);
			registerClassAlias("achievements", Achievements);
			registerClassAlias("achievementItem", AchievementItem);
			registerClassAlias("inventory", Inventory);
			registerClassAlias("stats", Stats);
			registerClassAlias("savedGame", SavedGame);
			
			so = SharedObject.getLocal("sharedObject");
			
			if (!so.data.savedGames) {
				so.data.preferences = new Preferences();
				so.data.savedGames = [new SavedGame(0), new SavedGame(1), new SavedGame(2)]
				
				this.preferences = so.data.preferences; 
				this.savedGames = so.data.savedGames;
				
				so.flush();
			} else {
				this.savedGames = so.data.savedGames;
				this.preferences = so.data.preferences;
			}
		}
	}
}