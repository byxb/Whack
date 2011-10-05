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

	import com.adobe.viewsource.ViewSource;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;

	[SWF(width="800", height="450", frameRate="60", backgroundColor="#333333")]
	/**
	 * The main application.
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class Whack extends Sprite
	{

		private var _starling:Starling;
		private var _menus:Screens;

		/**
		 * The main application
		 */
		public function Whack()
		{
			ViewSource.addMenuItem(this, "srcview/index.html"); 
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			
			_menus=new Screens(); // Screens is in a SWC (don't worry about looking for the class files)
			_menus.addEventListener("newGame", startGame);

			var stats:Stats=new Stats();
			stats.x=730;
			
			addChild(_menus);
			addChild(stats);
			addChild(new NativeStageProxy());
		}

		/**
		 * The Screens object dispatches a "newGame" event that is used to start Starling
		 * @param e
		 */
		public function startGame(e:Event=null):void
		{
			Starling.multitouchEnabled=true;

			_starling=new Starling(Game, stage);
			_starling.simulateMultitouch=false;
			_starling.enableErrorChecking=false;
			_starling.start();

		}

	}
}