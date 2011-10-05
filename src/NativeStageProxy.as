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

	import flash.display.Sprite;
	import flash.display.Stage;

	/**
	 * This is a super hacky singleton to give me access to a normal flash display object.
	 * This is used because Starling is designed for tocuh and does not have mouse properties.
	 * 
	 * @author Justin Church  - Justin [at] byxb [dot] com
	 *
	 */
	public class NativeStageProxy extends Sprite
	{
		private static var _instance:NativeStageProxy;

		/**
		 * Gets the native stage instance.
		 * @return the stage (flash native)
		 * @throws Error
		 */
		public static function get nativeStage():Stage
		{
			if (!_instance || !_instance.stage)
			{
				throw new Error("NativeStageProxy not yet instantiated or added to stage.")
			}

			return _instance.stage;

		}

		/**
		 * Creates an instance of NativeStage
		 * @throws Error Can only be instantiated once.
		 */
		public function NativeStageProxy()
		{
			if (_instance)
			{
				throw new Error("There can only be one NativeStageProxy")
			}
			_instance=this;
		}
	}
}
