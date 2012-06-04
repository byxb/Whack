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

package world
{

	import com.byxb.extensions.starling.display.CameraSprite;
	import com.byxb.extensions.starling.events.CameraUpdateEvent;
	import com.byxb.geom.InfiniteRectangle;
	import com.byxb.utils.*;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	
	import ui.HUD;
	
	import world.effects.Dirt;
	import world.events.HammerWhackEvent;
	import world.events.MoleBobEvent;
	import world.events.MoleMoveEvent;
	import world.events.MoleStopEvent;
	import world.events.MoleSurfaceEvent;
	import world.events.MoleWhackEvent;
	import world.hammers.FirstSwing;
	import world.items.ItemManager;

	/**
	 * The World is the main game environment for Whack.  It extends CameraSprite so have pan, zoom, rotation and shake capabilities built in
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class World extends CameraSprite
	{
		private var _background:Background;
		private var _tunnel:Tunnel;
		private var _mole:Mole;
		private var _firstSwing:FirstSwing;
		private var _itemManager:ItemManager;
		private var _hud:HUD;
		private var _debris:Dirt;

		/**
		 * Initialize the world
		 */
		public function World()
		{
			super(new Rectangle(0, 0, 800, 450), null, .3, .1, .01);
			_background=new Background(); //parallax background with scenery
			_tunnel=new Tunnel(); //Tunnel that is dug in the foreground earth
			_mole=new Mole(); //the main character
			_firstSwing=new FirstSwing() //the hammer setup for doing the whack
			_itemManager=new ItemManager(); //the collectible items and obstacles
			_debris=new Dirt(false); //dirt particle effect used when diggin the tunnel

			//a reference to the HUD to be used to communicate level end.  
			//It is not added to the World DisplayList since it should not be affected by the camera moveemnt
			_hud=HUD.instance; 
			
			addChild(_background);
			addChild(_tunnel);
			addChild(_itemManager);
			addChild(_debris);
			addChild(_mole);
			addChild(_firstSwing);

			this.moveTo(0, 0, 1.55, 0, true);// force the camera in for a closeup
			this.easingZoom=.01;//set the zoom easing low for a slow zoom ease
			this.moveTo(0, 0, .6, 0, false); //set a broader zoom (pull out slowly)

			addEventListener(CameraUpdateEvent.CAMERA_UPDATE, updateBackground);
			_mole.addEventListener(MoleWhackEvent.MOLE_WHACK, onMoleWhack);
			_mole.addEventListener(MoleSurfaceEvent.MOLE_SURFACE, onMoleSurface);
			_mole.addEventListener(MoleMoveEvent.MOLE_MOVE, onMoleMove)
			_mole.addEventListener(MoleBobEvent.MOLE_BOB, onMoleBob);
			_mole.addEventListener(MoleStopEvent.MOLE_STOP, onMoleStop);
			_firstSwing.addEventListener(HammerWhackEvent.HAMMER_WHACK, onHammerWhack);
		}

		/**
		 * A reset call to reset the hammer, mole, background, item manager, tunnel, etc.  In development, not yet in use
		 * @param e
		 */
		private function resetLevel(e:Event):void
		{
			_firstSwing.reset();
			_mole.reset()
			_itemManager.reset();

			this.moveTo(0, 0, 1.55, 0, true);
			this.easingZoom=.01;
			this.moveTo(0, 0, .6, 0, false);
		}
		
		private function onMoleStop(e:MoleStopEvent):void 
		{
			_hud.levelEnd(_itemManager.itemsCollectedDict, _itemManager.itemsCombo); 
		}

		/**
		 * Handler for when the mole changes intensity be going up or down
		 * @param e MoleBobEvent
		 */
		private function onMoleBob(e:MoleBobEvent):void
		{
			_firstSwing.setIntensity(e.intensity);
		}

		/**
		 * Handler for when the FirstSwing instance starts the whack
		 * @param e HammerWhackEvent
		 */
		private function onHammerWhack(e:HammerWhackEvent):void
		{
			_mole.whack(e.direction);

		}

		/**
		 * Handler for when the mole resonds to the HammerWhackEvent and starts moving
		 * @param e MoleWhackEvent
		 */
		private function onMoleWhack(e:MoleWhackEvent):void
		{
			shake(e.velocity.length / 2, 4);
			_debris.start()
		}

		/**
		 * Handler for when the mole breaks the surface, either going into the ground or out of the ground
		 * @param e MoleSurfaceEvent
		 */
		private function onMoleSurface(e:MoleSurfaceEvent):void
		{
			if (!e.isAbove)
			{
				//do a small shake when the mole thuds into the ground
				shake((e.target as Mole).speedRatio, 10);
				_debris.start()
			}
			else
			{
				_debris.stop()
			}

		}

		/**
		 * Handler for when the mole moves so that the camera can move and the tunnel plus debris can update
		 * @param e MoleMoveEvent
		 */
		private function onMoleMove(e:MoleMoveEvent):void
		{
			_tunnel.digToPoint(e.location, e.speedRatio);
			//This is a fairly brute force way of calculating the adjusted scale for the camera
			var slope:Number=((Const.CAMERA_MIN_SCALE - Const.CAMERA_MAX_SCALE) / (1 - e.minSpeedRatio));
			var s:Number=slope * clamp(e.speedRatio, e.minSpeedRatio, 1) + (Const.CAMERA_MIN_SCALE - slope);
			this.moveTo(_mole.x, _mole.y, s, 0);
			
			// update the distance stat in the game UI
			_hud.distance=_mole.x * Const.PIXEL_TO_FEET_RATIO;
			
			// update max height and depth of mole
			_hud.maxHeight=Math.min(_hud.maxHeight, e.location.y);
			_hud.maxDepth=Math.max(_hud.maxDepth, e.location.y);
			
			//update the emitter properties for the dirt
			_debris.emitterX=e.location.x;
			_debris.emitterY=e.location.y;
			_debris.emitterAngle=Math.PI - _mole.rotation;
			_debris.speed=400 * e.speedRatio;
			if (e.speedRatio == 0)
			{
				_debris.stop()
			}
		}

		/**
		 * Handler for when the CameraSprite has updated its position in response to a move command
		 * The Background and ItemManager need to wait for the background to move before updating themselves.
		 * 
		 * @param e CameraUpdateEvent
		 */
		private function updateBackground(e:CameraUpdateEvent):void
		{
			_background.show(e.viewport);
			
			var center:Point=rectCenter(e.viewport);
			_itemManager.show(center);

		}

	}
}