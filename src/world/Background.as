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

package world
{

	import com.byxb.extensions.starling.display.ParallaxSprite;
	import com.byxb.geom.InfiniteRectangle;
	import com.byxb.geom.Tiling;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class Background extends ParallaxSprite
	{

		/**
		 * Background creates the game-specific parallax background for the Whack game with several ground plains, mountains, clouds and the sky.
		 */
		public function Background()
		{
			super(new Rectangle(0, -225, 800, 450), 1, .2);
			addStretchable(Assets.getAtlas().getTexture("bg/stretchSky"), 0, new InfiniteRectangle(Number.NEGATIVE_INFINITY, Number.NEGATIVE_INFINITY, Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY));
			addStretchable(Assets.getAtlas().getTexture("bg/sky"), 0, new InfiniteRectangle(Number.NEGATIVE_INFINITY, -500, Number.POSITIVE_INFINITY, 518));
			
			//the InfiniteRectangle class lets me create a rectangle using values like Number.POISTIVE_INFINITY without causing values of NaN for width.
			var boundR:InfiniteRectangle=InfiniteRectangle.FULL_RECT;
			
			//The various boundR y values are set based off coordinates from Photoshop for how the layers stack together.
			boundR.y=-134;
			addTileable(Assets.getAtlas().getTextures("bg/ground4"), .1, boundR.clone(), null, Tiling.TILE_X);

			boundR.y=-272;
			addTileable(Assets.getAtlas().getTextures("bg/cloud1"), .15, boundR.clone(), null, Tiling.TILE_X);

			boundR.y=-182;
			addTileable(Assets.getAtlas().getTextures("bg/cloud2"), .15, boundR.clone(), null, Tiling.TILE_X);

			boundR.y=-159;
			addTileable(Assets.getAtlas().getTextures("bg/cloud3"), .15, boundR.clone(), null, Tiling.TILE_X);

			boundR.y=-177;
			addTileable(Assets.getAtlas().getTextures("bg/cloud4"), .15, boundR.clone(), null, Tiling.TILE_X);

			boundR.y=-288;
			addTileable(Assets.getAtlas().getTextures("bg/cloud5"), .18, boundR.clone(), null, Tiling.TILE_X);

			boundR.y=-54;
			addTileable(Assets.getAtlas().getTextures("bg/ground5"), .2, boundR.clone(), null, Tiling.TILE_X);

			boundR.y=-206;
			addTileable(Assets.getAtlas().getTextures("bg/Mountain1"), .2, boundR.clone(), null, Tiling.TILE_X);

			boundR.y=-206;
			addTileable(Assets.getAtlas().getTextures("bg/Mountain2"), .2, boundR.clone(), null, Tiling.TILE_X);

			addStretchable(Assets.getAtlas().getTexture("bg/stretchMountain"), .2, new InfiniteRectangle(Number.NEGATIVE_INFINITY, -40, Number.POSITIVE_INFINITY, 100));

			boundR.y=-90;
			addTileable(Assets.getAtlas().getTextures("bg/ground3"), .5, boundR.clone(), null, Tiling.TILE_X);

			addStretchable(Assets.getAtlas().getTexture("bg/stretchGround3"), .5, new InfiniteRectangle(Number.NEGATIVE_INFINITY, -10, Number.POSITIVE_INFINITY, 100));

			boundR.y=-92;
			addTileable(Assets.getAtlas().getTextures("bg/ground2"), .8, boundR.clone(), null, Tiling.TILE_X);

			addStretchable(Assets.getAtlas().getTexture("bg/stretchGround2"), .8, new InfiniteRectangle(Number.NEGATIVE_INFINITY, -15, Number.POSITIVE_INFINITY, 100));

			addScrollable(Assets.getTexture("ground"), 1, new InfiniteRectangle(Number.NEGATIVE_INFINITY, 30, Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY), new Point(0, -30), Tiling.TILE_X | Tiling.TILE_Y);

			boundR.y=-57
			addTileable(Assets.getAtlas().getTextures("bg/ground1"), 1, boundR.clone(), null, Tiling.TILE_X);
		}
	}
}
