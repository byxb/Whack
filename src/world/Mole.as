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

	import com.byxb.utils.*;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import starling.animation.Juggler;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	import ui.HUD;
	
	import world.events.MoleBobEvent;
	import world.events.MoleMoveEvent;
	import world.events.MoleStopEvent;
	import world.events.MoleSurfaceEvent;
	import world.events.MoleWhackEvent;

	[Event(name="moleSurface", type="world.events.MoleSurfaceEvent")]
	[Event(name="moleWhack", type="world.events.MoleWhackEvent")]
	[Event(name="moleMove", type="world.events.MoleMoveEvent")]
	[Event(name="moleBob", type="world.events.MoleBobEvent")]
	/**
	 * The mole character for the Whack game.
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class Mole extends Sprite
	{
		private const STATE_BOBBING:uint=1;
		private const STATE_DIGGING:uint=2;
		private const STATE_RISING:uint=3;
		private const STATE_FALLING:uint=4;
		private const STATE_END:uint=5;
		private var _state:uint=0;
		private var _transitioning:Boolean=false;
		private var _transitioningTo:uint;
		private var _costumes:Object;
		private var _mole:MovieClip;
		private var _juggler:Juggler=new Juggler();
		private var _velocity:Vector3D;
		private var _speed:Number=0;
		private var _groundHeightOffsets:GroundHeightOffsets=GroundHeightOffsets.instance;
		private var _bobTime:Number=0;

		/**
		 * The current speed as a Number of the mole
		 * @return Number representing the speed (without direction) of the mole
		 */
		public function get speed():Number { return _speed;}

		/**
		 * The ratio of the moles current speed to its maximum speed
		 * @return A Number representing the ratio of the moles current speed to its maximum speed
		 */
		public function get speedRatio():Number  { return clamp(_speed / Const.MOLE_FAST_SPEED, 0, 1)}

		/**
		 * The mole character for the Whack game.
		 */
		public function Mole()
		{
			super();
			addEventListener(Event.ENTER_FRAME, runJuggler);
			//get all of the mole costume names based on an Vector.<String> of the pattern name for each costume.
			Const.MOLE_COSTUME_NAME.forEach(function(item:String, index:uint, vec:Vector.<String>):void
			{
				addCostume(item, Assets.getAtlas().getTextures(item));
			}, this);
			//start the mole bobbing up and down
			switchState(STATE_BOBBING);
		}

		/**
		 * A level reset function for more granular reset than newing up a new World.  In development, not currently implemented
		 */
		public function reset():void
		{
			switchState(STATE_BOBBING);
		}

		/**
		 * Starts the mole moving in the direction of a whack.  This is called by the World instance in response to a HammerWhackEvent
		 * @param direction A Vector3D of the directon and velocity to start moving the mole
		 */
		public function whack(direction:Vector3D):void
		{
			_velocity=direction;
			dispatchEvent(new MoleWhackEvent(_velocity));
			switchState(STATE_DIGGING);
		}

		/**
		 * Manages the various potential states of the mole.  Changes its costume and registers event handles as needed 
		 * @param state
		 */
		private function switchState(state:uint):void
		{
			//before changing states, see if there is anything that needs to be stopped/cleaned up from the last state
			cleanupLeaveState(_state);
			switch (state)
			{
				case STATE_BOBBING:
					switchCostume("bobbing");
					_mole.loop=true;
					startBobbing();
					break;
				
				case STATE_DIGGING:
					switchCostume("digging");
					_mole.loop=true;
					break;

				case STATE_RISING:
					dispatchEvent(new MoleSurfaceEvent(true, _velocity));
					switchCostume("cannonball");
					_mole.loop=false;
					_mole.currentFrame=1;
					_mole.play();
					break;

				case STATE_FALLING:
					switchCostume("intoDive");
					_mole.loop=false;
					_mole.currentFrame=1;
					_mole.play();
					break;

				case STATE_FALLING:
					switchCostume("intoDive");
					_mole.loop=false;
					_mole.currentFrame=1;
					_mole.play();
					break;
				
				case STATE_END:
					switchCostume("surfacing");
					removeEventListener(Event.ENTER_FRAME, moveMole);
					rotation=0;
					y=_groundHeightOffsets.getHeightOffset(x);
					_mole.loop=false;
					_mole.currentFrame=1;
					_mole.play();
					_juggler.delayCall(function():void
					{
						//HUD.instance.levelEnd();  //create custom event here for the world to catch, e.g. "moleStop". 
						dispatchEvent(new MoleStopEvent());
					}, .5)
					break;
				
			}
			//now set the official state
			_state=state;
		}

		/**
		 * Cleanup or unset elements when leaving a state
		 * @param state the state that is being left
		 */
		private function cleanupLeaveState(state:uint):void
		{

			switch (state)
			{
				case STATE_BOBBING:
					addEventListener(Event.ENTER_FRAME, moveMole);
					break;
				
				case STATE_FALLING:
					dispatchEvent(new MoleSurfaceEvent(false, _velocity));
					break;
			}

		}

		/**
		 * Turn a Vector.<Texture> into a MovieClip and store in an object.
		 * @param name the full Texture/SubTexture name
		 * @param textures Vector.<Texture> of Textures for frame animations
		 */
		private function addCostume(name:String, textures:Vector.<Texture>):void
		{
			//trim off the sprite folder information
			name=name.split("/")[1];
			
			_costumes||=new Object();
			_costumes[name]=new MovieClip(textures, Const.MOLE_FPS);
			var costume:MovieClip=_costumes[name] as MovieClip;
			costume.name=name;
			trace( costume.smoothing);
			costume.smoothing = TextureSmoothing.TRILINEAR;
			centerPivot(costume);
		}

		/**
		 * Change to a new costume based on the a string key
		 * @param name the string key that indicates the name of the MovieClip in the Object
		 * @return A MovieClip of the selected costume
		 */
		private function switchCostume(name:String):MovieClip
		{
			//stop the current costume from animating 
			_juggler.remove(_mole);
			removeChild(_mole);
			
			_mole=_costumes[name]
			addChild(_mole);
			//start the new costume animating
			_juggler.add(_mole);
			return _mole;
		}

		/**
		 * Initialize the bob animation and get it to synchronize with the bobbing timer in runJuggler
		 */
		private function startBobbing():void
		{
			_bobTime=0;
			_mole.currentFrame=1;
			x=0;
			rotation=0;
			y=_groundHeightOffsets.getHeightOffset(x);
			rotation=0;
			_mole.fps=Const.MOLE_BOB_FPS;
			_mole.setFrameDuration(13, .25); // stay at the top of the cycle longer than the other frames
		}

		/**
		 * If the mole is not bobbing or ended, it is moving.  Process the frame step movement
		 * @param e EnterFrameEvent
		 */
		private function moveMole(e:EnterFrameEvent):void
		{
			//update the position
			x+=_velocity.x;
			y+=_velocity.y;

			//determine speed
			_speed=_velocity.length;
			
			//find the surface height based on the mole position (the ground is not flat)
			var groundY:Number=_groundHeightOffsets.getHeightOffset(x);
			var aboveGround:Boolean=y < groundY;

			if (aboveGround) // gravity should act to bring the mole down
			{
				_velocity.y+=Const.GRAVITY;
				if (_state == STATE_DIGGING)
				{
					switchState(STATE_RISING);
				}
				else if (_state == STATE_RISING && _velocity.y > 0)
				{
					switchState(STATE_FALLING);
				}
			}
			else  // some other impulse is bringing the mole back towards the surface when underground
			{
				if (_state == STATE_FALLING && _velocity.y > 6)
				{
					switchState(STATE_DIGGING);
					_velocity.y*=.8;
				}
				else if (_state == STATE_FALLING && _velocity.y < 6)
				{
					switchState(STATE_END);
					dispatchEvent(new MoleMoveEvent(new Point(x, y), new Vector3D(), 0));
					return;
				}
				else
				{
					_velocity.y-=Const.GRAVITY;
					_mole.fps=Math.round(clamp(speedRatio, Const.MOLE_SLOW_SPEED / Const.MOLE_FAST_SPEED, 1) * Const.MOLE_MAX_FPS);
				}

			}
			dispatchEvent(new MoleMoveEvent(new Point(x, y), _velocity, speedRatio));
			rotation=Math.atan2(_velocity.y, _velocity.x);
		}

		/**
		 * If bobbing, update the intensity value and dispatch an event.
		 * @param e
		 */
		private function runJuggler(e:EnterFrameEvent):void
		{
			_juggler.advanceTime(e.passedTime);
			if (_state == STATE_BOBBING)
			{
				//I wish starling MovieClips made currentTime either public or protected. This would have been way easier.
				_bobTime+=e.passedTime;
				_bobTime%=_mole.totalTime;
				dispatchEvent(new MoleBobEvent((2 - Math.cos(Math.PI * 2 * (_bobTime / _mole.totalTime))) / 2));
			}
		}

		public override function dispose():void
		{
			this.removeEventListeners()
			_juggler.purge();
			super.dispose();
		}
	}
}
