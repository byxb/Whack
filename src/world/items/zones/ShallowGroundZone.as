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


package world.items.zones
{

	import world.items.items.*;

	/**
	 * A zone for items just below the surface
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class ShallowGroundZone extends ItemZone
	{
		/**
		 * Creates a zone with low-value below ground items.
		 */
		public function ShallowGroundZone()
		{
			super();
			_top=0
			_density=.05;
			addItemChance(Dynamite, .1);
			addItemChance(Gold1, .2);
			addItemChance(Gem1_1, 1);
			addItemChance(Gem1_2, 1);
			addItemChance(Gem1_3, 1);
			addItemChance(Gem1_4, 1, true);
		}

	}
}
