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

package store
{
	import com.byxb.utils.centerPivot;
	
	import data.GameData;
	import data.Inventory;
	import data.SavedGame;
	
	import flash.events.EventDispatcher;
	
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * The Store Data class acts as the controller for the store view.
	 * @author Johnny Nguyen - Johnny [at] byxb [dot] com 
	 */
	public class StoreData extends EventDispatcher
	{
		private var _upgradeItems:Vector.<Vector.<UpgradeItem>>;
		private var _currencies:Vector.<uint>;
		
		/**
		 * Returns categories of power up items.
		 * @return Categories with duplicates removed.
		 */
		public function getCategories():Vector.<String>
		{	
			var categories:Vector.<String> = new Vector.<String>();
			var obj:Object = {};
			
			for (var i:uint = 0; i < Const.UPGRADE_ITEMS.length; i++)
			{
				obj[Const.UPGRADE_ITEMS[i].category] = true;
			}
			
			for (var c:String in obj)
			{
				categories.push(c);
			}
			
			// sort category
			categories = categories.sort(sortCategories);
			
			return categories;
		}
		
		/**
		 * Returns the information object relating to each power up item.
		 * @param categories Vector of requested categories.
		 * @return Vector of upgrade items per category.
		 */
		public function getUpgradeItems(categories:Vector.<String>):Vector.<Vector.<UpgradeItem>>
		{
			for (var i:uint = 0; i < categories.length; i++) 
			{	
				_upgradeItems[i] = new Vector.<UpgradeItem>();
				
				for (var j:uint = 0; j < Const.UPGRADE_ITEMS.length; j++)
				{
					if (Const.UPGRADE_ITEMS[j].category == categories[i])
					{
						_upgradeItems[i].push(Const.UPGRADE_ITEMS[j]);
					}
				}
			}
			
			updateUpgradeItems();
			
			return _upgradeItems;
		}
		
		/**
		 * Returns currencies from the game's SharedObject.
		 * @return Game currencies.
		 */
		public function getCurrencies():Vector.<uint> {
			_currencies[0] = GameData.game.inventory.humanCurrency;
			_currencies[1] = GameData.game.inventory.moleCurrency;
			
			return _currencies;
		}

		/**
		 * Updates the store button's information object.
		 * @param The upgrade item to currency refresh. 
		 */
		public function updateStore(upgradeItem:UpgradeItem):void 
		{
			// currency must be updated before increasing power up!
			updateCurrencies(upgradeItem);
			
			// update can cost level of current upgradeItem
			upgradeItem.powerUp++;
			GameData.game.inventory.setLevelByType(upgradeItem.type, upgradeItem.powerUp);
			
			// update _upgradeitems 
			updateUpgradeItems();
		}
		
		/**
		 * Creates a new StoreData.
		 */
		public function StoreData()
		{
			_upgradeItems = new Vector.<Vector.<UpgradeItem>>(); 
			_currencies = new Vector.<uint>();
		}
		
		/**
		 * Updates the games shared object with the new currency value.
		 * @param The upgrade item to currency refresh.
		 */		
		private function updateCurrencies(upgradeItem:UpgradeItem):void {
			var currency:uint = GameData.game.inventory.getCurrencyByCategory(upgradeItem.category);
			var cost:uint = upgradeItem.level[upgradeItem.powerUp];
			var newCurrency:uint = currency - cost;
			
			GameData.game.inventory.setCurrencyByCategory(upgradeItem.category, newCurrency);
		}
		
		/**
		 * Updates the store button's information object, sets power up, and if the item is affordable.
		 */
		private function updateUpgradeItems():void 
		{
			for (var i:uint = 0; i < _upgradeItems.length; i++) 
			{				
				for(var j:uint = 0; j < _upgradeItems[i].length; j++)
				{
					var inventory:Inventory = GameData.game.inventory;
					var item:String = _upgradeItems[i][j].type;
					var category:String = _upgradeItems[i][j].category;
					var levels:Vector.<uint> = _upgradeItems[i][j].level;
					
					_upgradeItems[i][j].powerUp = inventory.getLevelByType(item);
					
					if (inventory.getLevelByType(item) < levels.length) 
					{
						_upgradeItems[i][j].canAfford = inventory.getCurrencyByCategory(category) >= levels[inventory.getLevelByType(item)] ? true : false;
					} else
					{
						_upgradeItems[i][j].canAfford = false;
					}
				}
			}
		}
		
		/**
		 * Compare function to sort the vector of categories.
		 * @param x 
		 * @param y
		 * @return Number
		 */
		private function sortCategories(x:String, y:String):Number
		{
			if (x < y)
			{
				return -1;
			}
			else if (x > y)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
	}
}