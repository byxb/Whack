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

	import world.items.items.Item;

	/**
	 * An abstract class for item zones.  A zone is vertical area of the world divided into a grid.  
	 * When an item is requested for a grid in a zone.  The zone checks its density to return an item, or nothing.
	 * If an item is returned, all registered for the sone are given a probability. The specific item is chosen
	 * and instantiated based on this probablity. Zones extend infinitely in the horizontal direction.
	 *  
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class ItemZone
	{

		/**
		 * A Number representing the probability that any individual grid cell will have an item in it.  A value of 1 would put an item in every 
		 * grid cell, 0 would leave all grid cells empty
		 * @default 
		 */
		protected var _density:Number;
		
		/**
		 * The top-most grid cell managed by this zone.  Not bottom is deifned. The bottom is either infinite or is the top of the next zone down.
		 * @default 0 (ground level)
		 */
		protected var _top:int=0
		
		private var _items:Vector.<Class>;
		private var _chances:Vector.<Number>;

		/**
		 * The top-most grid cell managed by this zone.  Not bottom is deifned. The bottom is either infinite or is the top of the next zone down.
		 * @return An int of the top-most grid cell for this zone.
		 */
		public function get top():int  { return _top }

		/**
		 * Creates a zone which is a vertical area of the world divided into a grid. 
		 */
		public function ItemZone()
		{

		}

		/**
		 * Creates a new item or returns null based on the density and the item probabilities.
		 * @return an Item or null if no item should be in this zone.
		 */
		public function createItem():Item
		{
			var item:Item;
			if (Math.random() < _density)
			{
				var spinner:Number=Math.random();
				var tot:Number=0;
				for (var i:uint=0; i < _chances.length; i++)
				{
					if (spinner < _chances[i] + tot)
					{
						item=new _items[i];
						break;
					}
					tot+=_chances[i]
				}
			}
			return item;

		}

		/**
		 * Register a new item with the zone.
		 * @param itemType a Class (not an instance) used for instantiating new Items of that type
		 * @param chance the probability that this item will be created if an item is needed.  Total item probabilities should total 1.
		 * @param balance  If you want to use relative values between item types, you can tell the zone to rebalance all values to make the total be one.  Normally you would only use this parameter once.
		 */
		protected function addItemChance(itemType:Class, chance:Number=0, balance:Boolean=false):void
		{
			_items||=new Vector.<Class>();
			_chances||=new Vector.<Number>();
			_items.push(itemType);
			_chances.push(chance);
			if (balance)
			{
				var tot:Number=0;
				for (var i:uint=0; i < _chances.length; i++)
				{
					tot+=_chances[i];
				}
				for (i=0; i < _chances.length; i++)
				{
					_chances[i]*=1 / tot;
				}

			}
		}
	}
}
