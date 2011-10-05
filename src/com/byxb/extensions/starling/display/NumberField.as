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


package com.byxb.extensions.starling.display
{

	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * Number field constructs a single line text field and label using a texture atlas.  
	 * Contains number formatter features.
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class NumberField extends Sprite
	{
		/**
		 * Text align left
		 * @default 
		 */
		public static const ALIGN_LEFT:String="left";
		/**
		 * Text align Center
		 * @default 
		 */
		public static const ALIGN_CENTER:String="center";
		/**
		 * Text align Right
		 * @default 
		 */
		public static const ALIGN_RIGHT:String="right";

		private var _textureAtlas:TextureAtlas;
		private var _placeValues:uint;
		private var _floatPlaceValues:uint;
		private var _align:String;
		private var _showNegative:Boolean;
		private var _showFrontZeros:Boolean;
		private var _showCommas:Boolean;
		private var _characterSpacing:int=0;
		private var _value:Number;
		private var _skin:String;
		private var _prefix:String;
		private var _s:String;
		private var _characterNameLookup:Object;
		private var _label:String;

		/**
		 * The numeric value to be displayed in the field
		 * @return 
		 */
		public function get value():Number  { return _value; }
		public function set value(value:Number):void  { _value=value; updateValue(); }

		/**
		 * Number of pixels between each character image
		 * @return 
		 */
		public function get characterSpacing():Number  { return _characterSpacing; }
		public function set characterSpacing(value:Number):void  { _characterSpacing=value; updateValue(); }

		/**
		 * Skin key used in the texture atlas lookup.  Subtexture names are of the form PREFIX_SKIN_CHARCODE
		 * @return 
		 */
		public function get skin():String  { return _skin; }
		public function set skin(skin:String):void  { _skin=skin; updateSkin(); }

		/**
		 * Creates a new single line numeric textfield with a label.
		 * @param label The text to be displayed to the left of the numbers.  If you want a colon, you must specify it in this screen.
		 * @param textureAtlas The texture atlas to use to lookup the font subtextures on.
		 * @param texturePrefix key used in the texture atlas lookup.  Subtexture names are of the form PREFIX_SKIN_CHARCODE
		 * @param textureSkin key used in the texture atlas lookup.  Subtexture names are of the form PREFIX_SKIN_CHARCODE
		 * @param placeValues how many integer place values (left of the decimal) to display
		 * @param floatPlaceValues how many digits to the right of the decimal to allow
		 * @param align How to align the numeric portion of the field
		 * @param showNegative Should the value clamp at zero or display negative numbers
		 * @param showFrontZeros if the value has fewer place values than the placeValues parameter, should padding zeroes be added
		 * @param showCommas Should commas be inserted
		 */
		public function NumberField(label:String, textureAtlas:TextureAtlas, texturePrefix:String="font", textureSkin:String="default", placeValues:uint=5, floatPlaceValues:uint=1, align:String="left", showNegative:Boolean=true, showFrontZeros:Boolean=true, showCommas:Boolean=true)
		{
			_value=0;
			_prefix=texturePrefix;
			_skin=textureSkin;

			_label=label;
			_textureAtlas=textureAtlas;
			_placeValues=placeValues;
			_floatPlaceValues=floatPlaceValues;
			_align=align;
			_showNegative=showNegative;
			_showFrontZeros=showFrontZeros;
			_showCommas=showCommas;

			updateValue();

		}

		/**
		 * formats the string
		 */
		private function updateValue():void
		{
			_s=String(Math.floor(Math.abs(_value)));
			var length:uint=_s.length;

			// DETERMINE PLACE VALUES
			if (_placeValues < length)
			{
				_s=_s.substr(length - _placeValues);
			}

			// INSERT COMMAS
			// c = number of commas
			// ss = str before 1st comma
			if (_showCommas && length > 3)
			{
				var c:uint=Math.ceil(length / 3) - 1;
				var ss:String=_s.substr(0, length - (3 * c));

				for (var i:uint=c; i > 0; i--)
				{
					ss=ss + "," + _s.substr(length - (3 * i), 3);
				}

				_s=ss;
			}

			// SHOW FRONT ZEROS
			// l = number of placevalues to add
			// z = str of "0"
			if (_showFrontZeros && _placeValues > length)
			{
				var l:uint=_placeValues - length;
				var z:String="";

				for (var j:uint=0; j < l; j++)
				{
					z=z + "0";
				}

				_s=z + _s;
			}

			// DETERMINE FLOAT PLACE VALUES
			// f = float str
			// determine if value has decimal else split value
			if (_floatPlaceValues > 0)
			{
				var f:String="";

				if (_value == Math.round(_value))
				{
					for (var k:uint=0; k < _floatPlaceValues; k++)
					{
						f=f + "0";
					}
				}
				else
				{
					var a:Array=String(Math.abs(_value)).split(".");
					f=a[1].substr(0, _floatPlaceValues);
				}

				_s=_s + "." + f;
			}

			// SHOW NEGATIVE
			if (_showNegative && _value < 0)
			{
				_s="-" + _s;
			}
			else if (_value < 0)
			{
				_s="0";
			}
			updateNumber();

		}

		/**
		 * builds the display of the field
		 */
		private function updateNumber():void
		{
			var fullText:String=_label + _s;
			var img:Image; 
			var xPad:Number=0;
			var prev:Image;
			for (var i:int=0; i < fullText.length; i++)
			{
				try
				{
					prev=getChildAt(i) as Image;
					if (prev.name == fullText.charAt(i))
					{
						prev.x=xPad;
						xPad+=_characterSpacing + prev.width;
						continue;
					}
				}
				catch (e:RangeError)
				{
				}
				var tex:Texture=_textureAtlas.getTexture(buildTextureName(fullText.charAt(i)));
				img=new Image(tex);
				img.x=xPad;
				img.name=fullText.charAt(i);
				addChildAt(img, i);
				xPad+=_characterSpacing + (tex.frame ? tex.frame.width : tex.width);
			}
			if (i < numChildren)
			{
				this.removeChildren(i, -1, true);
			}
		}

		/**
		 * redraws the display when a new skin is used
		 */
		private function updateSkin():void
		{
			updateNumber();
		}

		/**
		 * returns the name of the required subTexture based on a supplied character
		 * @param character
		 * @return the name of the required subTexture based on a supplied character
		 */
		private function buildTextureName(character:String):String
		{
			return _prefix + "_" + _skin + "_" + character.charCodeAt(0);
		}
	}
}
