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

package com.byxb.extensions.starling.display
{

	import com.byxb.extensions.starling.events.CameraUpdateEvent;
	import com.byxb.geom.InfiniteRectangle;
	import com.byxb.utils.*;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.animation.DelayedCall;
	import starling.animation.Juggler;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;

	[Event(name="cameraUpdate", type="com.byxb.extensions.starling.events.CameraUpdateEvent")]
	/**
	 * A display object rig to access pan, rotation and zoom actions.
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class CameraSprite extends Sprite
	{
		/**
		 * a pre-configured InfiniteRectangle to use for any item needing a bounding box with no bounds
		 * @default InfiniteRectangle(Number.NEGATIVE_INFINITY, Number.NEGATIVE_INFINITY, Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY)
		 */
		public static const NO_BOUNDS:InfiniteRectangle=new InfiniteRectangle(Number.NEGATIVE_INFINITY, Number.NEGATIVE_INFINITY, Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY);
		
		/**
		 * A value to use if the camera should track the targets without easing.
		 * @default 1
		 */
		public static const NO_EASING:Number=1;
		/**
		 * A value to use if the camera will not track the target settings at all.
		 * @default 0
		 */
		public static const NO_MOTION:Number=0;

		private var _startPosition:Point;

		private var _boundingRect:Rectangle;

		private var _easingPan:Number;
		private var _easingZoom:Number;
		private var _easingRotate:Number;

		private var _targetX:Number;
		private var _targetY:Number;
		private var _targetZoom:Number;
		private var _targetRot:Number;
		private var _lastRotation:Number=0;
		private var _shaker:DelayedCall;
		private var _juggler:Juggler=new Juggler();

		private var _shaking:Boolean=false;
		private var _moving:Boolean=false;

		private var _viewport:Rectangle;

		private var _harness:Harness;
		private var _world:World;

		/**
		 * The Point for with the location that the camera would return to if reset.
		 * @return Point for with the location that the camera would return to if reset. 
		 */
		public function get startPosition():Point  { return _startPosition; }
		public function set startPosition(value:Point):void  { value ? _startPosition=value : new Point(); }

		/**
		 * A Rectangle that constrains the movement of the camera
		 * @return  Rectangle of the bounding box
		 */
		public function get boundingRect():Rectangle  { return _boundingRect; }
		public function set boundingRect(value:Rectangle):void  { _boundingRect=value; }

		/**
		 * The value used to determine how much the camera should move each step towards 
		 * its target in X and Y.
		 * @return Number of the pan easing value
		 */
		public function get easingPan():Number  { return _easingPan; }
		public function set easingPan(value:Number):void  { _easingPan=clamp(value, 0, 1); }

		/**
		 * The value used to determine how much the camera should move each step towards 
		 * its target for scale.
		 * @return Number of the scale easing value
		 */
		public function get easingZoom():Number  { return _easingZoom; }
		public function set easingZoom(value:Number):void  { _easingZoom=clamp(value, 0, 1); }

		/**
		 * The value used to determine how much the camera should move each step towards 
		 * its target for rotation.
		 * @return Number of the rotation easing value
		 */
		public function get easingRotate():Number  { return _easingRotate; }
		public function set easingRotate(value:Number):void  { _easingRotate=clamp(value, 0, 1); }

		/**
		 * The current viewable area of the camera, taking into account position, rotation and scale
		 * @return Rectangle with the camera viewable area.
		 */
		public function get viewport():Rectangle  { return getWorldViewableArea()};

		/**
		 * A display object rig to access pan, rotation and zoom actions.
		 * @param viewport the starting viewable rectangle including position
		 * @param startPosition Point reprsenting the position that the camera will return to on reset
		 * @param easingPan The value used to determine how much the camera should move each step towards its target in X and Y.
		 * @param easingZoom The value used to determine how much the camera should move each step towards its target for scale.
		 * @param easingRotate The value used to determine how much the camera should move each step towards its target for rotation.
		 * @param boundingRect A Rectangle that constrains the movement of the camera
		 */
		public function CameraSprite(viewport:Rectangle, startPosition:Point=null, easingPan:Number=1, easingZoom:Number=1, easingRotate:Number=1, boundingRect:Rectangle=null):void
		{
			_harness=new Harness();  // The harness is a container to manage rotation, scale and shaking without modifying the pivot and other properties of the main camera.
			_world=new World(this);

			_viewport=viewport;

			this.startPosition=startPosition;

			_easingPan=easingPan;
			_easingZoom=easingZoom;
			_easingRotate=easingRotate;

			if (boundingRect)
			{
				this.boundingRect=boundingRect;
			}
			else
			{
				this.boundingRect=NO_BOUNDS;
			}
			
			_harness.center=new Point(_viewport.x + _viewport.width / 2, _viewport.y + _viewport.height / 2);
			super.addChildAt(_harness, 0);
			_harness.addChild(_world);
		}

		/**
		 * Reset the camera position, scale and rotation to their initial values
		 */
		public function reset():void
		{
			moveTo(_startPosition.x, _startPosition.y, 1, 0, true);
			stopShake();
		}

		/**
		 * Set the position, scale and rotation targets for the camera and begin animation.
		 * @param xPos X Pan target value
		 * @param yPos Y Pan target value
		 * @param zoom Scale target value
		 * @param rot Rotation rarget value
		 * @param force Boolean to force the values to be set without easing or animation
		 */
		public function moveTo(xPos:Number, yPos:Number, zoom:Number=1, rot:Number=0, force:Boolean=false):void
		{
			if (force || _easingPan != NO_MOTION)
			{
				_targetX=-clamp(xPos, _boundingRect.left, _boundingRect.right);
				_targetY=-clamp(yPos, _boundingRect.top, _boundingRect.bottom);
			}
			if (force || _easingZoom != NO_MOTION)
			{
				_targetZoom=clamp(zoom, 0, Number.POSITIVE_INFINITY);
			}
			if (force || _easingRotate != NO_MOTION)
			{
				_targetRot=rot;
			}

			if (force)
			{
				_world.x=_targetX;
				_world.y=_targetY;
				_harness.scaleX=_harness.scaleY=_targetZoom;
				_harness.setRotation(_targetRot);
			}
			else
			{
				startMoving();
			}
		}

		/**
		 * A convenience function so other methods can start the animation when needed without having to replicate the condition
		 */
		private function startMoving():void
		{
			if (!_moving)
			{
				_moving=true;
				addEventListener(Event.ENTER_FRAME, stepAnimation);
			}
		}

		/**
		 * Stop animation for moving to position, scale and rotation targets
		 */
		private function stopMoving():void
		{
			_moving=false;
			removeEventListener(Event.ENTER_FRAME, stepAnimation);
		}

		/**
		 * To be used as a handler for onEnterFrame.  Moves the camera towards its targets 
		 * @param e EnterFrameEvent
		 */
		private function stepAnimation(e:EnterFrameEvent):void
		{
			//clamp, ease, angleModulus and nearEquals are from com.byxb.utils.
			_world.x=clamp(ease(_world.x, _targetX, _easingPan), _boundingRect.left, _boundingRect.right);
			_world.y=clamp(ease(_world.y, _targetY, _easingPan), _boundingRect.top, _boundingRect.bottom);
			_harness.scaleX=_harness.scaleY=ease(_harness.scaleX, _targetZoom, _easingZoom);
			_targetRot=angleModulus(_targetRot, _harness.getRotation());
			_harness.setRotation(ease(_harness.getRotation(), _targetRot, _easingRotate));
			_juggler.advanceTime(e.passedTime);
			_harness.updateRotation();
			//if pretty close to all the targets, treat as having reached the targets
			if (!_shaking && nearEquals(_world.x, _targetX) && nearEquals(_world.y, _targetY) && nearEquals(_harness.scaleX, _targetZoom) && nearEquals(_harness.getRotation(), _targetRot))
			{
				stopMoving();
			}
			dispatchEvent(new CameraUpdateEvent(this.viewport));
		}

		/**
		 * Returns a bounding box representing the area that needs to be displayed based on scale, rotation and position.
		 * Rotation is not currently working.
		 * @return Rectangle of workd bounding box
		 */
		private function getWorldViewableArea():Rectangle
		{
//FIXME: Rectangle roation
			var worldView:Rectangle=new Rectangle(-_world.x + _harness.center.x - _harness.x, -_world.y + _harness.center.y - _harness.y, 0, 0);
			var inflate:Point=new Point((1 / _harness.scaleX * _viewport.width) / 2, (1 / _harness.scaleY * _viewport.height) / 2)
			worldView.inflatePoint(inflate);
			return worldView; 

		}

		/**
		 * Shakes the camera harness 
		 * @param intensity How much to shake the camera (max radius for randomization off center)
		 * @param pulses How make shake pulses to do before the shake effect stops.
		 */
		public function shake(intensity:Number=5, pulses:Number=5):void
		{
			if (pulses < 1)
			{
				return;
			}
			_shaker=new DelayedCall(doShake, Const.CAMERA_SHAKE_INTERVAL, [intensity]);
			_shaker.repeatCount=pulses + 1;
			_juggler.add(_shaker);
			_shaking=true;
			startMoving();
		}

		/**
		 * halts the shake action
		 */
		public function stopShake():void
		{
			_harness.x=_harness.center.x;
			_harness.y=_harness.center.y;
			_harness.rotation=_harness.getRotation();
			_juggler.remove(_shaker);
			_shaking=false;
		}

		/**
		 * runs each pulse
		 * @param intensity
		 */
		private function doShake(intensity:Number):void
		{

			var pt:Point=Point.polar(Math.random() * intensity, Math.random() * 2 * Math.PI);
			_harness.x=Math.floor(_harness.center.x + pt.x);
			_harness.y=Math.floor(_harness.center.y + pt.y);
			_harness.rotation=_harness.getRotation() + (Math.random() * 2 - 1) * intensity * .005;
			if (_shaker.repeatCount == 1)
			{
				stopShake();
			}
		}

		public override function dispose():void
		{
			if (_moving)
			{
				removeEventListener(Event.ENTER_FRAME, stepAnimation);
			}
			super.dispose();
		}
		// The overrides are here to block access to the harness from the outside, even from the children.
		public override function addChild(child:DisplayObject):void
		{
			_world.addChild(child);
		}

		public override function addChildAt(child:DisplayObject, index:int):void
		{
			_world.addChildAt(child, index);
		}

		public override function removeChild(child:DisplayObject, dispose:Boolean=false):void
		{
			_world.removeChild(child, dispose);
		}

		public override function removeChildAt(index:int, dispose:Boolean=false):void
		{
			_world.removeChildAt(index, dispose);
		}

		public override function removeChildren(beginIndex:int=0, endIndex:int=-1, dispose:Boolean=false):void
		{
			_world.removeChildren(beginIndex, endIndex, dispose);
		}

		public override function get numChildren():int
		{
			return _world.numChildren;
		}

	}
}
import flash.geom.Point;

import starling.animation.DelayedCall;
import starling.animation.Juggler;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Event;

/**
 * Camera harness that handles the pivot for rotation, shaking and zooming.
 * @author Justin Church  - Justin [at] byxb [dot] com 
 * 
 */
class Harness extends Sprite
{

	private var _center:Point;

	private var _rotation:Number=0;

	/**
	 * the actual center.  This is needed for resetting after shaking.
	 * @return center Point
	 */
	public function get center():Point  { return _center; }
	public function set center(pt:Point):void  { _center=pt; x=pt.x; y=pt.y; }

	public function Harness()
	{

	}

	/**
	 * Set the cannonical rotation.  Actual rotation will be affected by shaking.
	 * @param rotation
	 */
	public function setRotation(rotation:Number):void
	{
		_rotation=rotation;
	}

	/**
	 * get the cannonical rotaiton. Actual rotation will be affected by shaking.
	 * @return 
	 */
	public function getRotation():Number
	{
		return _rotation;
	}

	/**
	 * set the actual rotation to the cannonical rotation
	 */
	public function updateRotation():void
	{
		this.rotation=_rotation
	}

}

import starling.display.Sprite;
import starling.display.DisplayObjectContainer;
import com.byxb.extensions.starling.display.CameraSprite;

/**
 * This is the content container that holds the background elements.  Panning of the camera is performed on the world.
 * @author Justin Church  - Justin [at] byxb [dot] com 
 * 
 */
class World extends Sprite
{

	public function World(camera:CameraSprite)
	{

	}

}
