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

	import com.byxb.extensions.starling.display.DrawImage;
	import com.byxb.geom.RibbonMesh;
	import com.byxb.utils.*;
	
	import de.polygonal.core.ObjectPool;
	
	import flash.geom.Point;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	/**
	 * A Tunnel that shows where the mole has been.
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class Tunnel extends Sprite
	{
		private var _tunnelTexture:Texture=Assets.getAtlas().getTexture("tunnel/tunnel");
		private var _halfTunnelheight:Number=_tunnelTexture.height / 2;
		private var _tunnelBackground:DrawImage;
		private var _backgroundMesh:RibbonMesh;
		private var _previousDig:Point;
		private var _tunnelBuffer:Number=0;
		private var _groundHeightOffsets:GroundHeightOffsets=GroundHeightOffsets.instance;
		private var _belowGround:Boolean=false;
		private var _molehillPool:ObjectPool;
		private var _moleHills:Vector.<MovieClip>=new <MovieClip>[];


		/**
		 * 
		 * @param boundingRect
		 */
		public function Tunnel()
		{
			// This texture should repeat (meaning that a U of 1.5 is the same as a U of .5.  The Tunnel Class 
			// expects the texture to tile in U.  Tiling in V is not needed.
			_tunnelTexture.repeat=true;
			// The RibbonMesh creates a grid or triangles to that can be added onto at one end. 
			// This will manage the geometry of the tunnel triangles 
			_backgroundMesh=new RibbonMesh(Const.TUNNEL_LENGTH_SEGMENTS, Const.TUNNEL_CROSS_SEGMENTS);
			// The DrawImage is an extension of Image that lets you draw triangles for custom shapes
			_tunnelBackground=new DrawImage(_tunnelTexture);
			this.addChild(_tunnelBackground);
			
			//Using a pool for recycling molehill MovieClips.
			_molehillPool=new ObjectPool(true);
			_molehillPool.setFactory(new MolehillFactory(Assets.getAtlas().getTextures("tunnel/molehill")));
			_molehillPool.allocate(1); //start with just one molehill
		}

		/**
		 * Create the tunnel background to the point where the mole is.  The tunnel will not be visible until 
		 * there are at least two points to work with
		 * @param p the new Point where the mole is
		 * @param speedRatio The ratio of how fast the mole is moving compared to its maximum speed
		 */
		public function digToPoint(p:Point, speedRatio:Number):void
		{
			//if we have at least 2 points
			if (_previousDig)
			{
				//Calculate the difference between the old point and the new one.
				var diff:Point=p.subtract(_previousDig);
				
				//The tunnel buffer keeps track of the distance.  If the value is under a threshhold, 
				// a new tunnel segment will not be created, but the value will persist until the next move 
				// when it may be pushed past the threshold.
				_tunnelBuffer+=diff.length;
				
				var atan:Number=Math.atan2(diff.y, diff.x);
				var i:uint=0;

				while (_tunnelBuffer > Const.TUNNEL_PIXEL_BUFFER)
				{
					//there is enough distance in the buffer to merit at least one new tunnel segment.
					i++;

					diff.normalize(Const.TUNNEL_PIXEL_BUFFER);
					_previousDig=_previousDig.add(diff);
					_tunnelBuffer-=Const.TUNNEL_PIXEL_BUFFER;
					
					// calculate the edges of the tunnel from the dig point which is in the center of the tunnel
					var normal:Point=Point.polar(_halfTunnelheight, atan + Math.PI / 2);
					var reverseNormal:Point=new Point(-normal.x, -normal.y);
					var left:Point=reverseNormal.add(_previousDig);
					var right:Point=normal.add(_previousDig);
				
					//figure out if the edges are on the same side of the surface as last time.
					var lastBelow:Boolean=_belowGround;
					_belowGround=fitBounds(left) || fitBounds(right);
					
					//if not, a molehill animation is needed.
					var moleHill:MovieClip;
					if (_belowGround && !lastBelow)
					{
						_backgroundMesh.addSlice(left, left, 0);
						createMolehill(_previousDig.x);
					}
					if (_belowGround || lastBelow)
					{
						_backgroundMesh.addSlice(left, right, (5 / _tunnelTexture.width));
					}
					if (!_belowGround && lastBelow)
					{
						_backgroundMesh.addSlice(right, right, 0);
						createMolehill(_previousDig.x);
					}

				}
				if (speedRatio == 0 && _tunnelBuffer > 0)
				{
					//adds a slice to the ribbonMesh at the surface on both the left and right if the mole has stopped.
					_backgroundMesh.addSlice(new Point(p.x - _halfTunnelheight, _groundHeightOffsets.getHeightOffset(p.x - _halfTunnelheight)), 
											new Point(p.x + _halfTunnelheight, _groundHeightOffsets.getHeightOffset(p.x + _halfTunnelheight)), 
											_tunnelBuffer / _tunnelTexture.width);
					// the end position for the mole is half sticking out of the ground. The tunnel should be removed so it doesn't 
					// look too odd that he would otherwise be midding his legs.
					var t:Tween=new Tween(_tunnelBackground, .5, Transitions.EASE_OUT);
					t.fadeTo(0)
					Starling.juggler.add(t);
				}
				redraw();
			}
			_previousDig=p;
		}

		/**
		 * Created a new molehill when needed and check existing molehills to see if they are 
		 * off screen and should be recycled.
		 * @param x
		 */
		private function createMolehill(x:Number):void
		{
			//remove molehills that are off screen and recycle them to the pool
			
			for (var i:uint=0; i < _moleHills.length; i++)
			{
				var mh:MovieClip=_moleHills[i];
				if (!mh)
				{
					continue;
				}
				if (mh.x < x - mh.width + Const.cameraMaxRect.x)
				{
					mh.removeFromParent();
					_molehillPool.object=mh; //return the molehill to the pool
				}
				else
				{
					break;
				}
			}
			//create the newly requested molehill
			var moleHill:MovieClip=_molehillPool.object; //get a molehill from the pool
			moleHill.x=x;
			moleHill.y=_groundHeightOffsets.getHeightOffset(x) - Const.TUNNEL_MOLEHILL_Y_OFFSET;
			moleHill.pivotX=moleHill.width / 2;
			moleHill.pivotY=moleHill.height / 2;
			moleHill.loop=false;
			Starling.juggler.add(moleHill);
			moleHill.addEventListener(Event.MOVIE_COMPLETED, function(e:Event):void
			{
				Starling.juggler.remove(e.target as MovieClip);
				e.target.removeEventListeners(Event.MOVIE_COMPLETED);
			});
			_moleHills.push(moleHill);
			this.addChild(moleHill);
		}

		/**
		 * Adjust a point to force it to stay below the surface (can't have the tunnel background sticking out into the air!). This is a destructive action.
		 * @param p the point to modify
		 * @return 
		 */
		private function fitBounds(p:Point):Boolean
		{
			var ground:Number=_groundHeightOffsets.getHeightOffset(p.x);
			if (p.y < ground)
			{
				p.y=ground;
				return false;
			}
			return true;
		}

		/**
		 * Draw the tunnel by getting the TrianglePath from the RibbonMesh and passing it to the DrawImage instance
		 */
		public function redraw():void
		{

			_tunnelBackground.drawGraphicsTrianglePath(_backgroundMesh.trianglePath);
		}

		public override function dispose():void
		{
			_molehillPool.deconstruct();
		}
	}
}
import de.polygonal.core.ObjectPoolFactory;

import starling.display.MovieClip;
import starling.textures.Texture;

/**
 * A simple factory for creating new molehills
 * @author Justin Church  - Justin [at] byxb [dot] com 
 * 
 */
internal class MolehillFactory implements ObjectPoolFactory
{
	private var _textures:Vector.<Texture>;

	/**
	 * initialize the factory
	 * @param textures Set the texture to be used by the factory
	 */
	public function MolehillFactory(textures:Vector.<Texture>)
	{
		_textures=textures;
	}

	/**
	 * creates a new molehill.  Called by the ObjectPool
	 * @return 
	 */
	public function create():*
	{
		return new MovieClip(_textures, Const.TUNNEL_MOLEHILL_FPS);
	}
}
