package com.byxb.geom
{
	import com.byxb.utils.*;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class ContinuousCurve
	{
		public static const LOCATION_START:int=0;
		public static const LOCATION_END:int=-1;
		private var _points:Vector.<Point>;
		private var _segLengths:Vector.<Number>;
		private var _closed:Boolean;
		private var _totalLength:Number=0;
		private var _ratioPerPixel:Number;
		private var _maxLength:Number;
		private var _truncatedLength:Number=0;
		public function get length():Number{ return _totalLength;}
		public function get ratioPerPixel():Number {return _ratioPerPixel;}
		public function get points():Vector.<Point>{ return _points.concat();}
		public function get hasCurve():Boolean{ return _points.length>1 && length>0;}
		public function get fullLength():Number{ return _truncatedLength+length;}
		public function ContinuousCurve(closed:Boolean=true, p:Vector.<Point>=null, maxLength:Number=1000000)
		{
			_closed=closed;
			_points=p;
			_points||=new Vector.<Point>();
			calcTotalLength();
		}

		public function addPoint(p:Point, location:Number=-1):Number
		{

			switch (location)
			{
				case LOCATION_END:
					_points.push(p);
					break;
				case LOCATION_START:
					_points.unshift(p);
					_truncatedLength=0;
					break;
			}
			var ratioOffset:Number=_totalLength / calcTotalLength();
			return ratioOffset; //if the application is storing position along the curve by offset, it will need to multiply its stored ratios by this amount
		}
		public function addPointAtRatio(p:Point, ratio:Number):Number
		{
			ratio = adjustForRange(ratio, 1, _closed);
			return addPointAtLength(p, ratio*length);
		}
		public function addPointAtLength(p:Point, len:Number):Number
		{
			len=adjustForRange(len, _totalLength, _closed);
			if(!hasCurve){ 
				addPoint(p);
			}else {
				_points.splice(getPrevPointIndex(len), 0,p);
			}
			if(len==0){
				_truncatedLength=0;
			}
			var ratioOffset:Number=_totalLength / calcTotalLength();
			return ratioOffset; 
		}
		
		public function removePoints(...points:Array):Number{
			if(!hasCurve) return Number.NaN;
			var pts:Vector.<Point> = Vector.<Point>(points);
			_points = _points.filter(function (item:Point, index:int, vec:Vector.<Point>):Boolean{ 
				var match:Boolean=false;
				for(var i:uint=0; i<pts.length; i++){
					match ||=item.equals(pts[i]) ;
				}
				return !match
			});
			var ratioOffset:Number=_totalLength / calcTotalLength();
			return ratioOffset; 
		}
		public function removeNearestPointAtRatio(ratio:Number):Number{
			ratio=adjustForRange(ratio, 1, _closed);
			return removeNearestPointAtLength(ratio * length);
		}
		public function removeNearestPointAtLength(len:Number):Number{
			if(!hasCurve) return Number.NaN;
			len=adjustForRange(len, _totalLength, _closed);
			
			var ind:uint =getPrevPointIndex(len);
			
			if(len- _segLengths[ind] < _segLengths[(ind+1)% _points.length]-len){
				_points.splice(ind, 1);
			} else {
				_points.splice(ind+1, 1);
			}
			
			var ratioOffset:Number=_totalLength / calcTotalLength();
			return ratioOffset; 
		}

		public function getLocationAtRatio(ratio:Number):Point
		{
			ratio=adjustForRange(ratio, 1, _closed);
			return getLocationAtLength(ratio * length);
		}

		public function getLocationAtLength(len:Number):Point
		{
			if(!hasCurve) return null;
			len=adjustForRange(len, _totalLength, _closed);

			var p:uint = getPrevPointIndex(len);
			var startP:Point=_points[p];
			var endP:Point=_points[(p + 1) % _points.length]; // no special !_closed  condition.  Adjusting for range prevents possibility
			var distLeft:Number=p == 0 ? len : len - _segLengths[p - 1];
			return Point.interpolate(endP, startP, distLeft / Point.distance(startP, endP));
		}

		public function getTangentAtRatio(ratio:Number, smoothing:int=0):Number
		{
			ratio=adjustForRange(ratio, 1, _closed);
			return getTangentAtLength(ratio * _totalLength, smoothing);
		}

		public function getTangentAtLength(len:Number, smoothing:int=0):Number
		{
			if(!hasCurve) return Number.NaN;
			len=adjustForRange(len, _totalLength, _closed);

			var p:uint=getPrevPointIndex(len);
			var startP:Point=_points[p];
			var endP:Point=_points[(p + 1) % _points.length]; // no special !_closed  condition.  Filtering value prevents possibility


			//var distLeft:Number = p==0?len : len - _segLengths[p-1]
			//var ratio:Number = distLeft / Point.len(startP, endP)
			//if(if dist
			var vec:Point=endP.subtract(startP);
			var angle:Number=Math.atan2(vec.y, vec.x) * 180 / Math.PI;
			if (smoothing > 0)
			{
				angle*=smoothing;
				var tot:Number=smoothing;
				for (var i:int=1; i <= smoothing; i++)
				{
					tot+=(smoothing + 1 - i) * 2;
					angle+=(smoothing + 1 - i) * getTangentAtLength(len - smoothing);
					angle+=(smoothing + 1 - i) * getTangentAtLength(len + smoothing);
				}
				angle/=tot;
					//angle= (angle +getLineAngleAtLength(len-smoothing) +getLineAngleAtLength(len+smoothing))/3
			}
			return angle;
		}
		public function getNormalAtRatio(ratio:Number=0, normalDirection:int=1, scale:Number=1):Point
		{
			ratio=adjustForRange(ratio, 1, _closed);
			return getNormalAtLength(ratio*length, normalDirection,scale);
		}
		public function getNormalAtLength( len:Number=0, normalDirection:int=1, scale:Number=1):Point
		{
			if(!hasCurve) return new Point(normalDirection *1*scale,0);
			len=adjustForRange(len, length, _closed);
			if (!(normalDirection == -1 || normalDirection == 1))
			{
				throw new RangeError("NormalDirection must be -1 or 1.");
			}
			
			var a:Number=(getTangentAtLength(len) + normalDirection * 90) * Math.PI / 180;
			return Point.polar(scale, a);
		}

		public function splitAtLength(len:Number):Vector.<ContinuousCurve>{
			if(!hasCurve) return new <ContinuousCurve>[];
			len =adjustForRange(len, length, _closed);
			
			var p:uint=getPrevPointIndex(len);
			var splitPoint:Vector.<Point> =new <Point>[this.getLocationAtLength(len)];
			return new <ContinuousCurve>[
				new ContinuousCurve(_closed, _points.slice(0,p).concat(splitPoint)), 
				new ContinuousCurve(_closed, splitPoint.concat(_points.slice((p+1)%points.length, _points.length-1)))];
			
		}
		public function truncateAtLength(len:Number):void{
			if(!hasCurve) return;
			len =adjustForRange(len, length, _closed);
			_truncatedLength+=len;
			var p:uint=getPrevPointIndex(len);
			var splitPoint:Vector.<Point> =new <Point>[this.getLocationAtLength(len)];
			_points=splitPoint.concat(_points.slice(p+1, _points.length-1));
			calcTotalLength();
		}
		private function getPrevPointIndex(len:Number):uint{
			len =adjustForRange(len, length, _closed);
			var p:int=0;
			while (len > _segLengths[p])
			{
				p++;
			} 
			return p;
		}
		private function calcTotalLength():Number
		{
			_segLengths=new Vector.<Number>();
			var tl:Number=0;
			var pl:Number=_points.length;
			if (!pl>1)
			{
				return 0;
			}
			for (var i:uint=0; i < pl; i++)
			{
				var s:Number=calcSegment(_points[i], i, _points, _closed);
				_segLengths.push(tl + s);
				tl+=s;
			} 
			if(tl>_maxLength){
				truncateAtLength(tl-_maxLength);
			}
			_totalLength=tl;
			_ratioPerPixel=1 / tl;
			return tl;
		}

		private function calcSegment(item:Point, index:int, vector:Vector.<Point>, closed:Boolean):Number
		{
			if (index + 1 == vector.length)
			{
				if (closed)
				{
					return Point.distance(item, vector[0]);
				}
				return 0;
			}
			else
			{
				return Point.distance(item, vector[index + 1]);
			}
		}

	}
}
