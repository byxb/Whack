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
	import data.GameData;
	
	/**
	 * Creates a data object for upgrade items to be displayed when the store is active.  UpgradeItems are created in the Const class.
	 * @author Johnny Nguyen - Johnny [at] byxb [dot] com
	 */
	public class UpgradeItem extends Object
	{
		private var _category:String;
		private var _type:String;
		private var _title:String;
		private var _desc:Vector.<String>;
		private var _level:Vector.<uint>;
		private var _iconSm:String;
		private var _iconLg:String;
		private var _powerUp:uint;
		private var _canAfford:Boolean;
		private var _isActive:Boolean;
		
		public function get category():String {return _category;}
		public function get type():String {return _type;}
		public function get title():String {return _title;}
		public function get desc():Vector.<String> {return _desc;}
		public function get level():Vector.<uint> {return _level;}
		public function get iconSm():String {return _iconSm;}
		public function get iconLg():String {return _iconLg;}
		public function get powerUp():uint {return _powerUp;}
		public function get canAfford():Boolean {return _canAfford;}
		public function get isActive():Boolean {return _isActive;}
		
		public function set powerUp(value:uint):void {_powerUp = value;}
		public function set canAfford(value:Boolean):void {_canAfford = value;}
		public function set isActive(value:Boolean):void {_isActive = value;}
		
		/**
		 * Creates a new upgrade item.
		 * 
		 * @param category Who uses the upgrade item.
		 * @param type The kind of upgrade item. 
		 * @param title The title of the upgrade item.
		 * @param desc Descriptions of each power up level.
		 * @param level The scale for next power up item.
		 * @param iconSm The texture key for the small icon shown in the store.
		 * @param iconLg The texture key for the large icon shown in the store detail.
		 */
		public function UpgradeItem(category:String, type:String, title:String, desc:Vector.<String>, level:Vector.<uint>, iconSm:String, iconLg:String)
		{
			_category = category;
			_type = type;
			_title = title;
			_desc = desc;
			_level = level;
			_iconSm = iconSm;
			_iconLg = iconLg;
			
			_powerUp = 0;
			_isActive = false;
			_canAfford = false; 
		}
	}
}