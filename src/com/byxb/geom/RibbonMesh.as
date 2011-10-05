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


package com.byxb.geom
{

	import com.byxb.utils.*;

	import flash.display.GraphicsTrianglePath;
	import flash.geom.Point;

	import starling.textures.Texture;

	/**
	 * Creates a crid of triangles that has an active end that may be added to
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class RibbonMesh
	{
		private var _vertices:Vector.<Number>;
		private var _indices:Vector.<int>;
		private var _uvData:Vector.<Number>;
		private var _slices:Vector.<Slice>;
		private var _lengthSegments:uint;
		private var _crossSegments:uint;
		private var _startSlice:uint=0;
		private var _currentU:Number=0;
		private var _dirty:Boolean=false;

		/**
		 * Returns a GraphicsTrianglePath object for internal geometry data
		 * @return 
		 */
		public function get trianglePath():GraphicsTrianglePath
		{
			buildVertAndUV();
			return new GraphicsTrianglePath(_vertices, _indices, _uvData);
		}

		/**
		 * The number of slices in the ribbon.
		 * @return 
		 */
		public function get lengthSegments():uint  { return _lengthSegments; }
		public function set lengthSegments(val:uint):void  { _lengthSegments=val; rebuild(); }

		/**
		 * The number of segments in each slice (short axis)
		 * @return 
		 */
		public function get crossSegments():uint  { return _crossSegments; }
		public function set crossSegments(val:uint):void  { _crossSegments=val; rebuild(); }

		/**
		 * Creates a crid of triangles that has an active end that may be added to
		 * @param lengthSegments The number of slices in the ribbon.
		 * @param crossSegments The number of segments in each slice (short axis)
		 */
		public function RibbonMesh(lengthSegments:uint=20, crossSegments:uint=1)
		{
			_lengthSegments=lengthSegments;
			_crossSegments=crossSegments;
			_slices=new Vector.<Slice>(lengthSegments + 1, true);
			for (var i:uint=0; i < _slices.length; i++)
			{
				_slices[i]=new Slice();
			}
			rebuild();

		}

		/**
		 * Sets the oldest slice to new parameters
		 * @param point1 The top edge of the the new slice
		 * @param point2 The bottom edge of the new slice
		 * @param uStep How much texture U to add on to the previous slice.
		 * @param relativeUV Is the uStep relative to the last slice or should it be treated as an absolute value
		 */
		public function addSlice(point1:Point, point2:Point, uStep:Number=0, relativeUV:Boolean=true):void
		{
			_currentU+=uStep;
			var _currentSlice:uint=_startSlice;
			_startSlice=loop(_startSlice + 1, _slices.length);
			var s:Slice=_slices[_currentSlice];
			s.setTo(point1, point2, _currentU);
			var v:uint=0;
			s.filled=true;
			for (var i:uint=0; i <= _crossSegments; i++)
			{
				var crossSeg:Point=Point.interpolate(point1, point2, i / _crossSegments);
				s.crossSegs[v]=crossSeg.x;
				s.crossSegsUV[v++]=relativeUV ? _currentU : uStep;
				s.crossSegs[v]=crossSeg.y;
				s.crossSegsUV[v++]=i / _crossSegments

			}
			_dirty=true;
		}

		/**
		 * Constructs the indices.  Should not need to run more than once unless the number of slices has been changed.
		 */
		private function buildIndices():void
		{
			var ind:uint=0;
			for (var j:uint=0; j <= _lengthSegments; j++)
			{
				var newBaseV:int=(_crossSegments + 1) * j;
				var oldBaseV:int=(_crossSegments + 1) * (j - 1);
				for (var i:uint=0; i <= _crossSegments; i++)
				{
					if (j > 0 && i > 0)
					{
						_indices[ind++]=newBaseV + i;
						_indices[ind++]=newBaseV + (i - 1);
						_indices[ind++]=oldBaseV + (i - 1);

						_indices[ind++]=newBaseV + i;
						_indices[ind++]=oldBaseV + (i - 1);
						_indices[ind++]=oldBaseV + i;
					}
				}
			}
		}

		/**
		 * Build UV and vertex data if it has been updated
		 */
		public function buildVertAndUV():void
		{
			if (!_dirty)
				return;
			var v:uint=0;
			for (var i:uint=0; i < _slices.length; i++)
			{
				var slice:Slice=_slices[loop(i + _startSlice, _slices.length)];
				for (var j:uint=0; j <= _crossSegments; j++)
				{
					_vertices[v]=slice.crossSegs[j * 2];
					_uvData[v]=slice.crossSegsUV[j * 2];
					v++;
					_vertices[v]=slice.crossSegs[j * 2 + 1];
					_uvData[v]=slice.crossSegsUV[j * 2 + 1];
					v++;

				}
			}
		}

		/**
		 * recreate the geometry of the ribbon
		 */
		private function rebuild():void
		{
			_vertices=new Vector.<Number>(2 * (_crossSegments + 1) * (_lengthSegments + 1), true);
			_indices=new Vector.<int>(6 * _crossSegments * _lengthSegments, true);
			buildIndices();
			_uvData=new Vector.<Number>(2 * (_crossSegments + 1) * (_lengthSegments + 1), true);
			while (_slices.length != _lengthSegments + 1)
			{
				if (_slices.length > _lengthSegments + 1)
				{
					_slices.splice(_startSlice, 1);
					_startSlice=loop(_startSlice, _slices.length);
				}
				else
				{
					_slices.splice(_startSlice, 0, new Slice());
				}
			}
			for (var i:uint=0; i < _slices.length; i++)
			{
				var slice:Slice=_slices[loop(i + _startSlice, _slices.length)];
				addSlice(slice.pt1, slice.pt2, slice.u);
			}
		}

		/**
		 * deletes the geometry of the ribbon
		 */
		public function clear():void
		{
			_currentU=0;
			_startSlice=0;
			_vertices=new Vector.<Number>();
			_indices=new Vector.<int>();
			_uvData=new Vector.<Number>();
		}

	}
}
import flash.geom.Point;

/**
 * A data object for holding data for slices
 * @author Justin Church  - Justin [at] byxb [dot] com 
 * 
 */
class Slice
{

	public var pt1:Point;
	public var pt2:Point;
	public var u:Number;
	public var crossSegs:Vector.<Number>=new Vector.<Number>();
	public var crossSegsUV:Vector.<Number>=new Vector.<Number>();
	public var filled:Boolean=false;

	public function Slice(pt1:Point=null, pt2:Point=null, u:Number=0)
	{
		var p:Point=new Point();
		this.pt1=pt1;
		this.pt1||=p.clone();
		this.pt2=pt2;
		this.pt2||=p.clone();
		this.u=u;
	}

	public function setTo(pt1:Point=null, pt2:Point=null, u:Number=0):void
	{
		var p:Point=new Point();
		this.pt1=pt1;
		this.pt1||=p.clone();
		this.pt2=pt2;
		this.pt2||=p.clone();
		this.u=u;

	}
}
