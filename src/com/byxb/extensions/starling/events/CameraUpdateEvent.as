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


package com.byxb.extensions.starling.events
{

	import flash.geom.Rectangle;

	import starling.events.Event;

	/**
	 * An Event that is dispatched by CameraSprite to indicate that it has updated
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class CameraUpdateEvent extends Event
	{

		/**
		 * Event type - "cameraUpdate";
		 */
		public static const CAMERA_UPDATE:String="cameraUpdate";
		/**
		 * The viewport that is now visible post-move.
		 */
		public var viewport:Rectangle;

		/**
		 * An Event that is dispatched by CameraSprite to indicate that it has updated
		 * @param viewport
		 * @param bubbles
		 */
		public function CameraUpdateEvent(viewport:Rectangle, bubbles:Boolean=false)
		{
			this.viewport=viewport;
			super(CAMERA_UPDATE, bubbles);
		}
	}
}
