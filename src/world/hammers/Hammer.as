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

	import com.byxb.utils.*;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;

	/**
	 * The Hammer class shows an image of the hammer, runs an animation for hover, and another for doing the whack.
	 * The hammer class is meant to be abstract, but until there are upgrades, it will be a useable class.  All hammer 
	 * textures are framed to have the impact point of the hammer at the same point. No code has to be used to align different
	 * sized hammers.
	 * 
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class Hammer extends Image
	{
		/**
		 * A constant for easily positioning the hammer to to -45 degrees (ready to whack)
		 * @default  -Math.PI/4
		 */
		public static const DEG_NEG_45:Number=-0.78539816339744830961566084581988; // -Math.PI/4
		
		/**
		 * A constant for easily positioning the hammer to to -90 degrees (the hammer will be striaght up)
		 * @default -Math.PI/2
		 */
		public static const DEG_NEG_90:Number=1.5707963267948966192313216916398; // -Math.PI/2;

		/**
		 * A constant indicating a making the hover wiggle animation "fast." Any value can actually be used.
		 */
		public static const FAST_WIGGLE:Number=.1;
		
		/**
		 * A constant indicating a making the hover wiggle animation "moderate." Any value can actually be used.		  
		 */
		public static const MODERATE_WIGGLE:Number=.07;

		/**
		 * A constant for a small angle variance used in the hover animation
		 * @default Math.PI/64
		 */
		public static const SMALL_WIGGLE:Number=0.04908738521234051935097880286374; // Math.PI/64;
		
		/**
		 * A constant for a large angle variance used in the hover animation
		 * @default Math.PI/32
		 */
		public static const LARGE_WIGGLE:Number=0.02454369260617025967548940143187; // Math.PI/32;

		private const HOVER:String="hover";
		private const SWING:String="swing";

		private var _animating:Boolean=false;
		private var _animationType:String;
		private var _hoverBaseAngle:Number;
		private var _hoverWiggle:Number;
		private var _hoverSpeed:Number;
		private var _hoverCount:Number=0;

		private var _whackTween:Tween;

		/**
		 * Creates the Hammer.  
		 * @param textureID The string of the hammer to be found in the TextureAtlas
		 */
		public function Hammer(textureID:String)
		{
			super(Assets.getAtlas().getTexture(textureID));
			centerPivot(this); //centerPivot is from com.byxb.utils.  It is not a standard Starling operation.
			hover(DEG_NEG_45, MODERATE_WIGGLE, SMALL_WIGGLE);
			_whackTween=new Tween(this, .2, Transitions.EASE_OUT_BOUNCE);

		}

		/**
		 * Starts the hover (wiggle) animation.  
		 * @param baseAngle The angle that will be the center of the sway/wiggle
		 * @param speed The speed at which the hammer will sway/wiggle
		 * @param wiggle The angle Variance for the sway.
		 */
		public function hover(baseAngle:Number=DEG_NEG_45, speed:Number=FAST_WIGGLE, wiggle:Number=SMALL_WIGGLE):void
		{
			_hoverBaseAngle=baseAngle;
			_hoverSpeed=speed;
			_hoverWiggle=wiggle;
			if (!_animating)
			{
				_animationType=HOVER;
				_animating=true;
				addEventListener(Event.ENTER_FRAME, stepAnimation);
			}

		}

		/**
		 * Halts the hover animation if currently running.
		 */
		public function stopHover():void
		{
			if (_animating)
			{
				removeEventListener(Event.ENTER_FRAME, stepAnimation);
				_animationType="";
			}
		}

		/**
		 * Tween the hammer down to 0 degrees.
		 */
		public function whack():void
		{
			stopHover();
			_whackTween.animate("rotation", 0);

			Starling.juggler.add(_whackTween);
			_whackTween.onComplete=function():void
			{   
				// I'm not actually sure this is needed.  I think the juggler auto-removes completed tweens.  
				// It is safe regardless though since the mechanism for removing tweens from the juggler runs fine
				// even when the tween is not present.  I'll check into this later.
				Starling.juggler.remove(_whackTween); 
			};

		}

		/**
		 * Run the hover animation animation
		 * @param e EnterFrameEvent
		 */
		private function stepAnimation(e:EnterFrameEvent):void
		{
			switch (_animationType)
			{
				case HOVER:
					_hoverCount+=_hoverSpeed;
					this.rotation=_hoverBaseAngle + _hoverWiggle * Math.sin(_hoverCount);
					break;
			}
		}

	}
}
