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


package com.byxb.utils
{

	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * gets a bounding box for a rotated rectangle
	 * @param rectangle
	 * @param angle
	 * @return 
	 */
	public function rotatedRectBounds(rectangle:Rectangle, angle:Number):Rectangle
	{

		var ct:Number=Math.cos(angle);
		var st:Number=Math.sin(angle);

		var hct:Number=rectangle.height * ct;
		var wct:Number=rectangle.width * ct;
		var hst:Number=rectangle.height * st;
		var wst:Number=rectangle.width * st;
		//trace(angle*180/Math.PI);
		if (angle > 0)
		{
			if (angle < Math.PI / 2)
			{
				//	trace("0 < angle < 90");
				// 0 < angle < 90
				var y_min:Number=rectangle.topLeft.y;
				var y_max:Number=rectangle.topLeft.y + hct + wst;
				var x_min:Number=rectangle.topLeft.x - hst;
				var x_max:Number=rectangle.topLeft.x + wct;
			}
			else
			{
				// 90 <= angle <= 180
				//	trace("// 90 <= angle <= 180");
				y_min=rectangle.topLeft.y + hct;
				y_max=rectangle.topLeft.y + wst;
				x_min=rectangle.topLeft.x - hst + wct;
				x_max=rectangle.topLeft.x;
			}
		}
		else
		{
			if (angle > -Math.PI / 2)
			{
				//	trace("-90 < angle <= 0");
				// -90 < angle <= 0
				y_min=rectangle.topLeft.y + wst;
				y_max=rectangle.topLeft.y + hct;
				x_min=rectangle.topLeft.x;
				x_max=rectangle.topLeft.x + wct - hst;
			}
			else
			{
				//	trace("-180 <= angle <= -90");
				// -180 <= angle <= -90
				y_min=rectangle.topLeft.y + wst + hct;
				y_max=rectangle.topLeft.y;
				x_min=rectangle.topLeft.x + hct;
				x_max=rectangle.topLeft.x - hst;
			}
		}
		return new Rectangle(x_min, y_min, x_max - x_min, y_max - y_min);
	}
}
