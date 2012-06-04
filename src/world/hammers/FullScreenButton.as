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

	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.textures.Texture;

	/**
	 * This button always returns true for having been clicked regardless of its position, size, or visibility.
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class FullScreenButton extends Button
	{
		/**
		 * This button always returns true for having been clicked regardless of its position, size, or visibility.
		 * @param upState This texture is not really important
		 * @param text The text should normally be left blank.
		 * @param downState
		 */
		public function FullScreenButton(upState:Texture, text:String="", downState:Texture=null)
		{
			super(upState, text, downState);

		}

		public override function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			// if the hitTest is looking for whether or not a touch has occurred, it will always respond 
			// by returning itself (which means a touch occurred.
			if (forTouch)
			{
				return this;
			}
			return super.hitTest(localPoint, forTouch);
		}
	}
}
