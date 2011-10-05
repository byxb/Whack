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

package world.hammers
{

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.*;
	
	import world.effects.Pow;
	import world.events.HammerWhackEvent;

	[Event(name="hammerWhack", type="world.events.HammerWhackEvent")]
	/**
	 * The First Swing Class is used to hold the current hammer, detect a touch event to start the whack process, 
	 * indicate the current potential direction, and launch the Pow animation
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class FirstSwing extends Sprite
	{
		private var _hammer:Hammer;
		private var _intensity:Number=1;
		private var _angle:Number;
		private var _nativeStage:Stage;
		private var _hammerHarness:Sprite;
		private var _direction:Vector3D;
		private var _indicators:Vector.<Image>=new <Image>[];
		private var _fullScreenButton:FullScreenButton;

		/**
		 * The First Swing Class is used to hold the current hammer, detect a touch event to start the whack process, 
		 * indicate the current potential direction, and launch the Pow animation
		 */
		public function FirstSwing()
		{
			super();
			//I n order to position the hammer and show the preview arc, I need to have access to the mouse position.
			// Since starling is oriented for touch, there is no mouse data except when the actual touch is made.
			// to work around this, I'm using a hacky singleton that was instantiated out on the stage before starling to
			// give me a lifeline back to the real stage.
			_nativeStage=NativeStageProxy.nativeStage;
			_nativeStage.addEventListener(MouseEvent.MOUSE_MOVE, redrawPreviewPath);
			
			_hammerHarness=new Sprite(); //The hammer harness is used for rotating the hammer around the mole in response to the mouse.
			
			_hammer=new Hammer("hammer/hammer1"); // the hammer controls its hover animation and the actual whack animation.
			_hammer.x=-100;
			
			// I'm adding a button to the stage (the texture is irrelevant.  Its immediately made invisible
			// and it has a custom touch handler that always returns true for touch no matter where it is positioned
			// or the size of the texture used.
			_fullScreenButton=new FullScreenButton(Assets.getAtlas().getTexture("fonts/font_default_62"));
			_fullScreenButton.visible=false;
			_fullScreenButton.addEventListener(TouchEvent.TOUCH, whackMole);


			//create a set of indicator Images to show the current potential trajectory.
			for (var i:uint=0; i < 50; i++)
			{
				_indicators.push(new Image(Assets.getAtlas().getTexture("fonts/font_default_62")));
			}
			
			_hammerHarness.addChild(_hammer);
			addChild(_hammerHarness);
			addChild(_fullScreenButton);
		}

		/**
		 * A reset capability for doing a reset on a level without newng up a whole new World.  Currently in development and not used.
		 */
		public function reset():void
		{
			_intensity=1;
			_nativeStage.addEventListener(MouseEvent.MOUSE_MOVE, redrawPreviewPath);
		}

		/**
		 * When FirstSwing is instantiated, any click will cause the hammer to whack the mole.
		 * @param e A TouchEvent for the click.
		 */
		private function whackMole(e:TouchEvent):void
		{
			if (e.getTouch(this, TouchPhase.ENDED))
			{
				_hammer.whack();
				addChild(new Pow());
				dispatchEvent(new HammerWhackEvent(_direction));
				for (var i:uint=0; i < Const.HAMMER_WHACK_PREVIEW_SEGMENTS; i++)
				{
					_indicators[i].removeFromParent(true); 
					//TODO: When the level reset is made more granular, these either shouldn't be disposed, 
					// or there should be a mechanism for recreating them.
				}
				_nativeStage.removeEventListener(MouseEvent.MOUSE_MOVE, redrawPreviewPath);
				_fullScreenButton.removeEventListener(TouchEvent.TOUCH, whackMole);
			}

		}

		/**
		 * While the whack has not yet happened, The hammer should be repositioned according to the mouse position. The preview path 
		 * should be redrawn according to the current hammer position and the intensity from the mole bobbing.
		 * 
		 * @param e 
		 */
		private function redrawPreviewPath(e:Event=null):void
		{

			// get the mouse position from the NativeStageProxy adjusted for transformations.
			var mouse:Point=this.globalToLocal(new Point(_nativeStage.mouseX, _nativeStage.mouseY));

			// Only about 90 degrees of the area around the mole provides a valid trajectory.  The following if statements force the 
			// position of the hammer to the closest valid angle.  One quadrant is also flipped so a player can control the hammer from
			// above and to the left of the mole, or below and to the right of the mole.
			var a:Number=Math.atan2(mouse.y, mouse.x);
			var da:Number=(a * 180 / Math.PI) // convert to degrees.  It makes the following conditions easier to read.
			
			if (da > 135 || da < -45)
			{
				a+=Math.PI;
			}
			if (da > 85 && da < 135)
			{
				a=Math.PI * 85 / 180;
			}
			else if (da > 135)
			{
				a=Math.PI * 5 / 180;
			}
			else if (da < 5 && da > -45)
			{
				a=Math.PI * 5 / 180;
			}
			else if (da < -45 && da > -95)
			{
				a=Math.PI * 85 / 180;
			}
			//adjust the hammer harness rotation
			_angle=a;
			_hammerHarness.rotation=_angle - Math.PI / 2;
			
			// start computing the preview arc.
			var direction:Point=Point.polar(_intensity * 20, _angle);
			_direction=new Vector3D(direction.x, direction.y);

			var pt:Point=new Point();
			var lastPt:Point;
			var pX:Number=0;
			var pY:Number=0;

			for (var i:uint=0; i < Const.HAMMER_WHACK_PREVIEW_SEGMENTS; i++)
			{
				// I'm using the same Math as in the Mole class.  This really should be put into a static method (probably of Mole) so the 
				// motion algorithm can be shared by both rather than duplicated
				lastPt=pt;
				pt=pt.add(direction);

				var diff:Point=pt.subtract(lastPt);
				lastPt=pt;
				pt=pt.add(direction);

				diff=pt.subtract(lastPt);
				direction.y-=Const.GRAVITY;
				var atan:Number=Math.atan2(diff.y, diff.x);
				var ind:Image=_indicators[i];
				ind.rotation=atan;
				ind.x=pt.x;
				ind.y=pt.y;
				direction.y-=Const.GRAVITY;
				addChild(ind);
			}
		}

		/**
		 * When the MoleBobEvent is handled by the World instance, the World instance will call this method to provide the information to the hammer.
		 * @param intensity A Number representing how effective a whack would be in this moment based on the up and down bobbing of the Mole.
		 */
		public function setIntensity(intensity:Number):void
		{
			_intensity=intensity;
			redrawPreviewPath();
		}
	}
}
