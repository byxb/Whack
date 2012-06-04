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

package world.items.items
{

	import flash.geom.Point;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 * An abstract class for items used by the item manager. (collectible items)
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class Item extends Image
	{
		protected var _moleBonus:int=0;
		protected var _humanBonus:int=0;

		/**
		 * The score value that is gained by collecting the item
		 * @default 
		 */
		public const SCORE_VALUE:uint=50;
			
		public function get moleBonus():int {return _moleBonus;}
		
		public function get humanBonus():int {return _humanBonus;}
		
		/**
		 * Creates a new Item.  This should not be instantiated directly.
		 * @param texture
		 */
		public function Item(texture:Texture)
		{
			super(texture);
			this.pivotX=this.width / 2;
			this.pivotY=this.height / 2;
		}

		/**
		 * When a collision with this item is detected, the ItemManager will call the hit method on the item.
		 * @param pt
		 */
		public function hit(pt:Point):void
		{
			// Animate the item towards the mole.  This will be overriden in items like Dynamite which 
			// need to take additional actions.
			var t:Tween=new Tween(this, .2, Transitions.EASE_OUT);
			t.fadeTo(0);
			t.scaleTo(.01);
			t.moveTo(pt.x, pt.y)
			Starling.juggler.add(t);
			t.onComplete=endTween;

		}

		/**
		 * Remove and dispose of the item when its tween is done.
		 */
		private function endTween():void
		{
			this.removeFromParent(true);
		}
	}
}
