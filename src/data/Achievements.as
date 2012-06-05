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
	
	import flash.utils.Dictionary;
	
	import world.items.ItemCombo;
	import world.items.items.Chest;
	import world.items.items.Dynamite;
	import world.items.items.Gem1_1;
	import world.items.items.Gem1_2;
	import world.items.items.Gem1_3;
	import world.items.items.Gem1_4;
	import world.items.items.Gem3_1;
	import world.items.items.Gem3_2;
	import world.items.items.Gem3_3;
	import world.items.items.Gem3_4;
	import world.items.items.Gold1;
	import world.items.items.Hat;
	import world.items.items.Item;
	import world.items.items.Pepper;
	import world.items.items.Ring;
	import world.items.items.Watch;
	
	/**
	 * Records achievements that have been accomplished.
	 * @author Johnny Nguyen - Johnny [at] byxb [dot] com 
	 */	
	public class Achievements extends Object {
		// consts for goals to match or exceed
		private const _GOAL_DISTANCE:uint=100;
		private const _GOAL_DEPTH:uint=100;
		private const _GOAL_HEIGHT:uint=100;
		private const _GOAL_HAT:uint=5;
		private const _GOAL_CHEST:uint=20;
		private const _GOAL_COMBO:uint=5;
		private const _GOAL_STAR:uint=20;
		private const _GOAL_DYNAMITE:uint=5;
		private const _GOAL_GEM:uint=100;
		
		// list of achievements
		private var _playedOnSponsor:Boolean = false;
		private var _whatsThe411:Boolean = false;
		private var _aLongWayToRun:Boolean=false;
		private var _spelunker:Boolean=false;
		private var _theFurIsFlying:Boolean=false;
		private var _dork:Boolean=false;
		private var _arrr:Boolean=false;
		private var _crownJewels:Boolean=false;
		private var _leafPeeper:Boolean=false;
		private var _megaCombo:Boolean=false;
		private var _turnOutTheLights:Boolean=false;
		private var _lepidopterist:Boolean=false;
		private var _holeyMoley:Boolean=false;
		private var _drippingInDiamonds:Boolean=false;
		private var _foodPyramid:Boolean=false;
		private var _economicStimulus:Boolean=false;
		private var _mayorOfMoletown:Boolean=false;
		
		// vector of all earned achievements in the life of the game (verus new achievements)
		private var _allEarnedAchievements:Vector.<AchievementItem>=new <AchievementItem>[];
		public function get allEarnedAchievements():Vector.<AchievementItem> {return _allEarnedAchievements;}
		
		/**
		 * Returns a vector of new acomplished achievements for the last play.  
		 * 
		 * @param itemsCollectedDict Items and the number of items collected.
		 * @param itemsCombo Items and the combo count.  Note, the same item different combo runs during game play. 
		 * @param distance Total distance.
		 * @param score Total score.
		 * @param height Max height.
		 * @param depth Max depth. 
		 * @return Total achievements accomplished.
		 */
		public function getNewAchievements(itemsCollectedDict:Dictionary, itemsCombo:Vector.<ItemCombo>, distance:Number, score:Number, height:Number, depth:Number):Vector.<AchievementItem>
		{
			var achievements:Vector.<AchievementItem>=new <AchievementItem>[];
			
			if (!_aLongWayToRun && distance > _GOAL_DISTANCE)
			{
				achievements.push(Const.A_LONG_WAY_TO_RUN);
				_allEarnedAchievements.push(Const.A_LONG_WAY_TO_RUN);
				_aLongWayToRun=true;
			}
						
			if (!_spelunker && depth > _GOAL_DEPTH)
			{
				achievements.push(Const.SPELUNKER);
				_allEarnedAchievements.push(Const.SPELUNKER);
				_spelunker=true; 
			}
			
			if (!_theFurIsFlying && height > _GOAL_HEIGHT)
			{
				achievements.push(Const.THE_FUR_IS_FLYING);
				_allEarnedAchievements.push(Const.THE_FUR_IS_FLYING);
				_theFurIsFlying=true;
			}
			
			if (!_dork && itemsCollectedDict[Hat] >= _GOAL_HAT)
			{
				achievements.push(Const.DORK);
				_allEarnedAchievements.push(Const.DORK);
				_dork=true;
			}
			
			if (!_arrr && itemsCollectedDict[Chest] >= _GOAL_CHEST)
			{
				achievements.push(Const.ARRR);
				_allEarnedAchievements.push(Const.ARRR);
				_arrr=true;
			}
			
			if (!_drippingInDiamonds && 
				itemsCollectedDict[Gem1_1] + 
				itemsCollectedDict[Gem1_2] + 
				itemsCollectedDict[Gem1_3] + 
				itemsCollectedDict[Gem1_4] + 
				itemsCollectedDict[Gem3_1] + 
				itemsCollectedDict[Gem3_2] + 
				itemsCollectedDict[Gem3_3] + 
				itemsCollectedDict[Gem3_4] >= _GOAL_GEM) 
			{
				achievements.push(Const.DRIPPING_IN_DIAMONDS);
				_allEarnedAchievements.push(Const.DRIPPING_IN_DIAMONDS);
				_drippingInDiamonds=true;
			}
			
			if (!_crownJewels && 
				itemsCollectedDict[Gem1_1] && 
				itemsCollectedDict[Gem1_2] && 
				itemsCollectedDict[Gem1_3] && 
				itemsCollectedDict[Gem1_4] && 
				itemsCollectedDict[Gem3_1] && 
				itemsCollectedDict[Gem3_2] && 
				itemsCollectedDict[Gem3_3] && 
				itemsCollectedDict[Gem3_4]) 
			{
				achievements.push(Const.CROWN_JEWELS);
				_allEarnedAchievements.push(Const.CROWN_JEWELS);
				_crownJewels=true;
			}
			
			for (var i:uint=0; i<itemsCombo.length; i++) 
			{
				if (!_megaCombo && itemsCombo[i].value >= 5) 
				{
					achievements.push(Const.MEGA_COMBO);
					_allEarnedAchievements.push(Const.MEGA_COMBO);
					_megaCombo=true;
				}
			}
			
/*			// achievements not wired into the game currently
			if (!_playedOnSponsor && playedOnSponsor) 
			{
				achievements.push(Const.PLAYED_ON_SPONSOR);
				_allEarnedAchievements.push(Const.PLAYED_ON_SPONSOR);
				_playedOnSponsorIsNew=true;
			}
						
			if (!_whatsThe411 && whatsThe411) 
			{
				achievements.push(Const.WHATS_THE_411);
				_allEarnedAchievements.push(Const.PLAYED_ON_SPONSOR);
				_whatsThe411IsNew=true;
			}
			
			if (!turnOutTheLights && itemsCollectedDict[Star] >= _GOAL_STAR)
			{
				achievements.push(Const.TURN_OUT_THE_LIGHTS);
				_allEarnedAchievements.push(Const.TURN_OUT_THE_LIGHTS);
				_turnOutTheLights=true;
			}
			
			if (!_mayorOfMoletown && mayorOfMoletown) 
			{
			achievements.push(Const.MAYOR_OF_MOLETOWN);
			_allEarnedAchievements.push(Const.MAYOR_OF_MOLETOWN);
			_mayorOfMoletownIsNew=true;
			}
			
			if (!_foodPyramid && 
				itemsCollectedDict[Pepper])  &&
				itemsCollectedDict[Pumpkin]  &&
				itemsCollectedDict[Acorn]    && 
				itemsCollectedDict[Mushroom] &&
				itemsCollectedDict[Apple]	 &&
				itemsCollectedDict[Carrot])
			{
				achievements.push(Const.FOOD_PYRAMID);
				_allEarnedAchievements.push(Const.FOOD_PYRAMID);
				_foodPyramid=true;
			}
			
			if (!leafPeeper  &&
				itemsCollectedDict[Leaf1] &&
				itemsCollectedDict[Leaf2] &&
				itemsCollectedDict[Leaf3]) 
			{
				achievements.push(Const.LEAF_PEEPER);
				_allEarnedAchievements.push(Const.LEAF_PEEPER);
				_leafPeeper=true;
			}
			
			if (!lepidopterist &&
				itemsCollectedDict[butterfly1] &&
				itemsCollectedDict[butterfly2] &&
				itemsCollectedDict[butterfly3]) 
			{
				achievements.push(Const.LEPIDOPTERIST); 
				_allEarnedAchievements.push(Const.LEPIDOPTERIST);
				_lepidopterist=true;
			} */
			
			return achievements;
		}
		
		public function Achievements() {
			//
		}
	}
}