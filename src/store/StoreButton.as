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

package store
{
	import com.byxb.utils.centerPivot;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * The StoreButton creates the view for each upgrade item.
	 * @author Johnny Nguyen - Johnny [at] byxb [dot] com 
	 */
	public class StoreButton extends Button
	{
		private var _upgradeItem:UpgradeItem;
		public function get upgradeItem():UpgradeItem {return _upgradeItem;}
		public function set upgradeItem(value:UpgradeItem):void {_upgradeItem = value;}
		
		/**
		 * Creates a new StoreButton
		 * @param upgradeItem The data object for the StoreButton  
		 */
		public function StoreButton(upgradeItem:UpgradeItem)
		{
			_upgradeItem = upgradeItem;
			super(Assets.getAtlas().getTexture(upgradeItem.iconSm));
			centerPivot(this);
		}
	}
}