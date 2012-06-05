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
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	import store.events.StoreBuyEvent;
	
	/**
	 * The Store Detail View class holds the UI for buying upgrade items.
	 * @author Johnny Nguyen - Johnny [at] byxb [dot] com 
	 */
	public class StoreDetailView extends Sprite
	{
		private const _BUY:String = "buttons/buyBtn";
		private const _EMPTY:String = "thermometer/empty"; 
		private const _FULL:String = "thermometer/full";
		private const _PAD:uint = 5;
		
		private var _upgradeItem:UpgradeItem;
		private var _icon:Image;
		private var _title:TextField;
		private var _desc:TextField;
		private var _cost:TextField;
		private var _buy:Button;
		private var _thermometer:Vector.<Image>;
		
		/**
		 * Creates a new store.  
		 */
		public function StoreDetailView(upgradeItem:UpgradeItem)
		{
			// information object with data that power up item
			_upgradeItem = upgradeItem;
			
			var powerUp:int = _upgradeItem.powerUp;
			var powerUpMax:int = _upgradeItem.level.length;
			var index:uint = powerUp >= _upgradeItem.level.length ? _upgradeItem.level.length - 1 : powerUp 
			
			// adds icon
			_icon = new Image(Assets.getAtlas().getTexture(_upgradeItem.iconLg));
			_icon.x = 0;
			_icon.y = 0;
			addChild(_icon);
			
			// adds title
			_title = new TextField(210, 50, _upgradeItem.title);
			_title.border = true;
			_title.vAlign = "center";
			_title.x = _icon.width + _PAD;
			_title.y = 0;
			addChild(_title);
			
			// adds description
			_desc = new TextField(210, 50, _upgradeItem.desc[index]);
			_desc.border = true;
			_desc.vAlign = _desc.hAlign = "center";
			_desc.x = _icon.width + _PAD;
			_desc.y = _title.y + _title.height + _PAD;
			addChild(_desc);
			
			// adds cost
			_cost = new TextField(210, 25, "Cost " + String(_upgradeItem.level[index]));
			_cost.border = true;
			_cost.vAlign = _cost.hAlign = "center";
			_cost.x = _icon.width + _PAD;
			_cost.y = _desc.y + _desc.height + _PAD;
			addChild(_cost);
			
			// adds buy button
			_buy = new Button(Assets.getStoreAtlas().getTexture(_BUY));
			_buy.x = _icon.width + _PAD;
			_buy.y = _cost.y + _cost.height + _PAD;
			_buy.addEventListener(Event.TRIGGERED, dispatchBuyEvent);
			_buy.enabled = _upgradeItem.canAfford;
			addChild(_buy);			
			
			// adds thermometer
			_thermometer = new Vector.<Image>();
			for (var i:uint = 0; i < powerUpMax; i++) {
				var imageString:String = powerUp > 0 ? _FULL : _EMPTY;
				powerUp--;
				_thermometer[i] = new Image(Assets.getStoreAtlas().getTexture(imageString));
				_thermometer[i].x = (_icon.width + _PAD) + (i * (_thermometer[i].width + _PAD));
				_thermometer[i].y = _buy.y + _buy.height + _PAD;
				addChild(_thermometer[i]);
			}
			
			centerPivot(this);
		}
		
		/**
		 * Dispatches an event to trigger a store update.
		 * @param e Event.TRIGGERED
		 */		
		private function dispatchBuyEvent(e:Event):void {
			dispatchEvent(new StoreBuyEvent(StoreBuyEvent.CLICK));
		}
	}
}