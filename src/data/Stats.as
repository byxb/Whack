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

package data {
	
	public class Stats extends Object {
		public var _firstPlay:Date;
		public var _lastPlay:Date;
		public var _lastUpdate:Date;
		public var _playCount:uint = 0;
		public var _whackCount:uint = 0;
		public var _launchCount:uint = 0;
		public var _maxDistance:Number = 0;
		public var _maxHeight:Number = 0;
		public var _maxDepth:Number = 0;
		public var _maxScore:Number = 0;
		public var _sessionPlayTime:Number = 0;
		public var _totalPlayTime:Number = 0;
		public var _Chest:uint = 0;     // must match class name
		public var _Dynamite:uint = 0;  // must match class name
		public var _Gem1_1:uint = 0;    // must match class name
		public var _Gem1_2:uint = 0;    // must match class name
		public var _Gem1_3:uint = 0;    // must match class name
		public var _Gem1_4:uint = 0;    // must match class name
		public var _Gem3_1:uint = 0;    // must match class name
		public var _Gem3_2:uint = 0;    // must match class name
		public var _Gem3_3:uint = 0;    // must match class name
		public var _Gem3_4:uint = 0;    // must match class name
		public var _Gold1:uint = 0;     // must match class name
		public var _Hat:uint = 0;      // must match class name
		public var _Pepper:uint = 0;    // must match class name
		public var _Ring:uint = 0;      // must match class name
		public var _Watch:uint = 0;     // must match class name
		
		public function get firstPlay():Date {return _firstPlay;}
		public function get lastPlay():Date {return _lastPlay;}
		public function get lastUpdate():Date {return _lastUpdate;}
		public function get playCount():uint {return _playCount;}
		public function get whackCount():uint {return _whackCount;}
		public function get launchCount():uint {return _launchCount;}
		public function get maxDistance():Number {return _maxDistance;}
		public function get maxHeight():Number {return _maxHeight;}
		public function get maxDepth():Number {return _maxDepth;}
		public function get maxScore():Number {return _maxScore;}
		public function get sessionPlayTime():Number {return _sessionPlayTime;}
		public function get totalPlayTime():Number {return _totalPlayTime;}
		public function get Chest():uint {return _Chest;}
		public function get Dynamite():uint {return _Dynamite;}
		public function get Gem1_1():uint {return _Gem1_1;}
		public function get Gem1_2():uint {return _Gem1_2;}
		public function get Gem1_3():uint {return _Gem1_3;}
		public function get Gem1_4():uint {return _Gem1_4;}
		public function get Gem3_1():uint {return _Gem3_1;}
		public function get Gem3_2():uint {return _Gem3_2;}
		public function get Gem3_3():uint {return _Gem3_3;}
		public function get Gem3_4():uint {return _Gem3_4;}
		public function get Gold1():uint {return _Gold1;}
		public function get Hat():uint {return _Hat;}
		public function get Pepper():uint {return _Pepper;}
		public function get Ring():uint {return _Ring;}
		public function get Watch():uint {return _Watch;}
		
		public function set firstPlay(value:Date):void {_firstPlay = value; GameData.save();}
		public function set lastPlay(value:Date):void  {_lastPlay = value; GameData.save();}
		public function set lastUpdate(value:Date):void {_lastUpdate = value; GameData.save();}
		public function set playCount(value:uint):void {_playCount = value; GameData.save();}
		public function set whackCount(value:uint):void {_whackCount = value; GameData.save();}
		public function set launchCount(value:uint):void {_launchCount = value; GameData.save();}
		public function set maxDistance(value:Number):void {_maxDistance = value; GameData.save();}
		public function set maxHeight(value:Number):void {_maxHeight = value; GameData.save();}
		public function set maxDepth(value:Number):void {_maxDepth = value; GameData.save();}
		public function set maxScore(value:Number):void {_maxScore = value; GameData.save();}
		public function set sessionPlayTime(value:Number):void {_sessionPlayTime = value; GameData.save();}
		public function set totalPlayTime(value:Number):void {_totalPlayTime = value; GameData.save();}
		public function set Chest(value:uint):void {_Chest = value; GameData.save();}
		public function set Dynamite(value:uint):void {_Dynamite = value; GameData.save();}
		public function set Gem1_1(value:uint):void {_Gem1_1 = value; GameData.save();}
		public function set Gem1_2(value:uint):void {_Gem1_2 = value; GameData.save();}
		public function set Gem1_3(value:uint):void {_Gem1_3 = value; GameData.save();}
		public function set Gem1_4(value:uint):void {_Gem1_4 = value; GameData.save();}
		public function set Gem3_1(value:uint):void {_Gem3_1 = value; GameData.save();}
		public function set Gem3_2(value:uint):void {_Gem3_2 = value; GameData.save();}
		public function set Gem3_3(value:uint):void {_Gem3_3 = value; GameData.save();}
		public function set Gem3_4(value:uint):void {_Gem3_4 = value; GameData.save();}
		public function set Gold1(value:uint):void {_Gold1 = value; GameData.save();}
		public function set Hat(value:uint):void {_Hat = value; GameData.save();}
		public function set Pepper(value:uint):void {_Pepper = value; GameData.save();}
		public function set Ring(value:uint):void {_Ring = value; GameData.save();}
		public function set Watch(value:uint):void {_Watch = value; GameData.save();}
		 
		public function Stats() {
			
		}
		
		public function setItemTotalByClass(item:String, value:uint):void 
		{
			this[item] += value;
		}
		
		public function collectItem(itemType:String):uint {
//TODO: calculate and return collect item;			
			return 0;
		}
		
		public function getItemCount(itemType:String):uint {
//TODO: caluclate and return item count;
			return 0;
		}
		
		public function getTotalPlayTimes():uint {
//TODO: calculate and return total play timer;			
			return 0;
		}
		
		public function getSessionPlayTime():uint {
//TODO: calculate and return sessionPlayTime;			
			return 0;
		}
	}
}