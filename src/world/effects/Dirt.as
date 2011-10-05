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

package world.effects
{

	import com.byxb.extensions.starling.extensions.ParticleDesignerPS2;
	
	import starling.core.Starling;
	import starling.events.Event;

	/**
	 * Creates a dirt particle system to be used when the mole is digging.
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class Dirt extends ParticleDesignerPS2
	{
		/**
		 * Creates a dirt particle system to be used when the mole is digging.
		 * @param autoStart Whether or not the particles should start being produced when the Dirt instance is added to the stage.
		 */
		public function Dirt(autoStart:Boolean=true)
		{
			super(XML(new Assets.DirtParticleDesign()), Assets.getAtlas().getTexture("tunnel/pebble1"));
			if (autoStart)
			{
				addEventListener(Event.ADDED_TO_STAGE, onStage)
			}
		}

		/**
		 * Handles when Dirt has been added to stage.  Dirt instance only listens for this event if autoStart was set to true in the constructor.
		 * @param e
		 */
		private function onStage(e:Event):void
		{
			start();
		}

		public override function start(duration:Number=Number.MAX_VALUE):void
		{
			Starling.juggler.add(this);
			super.start(duration);

		}

		public override function dispose():void
		{
			Starling.juggler.remove(this);
		}

	}
}
