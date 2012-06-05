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

package data {

	/**
	 * Records data about the store's inventory.
	 * @author Johnny Nguyen - Johnny [at] byxb [dot] com
	 */
	public class Inventory extends Object {
		private var _humanCurrency:uint = 0;
		private var _moleCurrency:uint = 0;
		private var _dynamite:uint = 0;
		private var _hammers:uint = 0;
		private var _whacks:uint = 0;
		private var _goggles:uint = 0;
		private var _maneuverability:uint = 0;
		private var _overalls:uint = 0;
		
		public function get humanCurrency():uint {return _humanCurrency;}
		public function set humanCurrency(value:uint):void {_humanCurrency = value; GameData.save();}
		
		public function get moleCurrency():uint {return _moleCurrency;}
		public function set moleCurrency(value:uint):void {_moleCurrency = value; GameData.save();}
		
		public function get hammers():uint {return _hammers;}
		public function set hammers(value:uint):void {_hammers = value; GameData.save();}
		
		public function get whacks():uint {return _whacks;}
		public function set whacks(value:uint):void {_whacks = value; GameData.save();}
		
		public function get dynamite():uint {return _dynamite;}
		public function set dynamite(value:uint):void {_dynamite = value; GameData.save();}
		
		public function get goggles():uint {return _goggles;}
		public function set goggles(value:uint):void {_goggles = value; GameData.save();}
		
		public function get maneuverability():uint {return _maneuverability;}
		public function set maneuverability(value:uint):void {_maneuverability = value; GameData.save();}
		
		public function get overalls():uint {return _overalls;}
		public function set overalls(value:uint):void {_overalls = value; GameData.save();}

		/**
		 * Creates a new inventory object.
		 */
		public function Inventory() {
			//
		}
		
		/**
		 * Returns the value of the requested type.  The value is used to determine the power level for the upgrade item.
		 * 
		 * @param type The upgrade item type. 
		 * @return The value of the the upgrade item type.
		 */
		public function getLevelByType(type:String):uint {	
			return uint(this[type]);
		}
		
		/**
		 * Sets an upgrade item type to a specified value.
		 * 
		 * @param type The upgrade item type.
		 * @param value The new upgrade item value.
		 */
		public function setLevelByType(type:String, value:uint):void {
			this[type] = value;
		}
		
		/**
		 * Returns the value (currency) of the requested category.
		 * 
		 * @param category The upgrade item category.
		 * @return The currency of the category item type.
		 */
		public function getCurrencyByCategory(category:String):uint {
			return uint(this[category + "Currency"]);
		}
		
		/**
		 * Sets an upgrade item category to a specified value (currency).
		 *  
		 * @param category The upgrade item category.
		 * @param value The new upgrade item category value (currency).
		 */
		public function setCurrencyByCategory(category:String, value:uint):void {
			this[category + "Currency"] = value;
		}
	}
}