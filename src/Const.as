//------------------------------------------------------------------------------
//
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
	import data.AchievementItem;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import store.UpgradeItem;

	/**
	 * 
	 *  @author Justin Church justin [at] byxb [dot] com
	 * 
	 */
	public class Const
	{
		//General
		public static const FPS:uint=60;
		public static const GRAVITY:Number=.2;
		public static const BASE_REACH_RADIUS:uint=60;
		public static const PIXEL_TO_FEET_RATIO:Number=.004;

		private static var _width:uint=800;

		/**
		 * The width of the stage (as last set)
		 * @return the stage width settings
		 */
		public static function get stageWidth():uint
		{
			return _width;
		}
		
		private static var _height:uint=450;
		/**
		 * The height of the stage (as last set)
		 * @return the stage height settings
		 */
		public static function get stageHeight():uint
		{
			return _height;
		}

		/**
		 * Sets the size of the display area.
		 * @param w Stage width
		 * @param h Stage height
		 */
		public static function setSize(w:uint, h:uint):void
		{
			_width=w;
			_height=h;

		}

		//Ground &Tunnel
		public static const TUNNEL_LENGTH_SEGMENTS:uint=250;
		public static const TUNNEL_CROSS_SEGMENTS:uint=1;
		public static const TUNNEL_MOLEHILL_FPS:uint=20;
		public static const TUNNEL_MOLEHILL_Y_OFFSET:uint=5;
		public static const TUNNEL_PIXEL_BUFFER:uint=5;
		public static const MAX_TUNNEL_LENGTH:uint=1000;
		public static const GROUND1_WIDTH:uint=4096;

		//Mole		
		public static const MOLE_FPS:uint=30;
		public static const MOLE_BOB_FPS:uint=15;
		public static const MOLE_MAX_FPS:uint=60;
		public static const MOLE_COSTUME_NAME:Vector.<String>=new <String>["mole/bobbing", "mole/digging", "mole/cannonball", "mole/flailIntoDive", "mole/intoDive", "mole/surfacing"];
		public static const MOLE_SLOW_SPEED:Number=10;
		public static const MOLE_FAST_SPEED:Number=35;

		//Camera
		public static const CAMERA_MIN_SCALE:Number=.4;
		public static const CAMERA_MAX_SCALE:Number=1;
		public static const CAMERA_SHAKE_INTERVAL:Number=.016666666;
		/**
		 * The largest potential viewport that may be shown in the camera.
		 * 
		 * @return a Rectangle centered on (0,0).
		 */
		public static function get cameraMaxRect():Rectangle
		{
			return new Rectangle(-(stageWidth / 2) * (1 / CAMERA_MIN_SCALE), -(stageHeight / 2) * (1 / CAMERA_MIN_SCALE), stageWidth * (1 / CAMERA_MIN_SCALE), stageHeight * (1 / CAMERA_MIN_SCALE));
		}

		//Hammer
		public static const HAMMER_WHACK_PREVIEW_SEGMENTS:uint=50;

		//items
		public static const ITEMS_CELL_SIZE:uint=100;

		//Upgrade Items (category:String, itemId:String, title:String, desc:Vector.<String>, level:Vector.<uint>, iconSm:String, iconLg:String, iconBgSm:String, iconBgLg:String)
		public static const UPGRADE_ITEMS:Vector.<UpgradeItem> = new <UpgradeItem>[
			new UpgradeItem("human", "hammers",  		"Use hammers to increase mole velocity.",         new <String>["Whacker", "Mallet", "Nailer", "Pneumatic", "Thor", "Key to Moletown"],                      				new <uint>[150, 200, 400, 800, 1000], "items/below/3gem2", "items/below/3gem2"), 
			new UpgradeItem("human", "whacks",   		"Use whacks to increase mole velocity.",          new <String>["One and Done", "Mulligan", "Fool Me Twice", "Third Time's a Charm", "Four the Love of..."],  			    new <uint>[100, 200, 400, 800, 1000], "items/below/3gem2", "items/below/3gem2"),
			new UpgradeItem("human", "dynamite",   		"Use dynamite to increase mole velocity.",        new <String>["Pacifist", "Just in Case", "The First Was Lonely", "Boom Boom Boom", "Well-Stocked", "Person of Interest"], new <uint>[100, 200, 400, 800, 1000], "items/below/3gem2", "items/below/3gem2"),
			new UpgradeItem("mole",  "goggles",  		"Use goggles to increase mole velocity.",         new <String>["Tunnel Vision", "Beer Goggles", "Binoculers", "Night Vision Goggles", "Lasik"], 							new <uint>[100, 200, 400, 800, 1000], "items/below/3gem2", "items/below/3gem2"),
			new UpgradeItem("mole",  "maneuverability", "Use maneuverability to increase mole velocity.", new <String>["Way of the Rock", "Way of the Tree", "Way of the Mole", "Way of the Ferret", "Way of the Snake"], 		    new <uint>[100, 200, 400, 800, 1000], "items/below/3gem2", "items/below/3gem2"),
			new UpgradeItem("mole",  "overalls",   		"Use overalls to increase mole velocity.",        new <String>["El Cheapo", "The Classic", "The Bashful", "Deluxe", "Cargo"], 											    new <uint>[100, 200, 400, 800, 1000], "items/below/3gem2", "items/below/3gem2")
		];
		
		// Achievement Items (title:String, description:String, textureKey:String, moleBonus:int, humanBonus:int, earned:Boolean)
		public static const PLAYED_ON_SPONSOR   :AchievementItem=new AchievementItem("Played on Sponsor"   , "", "", 50, 50, true);
		public static const WHATS_THE_411       :AchievementItem=new AchievementItem("What's the 411?"     , "", "", 50, 50, true);
		public static const A_LONG_WAY_TO_RUN   :AchievementItem=new AchievementItem("A Long Way to Run"   , "", "", 50, 50, true);
		public static const SPELUNKER           :AchievementItem=new AchievementItem("Spelunker"           , "", "", 50, 50, true);
		public static const THE_FUR_IS_FLYING   :AchievementItem=new AchievementItem("The Fur is Flying"   , "", "", 50, 50, true);
		public static const DORK                :AchievementItem=new AchievementItem("Dork"                , "", "", 50, 50, true);
		public static const ARRR                :AchievementItem=new AchievementItem("Arrr!"               , "", "", 50, 50, true);
		public static const CROWN_JEWELS        :AchievementItem=new AchievementItem("Crown Jewels"        , "", "", 50, 50, true);
		public static const LEAF_PEEPER         :AchievementItem=new AchievementItem("Leaf Peeper"         , "", "", 50, 50, true);
		public static const MEGA_COMBO          :AchievementItem=new AchievementItem("Mega Combo"          , "", "", 50, 50, true);
		public static const TURN_OUT_THE_LIGHTS :AchievementItem=new AchievementItem("Turn Out the Lights" , "", "", 50, 50, true);
		public static const LEPIDOPTERIST       :AchievementItem=new AchievementItem("Lepidopterist"       , "", "", 50, 50, true);
		public static const HOLEY_MOLEY         :AchievementItem=new AchievementItem("Holey Moley"         , "", "", 50, 50, true);
		public static const DRIPPING_IN_DIAMONDS:AchievementItem=new AchievementItem("Dripping in Diamonds", "", "", 50, 50, true);
		public static const FOOD_PYRAMID        :AchievementItem=new AchievementItem("Food Pyramid"        , "", "", 50, 50, true);
		public static const MAYOR_OF_MOLETOWN   :AchievementItem=new AchievementItem("Mayor of Moletown"   , "", "", 50, 50, true);
		public static const ECONOMIC_STIMULUS   :AchievementItem=new AchievementItem("Economic Stimulus"   , "", "", 50, 50, true);
	}
}
