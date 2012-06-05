//------------------------------------------------------------------------------
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

package data
{
	/**
	 * Creates a data object for achievements to be displayed at level end.  AchievementItems are created in the Const class.
	 * @author Johnny Nguyen - Johnny [at] byxb [dot] com
	 */
	public class AchievementItem extends Object
	{
		private var _title:String;
		private var _description:String;
		private var _textureKey:String;
		private var _moleBonus:int;
		private var _humanBonus:int;
		private var _earned:Boolean;
		
		public function get title():String {return _title;}
		public function get description():String {return _description;}
		public function get textureKey():String {return _textureKey;}
		public function get moleBonus():int {return _moleBonus;}
		public function get humanBonus():int {return _humanBonus;}
		public function get earned():Boolean {return _earned;}
		
		/**
		 * Creates a data object for achievements to be displayed at level end.  AchievementItems are created in the Const class.
		 * 
		 * @param title Title of achievement.
		 * @param description Description of achievement.
		 * @param textureKey Texture key for achievement graphic.
		 * @param moleBonus
		 * @param humanBonus
		 * @param earned
		 */
		public function AchievementItem(title:String, description:String, textureKey:String, moleBonus:int, humanBonus:int, earned:Boolean)
		{
			_title=title;
			_description=description;
			_textureKey=textureKey;
			_moleBonus=moleBonus;
			_humanBonus=humanBonus;
			_earned=earned;
			
			super();
		}
	}
}