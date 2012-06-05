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
	
	import flash.geom.Point;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	import store.events.StoreBuyEvent;
	import store.events.StoreCloseEvent;
	
	/**
	 * The Store creates the store view.
	 * @author Johnny Nguyen - Johnny [at] byxb [dot] com 
	 */
	public class Store extends starling.display.Sprite
	{	
		private const _BACK_TO_GAME:String = "buttons/playBtn";
		
		private var _storeData:StoreData;
		private var _background:Sprite;
		private var _currencies:Vector.<TextField>;
		private var _storeButtons:Vector.<Vector.<StoreButton>>;
		private var _backToGame:Button;
		private var _isDetailViewActive:Boolean;
		private var _maxBtnHt:Number;
		private var _currentStoreButton:StoreButton;
		private var _detailView:StoreDetailView;
		
		/**
		 * Creates a new Store.
		 */
		public function Store()
		{	
			_storeData = new StoreData();
			_background = new Sprite();
			_currencies = new Vector.<TextField>();
			_storeButtons = new Vector.<Vector.<StoreButton>>();
			_backToGame = new Button(Assets.getStoreAtlas().getTexture(_BACK_TO_GAME));
			_isDetailViewActive = false;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		/**
		 * Adds store elements when the class has access to stage.
		 * @param e Event.ADDED_TO_STAGE
		 */
		private function init(e:Event):void
		{			
			addBackground();
			addCurrencies();
			addStoreButtons();
			addBackToGame();
			
//TODO: Remove reset button in production
			var resetButton:Button = new Button(Assets.getStoreAtlas().getTexture("buttons/iconBgSm"), "Reset");
			resetButton.addEventListener(Event.TRIGGERED, resetStore);
			addChild(resetButton);
		}
		
		/**
		 * Adds background elements.  The horizon texture is added on top of two drawn quads.
		 */
		private function addBackground():void 
		{
			// creates sky and ground at .75 of stage height to account for animating the background up and down
			var sky:Quad = new Quad(stage.stageWidth, stage.stageHeight * .75, 0xffeb90);
			var ground:Quad = new Quad(stage.stageWidth, stage.stageHeight * .75, 0xac8dae);
			var horizon:Image = new Image(Assets.getStoreAtlas().getTexture("background"));
			
			sky.x = 0;
			sky.y = 0;
			ground.x = 0;
			ground.y = stage.stageHeight * .75;
			horizon.x = 0;
			horizon.y = (stage.stageHeight * .75) - (horizon.height * .6); // horizon.height is at .6 because the horizon in the texture is not perfectly center
			
			_background.addChild(sky);
			_background.addChild(ground);
			_background.addChild(horizon);
			
			centerPivot(_background);
			_background.x = stage.stageWidth * .5;
			_background.y = stage.stageHeight * .5;
			addChild(_background);
		}
		
		/**
		 * Adds currency elements.  Currency displays the monetary values for store purchaces. 
		 */
		private function addCurrencies():void 
		{
			// gets currency data from the control
			var currenciesData:Vector.<uint> = _storeData.getCurrencies();
			
			// adds currency value to textfield and adds to stage
			for (var j:uint = 0; j < currenciesData.length; j++) 
			{
				_currencies[j] = new TextField(200, 100, "currency " + String(currenciesData[j]));
				_currencies[j].border = true;
				_currencies[j].x = _currencies[j].width * .5;
				_currencies[j].y = (stage.stageHeight * .5) - (_currencies[j].height * .5) + (j * _currencies[j].height);
				centerPivot(_currencies[j]);
				addChild(_currencies[j]);
			}
		}
		
		/**
		 * Adds store button elements.  Each store button is a power up item that can be purchased.
		 * Each store button has an object with data for that power up item. 
		 */
		private function addStoreButtons():void 
		{	
			// rowWidth and rowStart point are used to determine starting point of the upgrade items
			var rowWidth:Number = 0;
			var rowStartPt:Number = 0;
			
			// gets categories from the control
			var categories:Vector.<String> = _storeData.getCategories();
			
			// gets upgradeItems from the control 
			var upgradeItems:Vector.<Vector.<UpgradeItem>> = _storeData.getUpgradeItems(categories);
			
			// make a vector of store buttons by category
			for (var i:uint = 0; i < upgradeItems.length; i++)
			{
				// max button height used for alignment and tweens 
				_maxBtnHt = 0;
				_storeButtons[i] = new Vector.<StoreButton>();
				
				// create new StoreButton with upgradeItems
				for (var j:uint = 0; j < upgradeItems[i].length; j++)
				{
					_storeButtons[i][j] = new StoreButton(upgradeItems[i][j]);
					_maxBtnHt = Math.max(_maxBtnHt, _storeButtons[i][j].height);
				}
			}
			
			// add vector of store buttons to stage
			for (i = 0; i < _storeButtons.length; i++)
			{
				// need to find total row width to properly center the row
				rowWidth = 0;
				
				for (j = 1; j < _storeButtons[i].length; j++)
				{
					rowWidth += _storeButtons[i][j].width;
				}
				
				// the most left position is calculated from rowWidth
				rowStartPt = ((stage.stageWidth - rowWidth) * .5);
				
				// add store buttons to stage
				for (var k:uint = 0; k < _storeButtons[i].length; k++)
				{
					_storeButtons[i][k].x = rowStartPt + (k * _storeButtons[i][k].width);
					_storeButtons[i][k].y = (stage.stageHeight * .5) - (_storeButtons[i][k].height * .5) + (i * _storeButtons[i][k].height);
					_storeButtons[i][k].addEventListener(Event.TRIGGERED, addDetailView);
					addChild(_storeButtons[i][k]);
				}
			}
		}
		
		/**
		 * Adds "Back To Game" button.
		 */
		private function addBackToGame():void
		{
			centerPivot(_backToGame);
			_backToGame.x = stage.stageWidth - (_backToGame.width * .5);
			_backToGame.y = stage.stageHeight - (_backToGame.height * .5);
			_backToGame.addEventListener(Event.TRIGGERED, dispatchCloseEvent);
			addChild(_backToGame);
		}
		
		/**
		 * Adds detail view where players and purchase power up items.
		 * @param e Event.TRIGGERED
		 */
		private function addDetailView(e:Event):void
		{
			// resets store if the active store button is clicked again
			if (_currentStoreButton === (e.target as StoreButton)) {
				_currentStoreButton = null;
				resetStore();
				return;
			}
			
			// sets boolean
			_isDetailViewActive = true;
			
			// set old currentStoreButton's isActive status
			// save new currentStoreButton
			// set new currentStoreButton's isActive status
			if (_currentStoreButton != null) _currentStoreButton.upgradeItem.isActive = false;
			_currentStoreButton = (e.target as StoreButton);
			_currentStoreButton.upgradeItem.isActive = true;
			
			// calculates target Y for tweens
			var category:String = (e.target as StoreButton).upgradeItem.category;
			var targetY:Number = category == "human" ? (stage.stageHeight * .5) + _maxBtnHt : (stage.stageHeight * .5) - _maxBtnHt;
			
			// tween items to make room for store detail
			tweenBackground(targetY);
			tweenStoreButtons(targetY);
			scaleStoreButtons();
			tweenCurrency();
			
			// updates the store detail view
			updateStoreDetailView();
		}
		
		/**
		 * Tweens the background based on which store button is clicked.
		 * @param targetY the end y tween position
		 */
		private function tweenBackground(targetY:Number):void 
		{
			var tweenBackground:Tween = new Tween(_background, .5, Transitions.EASE_OUT);
			tweenBackground.moveTo(_background.x, targetY);
			Starling.juggler.add(tweenBackground);
		}
		
//TODO: do not call function if store buttons are already tweened to targetY		
		/**
		 * Tweens the store buttons based on which store button is clicked.
		 * @param targetY the end y tween position
		 */
		private function tweenStoreButtons(targetY:Number):void 
		{		
			// tween human power up items up
			for (var i:uint = 0; i < _storeButtons[0].length; i++) {
				var tweenUp:Tween = new Tween(_storeButtons[0][i], .5, Transitions.EASE_OUT); 
				tweenUp.moveTo(_storeButtons[0][i].x, _maxBtnHt * .5);
				Starling.juggler.add(tweenUp);
			}
			
			// tween mole power up items down
			for (var j:uint = 0; j < _storeButtons[0].length; j++) {
				var tweenDown:Tween = new Tween(_storeButtons[1][j], .5, Transitions.EASE_OUT); 
				tweenDown.moveTo(_storeButtons[1][j].x, stage.stageHeight - (_maxBtnHt * .5));
				Starling.juggler.add(tweenDown);
			}
		}
		
		/**
		 * Scales the store buttons based on which store button is clicked.  Active items are tweened 
		 * to scale 1, and inactive items are tweened to scale .5.
		 */
		private function scaleStoreButtons():void 
		{
			var scale:Number = 1;
			
			for (var i:uint = 0; i < _storeButtons.length; i++) 
			{
				for (var j:uint = 0; j < _storeButtons[i].length; j++) 
				{
					// scale currentStoreButton to 1
					scale = (_currentStoreButton === _storeButtons[i][j]) ? 1 : .5;
					
					// tween the scale of others to .5
					var tweenScale:Tween = new Tween(_storeButtons[i][j], .5, Transitions.EASE_OUT_ELASTIC);
					tweenScale.scaleTo(scale);
					Starling.juggler.add(tweenScale);
				}
			}
		}
		
		/**
		 * Tweens currency based on selected store button.
		 */
		private function tweenCurrency():void 
		{
			// sets active and target positions
			var category:String = _currentStoreButton.upgradeItem.category;
			var active:Boolean = category == "mole" ? true : false;
			var inactive:Boolean = !active; 
			var targetY:uint = category == "mole" ? _maxBtnHt * .5 : stage.stageHeight - (_maxBtnHt * .5); 
			
			// tweens active currency to the middle of the screen
			var tweenActive:Tween = new Tween(_currencies[uint(active)], .5, Transitions.EASE_OUT); 
			tweenActive.moveTo(_currencies[uint(active)].x, stage.stageHeight * .5);
			Starling.juggler.add(tweenActive);
			
			// tweens inactive currency to the to top of screen if human, to bottom of screen if mole
			var tweenInactive:Tween = new Tween(_currencies[uint(inactive)], .5, Transitions.EASE_OUT); 
			tweenInactive.moveTo(_currencies[uint(inactive)].x, targetY);
			Starling.juggler.add(tweenInactive);
		}
		
		/**
		 * Updates each store button's information object.
		 * @param e StoreBuyEvent.CLICK
		 */
		private function updateStore(e:Event):void 
		{ 
			_storeData.updateStore(_currentStoreButton.upgradeItem);
			updateCurrencies();
			updateStoreDetailView();
		}
		
		/**
		 * Updates the currency text field.
		 */
		private function updateCurrencies():void {
			var currenciesData:Vector.<uint> = _storeData.getCurrencies();
			
			if (_currencies.length > 0) 
			{
				for (var i:uint = 0; i < currenciesData.length; i++) 
				{
					_currencies[i].text = String("currency " + currenciesData[i]);
				}
			}
		}
		
		/**
		 * Udpates store detail view.
		 */
		private function updateStoreDetailView():void 
		{
			// new up store detail and pass in current button's upgradeItem
			if (_detailView != null && _detailView.stage) removeChild(_detailView, true);
			_detailView = new StoreDetailView(_currentStoreButton.upgradeItem);
			_detailView.x = stage.stageWidth * .5;
			_detailView.y = stage.stageHeight * .5;
			_detailView.addEventListener(StoreBuyEvent.CLICK, updateStore);
			addChild(_detailView);	
		}
		
		/**
		 * Dispatches an event to trigger store close.
		 * @param e Event.TRIGGERED
		 */
		private function dispatchCloseEvent(e:Event):void
		{
			dispatchEvent(new StoreCloseEvent(StoreCloseEvent.STORE_CLOSE));
		}
			
		/**
		 * Resets store elements to initial positions.
		 * @param e Event.TRIGGERED
		 */
		private function resetStore(e:Event = null):void 
		{
			removeChild(_detailView);
			
			// tweens background
			var tweenBackground:Tween = new Tween(_background, .5, Transitions.EASE_OUT); 
			tweenBackground.moveTo(_background.x, stage.stageHeight * .5);
			Starling.juggler.add(tweenBackground);
			
			// tween currencies
			for (var i:uint = 0; i < _currencies.length; i++) 
			{
				var tweenCurrency:Tween = new Tween(_currencies[i], .5, Transitions.EASE_OUT);
				tweenCurrency.moveTo(_currencies[i].x, (stage.stageHeight * .5) - (_currencies[i].height * .5) + (i * _currencies[i].height));
				Starling.juggler.add(tweenCurrency);
			}
			
			for (i = 0; i < _storeButtons.length; i++)
			{
				// scale store buttons
				for (var j:uint = 0; j < _storeButtons[i].length; j++)
				{
					_storeButtons[i][j].scaleX = 1;
					_storeButtons[i][j].scaleY = 1;
				}
				
				// tween store buttons
				for (var k:uint = 0; k < _storeButtons[i].length; k++)
				{	
					var tweenToCenter:Tween = new Tween(_storeButtons[i][k], .5, Transitions.EASE_OUT);
					tweenToCenter.moveTo(_storeButtons[i][k].x, (stage.stageHeight * .5) - (_storeButtons[i][k].height * .5) + (i * _storeButtons[i][k].height));
					Starling.juggler.add(tweenToCenter);
				}
			}
		}
	}
}