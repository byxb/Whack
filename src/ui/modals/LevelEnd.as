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

package ui.modals
{	
	import com.byxb.extensions.starling.display.NumberField;
	import com.byxb.utils.centerPivot;
	
	import data.AchievementItem;
	import data.GameData;
	import data.Inventory;
	import data.SavedGame;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import world.items.ItemCombo;
	import world.items.items.*;

	/**
	 * Creates the level end screen.
	 * @author Johnny Nguyen - Johnny [at] byxb [dot] com 
	 */
	public class LevelEnd extends Modal
	{
		private const _TIME:Number=.5;	// duration of tween
		private const _PACE:Number=1; // time between each tween
		private const _MIN_DISTANCE:uint=250; // min distance needed to add to feats
		private const _MIN_SCORE:uint=250; // min score needed to add to feats
		private const _HUMAN:String="endScreen/jose";
		private const _BADGE:String="endScreen/badge";
		private const _MOLE:String="mole/bobbing0016";
		private const _HEAD:String="endScreen/head";
		private const _RETRY:String="menus/button_tryAgain";
		private const _SHOP:String="items/below/chest";
		
		private var _itemsCollectedDict:Dictionary;	// the amount of items collected during game play   
		private var _itemsCombo:Vector.<ItemCombo>;	// combos at least 2x 
		private var _distance:Number;
		private var _score:Number;
		private var _maxHeight:Number;
		private var _maxDepth:Number;
		private var _achievements:Vector.<AchievementItem>=new <AchievementItem>[];	// achievements reached during game play
		private var _items:Vector.<Item>=new <Item>[]; // references to all items in _itemsCollectedDict
		private var _totalMoleBonus:uint=0;
		private var _totalHumanBonus:uint=0;
		private var _feats:Array=new Array();
		private var _featsHeight:Vector.<uint>=new<uint>[]; // references to heights of each display object in _feats
		private var _isAnimating:Boolean=true;	
		
		/**
		 * Creates the level end screen.
		 */
		public function LevelEnd(itemsCollectedDict:Dictionary, itemsCombo:Vector.<ItemCombo>, distance:Number, score:Number, maxHeight:Number, maxDepth:Number)
		{
			super();
			
			// parameters passed in from HUD and World (via ItemManager)
			_itemsCollectedDict=itemsCollectedDict;
			_itemsCombo=itemsCombo;
			_distance=distance;
			_score=score;
			_maxHeight=maxHeight;
			_maxDepth=maxDepth;
			
			// convert height and depth values from pixels to feet
			_maxHeight*=Const.PIXEL_TO_FEET_RATIO;
			_maxDepth*=Const.PIXEL_TO_FEET_RATIO;
			
			// get achievements from GameData (the sharedObject)
			_achievements = GameData.game.achievements.getNewAchievements(_itemsCollectedDict, _itemsCombo, _distance, _score, _maxHeight, _maxDepth);
			
			addEventListener(TouchEvent.TOUCH, endAnimation);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * Skips level end animation. 
		 * @param e TouchEven.TOUCH
		 */
		private function endAnimation(e:TouchEvent):void
		{
// TODO: Add end animation functionality
			var touch:Touch = e.getTouch(this);
			
			if (touch && touch.phase == TouchPhase.ENDED && _isAnimating) {
				//
			}
		}
		
		/**
		 * Wait to be added to stage before initializing level end display objects.
		 * @param e Event.ADDED_TO_STAGE
		 */
		private function onAddedToStage(e:Event):void
		{	
			setStats();
			addBackgroundElements();
			addItems();
			addCurrencies();
			addFeats();
			animateItems();
			animateFeats();
		}
		
		private function setStats():void 
		{
			for (var key:Object in _itemsCollectedDict)
			{	
				var s:String = getQualifiedClassName(key).substring(19, getQualifiedClassName(key).length);

				GameData.game.stats.setItemTotalByClass(s, _itemsCollectedDict[key]);
			}
			trace("~~~~~~~~~~~~~~~~~~~~~~~~~~~");
		}
		
		/**
		 * Add background display objects to stage.
		 */
		private function addBackgroundElements():void 
		{
			var background:Quad=new Quad(stage.stageWidth, stage.stageHeight, 0xffe07d);
			background.x=0;
			background.y=0;
			addChild(background);
			
			var mole:Image = new Image(Assets.getAtlas().getTexture(_MOLE));
			centerPivot(mole);
			mole.x=stage.stageWidth * .16;
			mole.y=stage.stageHeight * .93;
			mole.scaleX=0;
			mole.scaleY=0;
			addChild(mole);
			
			var scaleMole:Tween=new Tween(mole, .5, Transitions.EASE_OUT_ELASTIC);
			scaleMole.scaleTo(1.7);
			Starling.juggler.add(scaleMole);
			
			var head:Image = new Image(Assets.getAtlas().getTexture(_HEAD));
			centerPivot(head);
			head.x=stage.stageWidth * .85;
			head.y=stage.stageHeight - 125;
			head.scaleX=0;
			head.scaleY=0;
			addChild(head);
			
			var scaleHead:Tween=new Tween(head, .5, Transitions.EASE_OUT_ELASTIC);
			scaleHead.scaleTo(.75);
			Starling.juggler.add(scaleHead);
		}	
		
		/**
		 * Add items collected during game play above the stage to be tweened down. 
		 */
		private function addItems():void 
		{
			// for each item in the dictionary, push the item into the temp vector times that items dictionary value 
			var temp:Vector.<Item> = new <Item>[];
			for (var key:Object in _itemsCollectedDict)
			{	
				for (var i:uint=0; i<_itemsCollectedDict[key]; i++)
				{
					temp.push(new key());
				}
			}
			
			// randomize the temp vector by splicing
			var length:uint=temp.length;
			for (i=0; i<length; i++)
			{
				var randomPos:int = int(Math.random() * temp.length);
				var item:Item = temp.splice(randomPos, 1)[0];
				
				// add items above stage
				centerPivot(item);
				_items[i] = item;
				_items[i].x=Math.floor(Math.random() * (1+500-300)) + 300;
				_items[i].y=Math.floor(Math.random() * (1-50+100)) - 100;
				addChild(_items[i]);
			}
		}
		
		/**
		 * Caluclate and add mole and human currencies to stage.  
		 */
		private function addCurrencies():void 
		{
			// get mole & human currency from the GameData (the sharedObject)
			var moleCurrency:int=GameData.game.inventory.moleCurrency;
			var humanCurrency:int=GameData.game.inventory.humanCurrency;
			
			// loop through the items vector to calculate new currency totals
			for (var i:uint=0; i<_items.length; i++)
			{
				moleCurrency+=_items[i].moleBonus;
				humanCurrency+=_items[i].humanBonus;
				
				_totalMoleBonus+=_items[i].moleBonus;
				_totalHumanBonus+=_items[i].humanBonus;
			}
			
			// save back to GameData
			GameData.game.inventory.moleCurrency = moleCurrency;
			GameData.game.inventory.humanCurrency = humanCurrency;
			
			var moleField:TextField=new TextField(100, 50, String(moleCurrency));
			centerPivot(moleField);
			moleField.x=(stage.stageWidth * .5) - moleField.width;
			moleField.y=stage.stageHeight - moleField.height;
			moleField.scaleX=0;
			moleField.scaleY=0;
			addChild(moleField);
			
			var scaleMoleField:Tween=new Tween(moleField, _TIME, Transitions.EASE_IN_OUT_ELASTIC);
			scaleMoleField.scaleTo(1);
			Starling.juggler.add(scaleMoleField);
			
			var humanField:TextField=new TextField(100, 50, String(humanCurrency));
			centerPivot(humanField);
			humanField.x=(stage.stageWidth * .5) + humanField.width;
			humanField.y=stage.stageHeight - humanField.height;
			humanField.scaleX=0;
			humanField.scaleY=0;
			addChild(humanField);
			
			var humanMoleField:Tween=new Tween(humanField, _TIME, Transitions.EASE_IN_OUT_ELASTIC);
			humanMoleField.scaleTo(1);
			Starling.juggler.add(humanMoleField);
		}

		/**
		 * Add feats to stage.  Feats are display objects that are tweened to show accomplishments.
		 */
		private function addFeats():void 
		{
			var achievementsField:Vector.<TextField>=new <TextField>[];
			var distanceField:TextField=new TextField(200, 50, "Distance: " + String(_distance) + "!");
			var scoreField:TextField=new TextField(200, 50, "Score: " + String(_score) + "!");
			var totalMoleBonusField:TextField=new TextField(200, 50, "Mole Bonus " + String(_totalMoleBonus) + "!");
			var totalHumanBonusField:TextField=new TextField(200, 50, "Human Bonus " + String(_totalHumanBonus) + "!");
			var shopBtn:Button=new Button(Assets.getAtlas().getTexture(_SHOP));
			var retryBtn:Button=new Button(Assets.getAtlas().getTexture(_RETRY));
			
			shopBtn.addEventListener(Event.TRIGGERED, onShop);
			retryBtn.addEventListener(Event.TRIGGERED, onRetry);

			// add achievements, if any
			for (var i:uint=0; i<_achievements.length; i++) 
			{
				achievementsField[i]=new TextField(100, 50, _achievements[i].title);
				_feats.push(achievementsField[i]);
			}
			
			// ensure minimums are met before adding to feats 
			if (_distance > _MIN_DISTANCE) _feats.push(distanceField);
			if (_score > _MIN_SCORE) _feats.push(scoreField);
			if (_totalMoleBonus > 0) _feats.push(totalMoleBonusField);
			if (_totalHumanBonus > 0) _feats.push(totalHumanBonusField);

			_feats.push(shopBtn);
			_feats.push(retryBtn);
			
			// getting heights for each feat, this is needed to ensure proper spacing during the tween 
			for (i=0; i<_feats.length; i++)
			{
				_featsHeight[i]=_feats[i].height;
			}
			
			for (i=0; i<_feats.length; i++)
			{
				centerPivot(_feats[i]);
				_feats[i].x=stage.stageWidth * .5;
				_feats[i].y=stage.stageHeight * .5;
				_feats[i].scaleX=0;
				_feats[i].scaleY=0;
				addChild(_feats[i])
			}
		}
		
		/**
		 * Tween items from the top to the bottom of the stage.
		 */
		private function animateItems():void 
		{
// TODO: add curve to tween so mole items are pulled into one corner and humuan items to the other.
			for (var i:uint=0; i<_items.length; i++)
			{
				var tweenItem:Tween=new Tween(_items[i], Math.random() * 3, Transitions.EASE_IN_BACK);
				tweenItem.moveTo(_items[i].x, stage.stageHeight - _items[i].y);
				Starling.juggler.add(tweenItem);
			}
		}
		
		/**
		 * Initializes feat tweens by progressively delaying the juggler call for each feat.
		 */
		private function animateFeats():void 
		{
			for (var i:uint=0; i<_feats.length; i++)
			{
				Starling.juggler.delayCall(scaleFeat, i*_PACE, i);
			}
		}
		
		/**
		 * Scales up the item from 0.
		 * @param i Index of the feats vector
		 */
		private function scaleFeat(i:uint):void
		{
			var scaleFeat:Tween=new Tween(_feats[i], 1, Transitions.EASE_IN_OUT_ELASTIC);
			scaleFeat.scaleTo(1);
			Starling.juggler.add(scaleFeat);
			
			tweenFeat(i);
		}
		
		/**
		 * Tween feats that have been added to stage.  Stored heights are used get the y coordinate.
		 * @param length The amount of feats on stage. 
		 */
		private function tweenFeat(length:uint):void
		{	
			for (var i:uint=0; i<length; i++)
			{
				var moveItem:Tween=new Tween(_feats[i], 1, Transitions.EASE_IN_OUT_ELASTIC);
				moveItem.moveTo(_feats[i].x, _feats[i].y - _featsHeight[length]);
				Starling.juggler.add(moveItem);
			}
		}
		
		/**
		 * When the button is clicked, dispatch an event that the level should restart. This event is handled by the Game class
		 * @param e Event.TRIGGERED
		 */
		private function onRetry(e:Event):void
		{
			this.dispatchEvent(new Event("tryAgain", true)); // the event has to bubble since LevelEnd will be a child instance of HUD
			this.removeFromParent(true);
		}
		
		/**
		 * When the button is clicked, dispatch an event that the level should restart. This event is handled by the Game class
		 * @param e Event.TRIGGERED
		 */
		private function onShop(e:Event):void
		{
			this.dispatchEvent(new Event("store", true)); // the event has to bubble since LevelEnd will be a child instance of HUD
			this.removeFromParent(true);
		}
	}
}
