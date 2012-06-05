package com.byxb.extensions.starling.display
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class VertexImage extends Image
	{
		public static const SOLO1:uint = 0;
		public static const SOLO2:uint= 3;
		public static const SHARED1:uint=1;
		public static const SHARED2:uint=2;
		public function VertexImage(texture:Texture)
		{
			super(texture);
		}
		public function setVertex(vertexID:uint, vx:Number, vy:Number, vu:Number, vv:Number,vColor:uint=0xFFFFFF, vAlpha:Number=1, update:Boolean=false):void
		{
			mVertexData.setPosition(vertexID, vx, vy);
			mVertexData.setTexCoords(vertexID, vu, vv);
			//setVertexColor(vertexID, vColor);
			//super.setVertexAlpha(vertexID, vAlpha);
		}
		public function update():void{
			super.setVertexAlpha(0,1);
		}
	}
}