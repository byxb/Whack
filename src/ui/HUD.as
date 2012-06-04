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


package ui
{

	import com.byxb.extensions.starling.display.NumberField;
	import com.byxb.utils.*;
	
	import flash.utils.Dictionary;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	import ui.modals.LevelEnd;
	
	import world.items.ItemCombo;
	import world.items.items.Item;


	/**
	 * A Singleton display object for the score, distance and money stats as well as any modal menus.
	 * I'm doing this as a 
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class HUD extends Sprite
	{
		private static var instantiationLock:Boolean=true;
		private static var _instance:HUD;

		private var _distanceField:NumberField;
		private var _scoreField:NumberField;
		private var _maxHeight:Number;
		private var _maxDepth:Number;
		private var _traceField:NumberField;
		private var _levelEnd:LevelEnd;

		/**
		 * Returns the existing instance of the HUD or generates a new one if none is present.
		 * There can only be once instance.  This property is used instead of <code>new HUD()</code>
		 * @return 
		 */
		public static function get instance():HUD
		{
			if (!_instance)
			{
				instantiationLock=false;
				_instance=new HUD();
				instantiationLock=true;
			}
			return _instance;
		}

		/**
		 * The Game score.  Just supply the number.  The number is automatically formatted.
		 * @return Number of the score without formatting.
		 */
		public function get score():Number  { return _scoreField.value; }
		public function set score(v:Number):void  { _scoreField.value=v; updatePositions()}

		/**
		 * The Distance the mole has travelled this round.  Just supply the number.  The number is automatically formatted.
		 * @return Number of the distance travelled without formatting.
		 */
		public function get distance():Number  { return _distanceField.value; updatePositions()}
		public function set distance(v:Number):void  { _distanceField.value=v; }
		
		public function get maxHeight():Number { return _maxHeight; }
		public function set maxHeight(value:Number):void { _maxHeight; }
			
		public function get maxDepth():Number { return _maxDepth; }
		public function set maxDepth(value:Number):void { _maxDepth=value; }

		/**
		 * This is a singleton managed by the instance property.  An error is thrown if you attempt to instantiate via the constructor.
		 * @throws Error
		 */
		public function HUD()
		{
			if (instantiationLock)
			{
				throw new Error("Instantiate through the instance static property.");
			}
			
			_distanceField=new NumberField("Distance: ", Assets.getAtlas(), "fonts/font", "default", 6, 1, NumberField.ALIGN_LEFT, false, false);
			_distanceField.characterSpacing=-3;
			
			_scoreField=new NumberField("Score: ", Assets.getAtlas(), "fonts/font", "default", 6, 0, NumberField.ALIGN_LEFT, false, false);
			_scoreField.characterSpacing=-3;		

			addChild(_scoreField);
			addChild(_distanceField);
			updatePositions();
		}

		/**
		 * Show the modal for when the level is over (the mole comes to a halt)
		 */
		public function levelEnd(itemsCollectedDict:Dictionary, itemsCombo:Vector.<ItemCombo>):void
		{
			_levelEnd=new LevelEnd(itemsCollectedDict, itemsCombo, _distanceField.value, _scoreField.value, _maxHeight, _maxDepth);
			_levelEnd.x=0;
			_levelEnd.y=0;
			addChild(_levelEnd);
		} 

		/**
		 * The score and distance field positions need to be updated depending on the width of their current values.
		 */
		private function updatePositions():void
		{
			_distanceField.x=10;
			_scoreField.x=_distanceField.x + _distanceField.width + 20;
		}

	}
}
