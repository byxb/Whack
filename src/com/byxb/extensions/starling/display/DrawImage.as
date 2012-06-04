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

	import flash.display.GraphicsTrianglePath;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import starling.core.QuadBatch;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.errors.MissingContextError;
	import starling.textures.Texture;
	import starling.utils.VertexData;
	

	/**
	 * Extends Image to add drawTriangles capabilities similar to the Graphics object.
	 * @author Justin Church  - Justin [at] byxb [dot] com 
	 * 
	 */
	public class DrawImage extends Image
	{
		private var mVertexBuffer:VertexBuffer3D;
		private var mIndexBuffer:IndexBuffer3D;
		private var mProjectionMatrix:Matrix3D;
		private var tempQuad:VertexImage
		protected var _vertices:Vector.<Number>=new Vector.<Number>();
		protected var _uvData:Vector.<Number>=new Vector.<Number>();
		/**
		 * Triangle vertex indices
		 * @default 
		 */
		protected var _indices:Vector.<uint>=new Vector.<uint>();

		/**
		 * All triangle drawing will use the supplied texture as if a BeginBitmapFill were used.
		 * @param texture
		 */
		public function DrawImage(texture:Texture, maxTriangles:uint=0)
		{
			mProjectionMatrix = new Matrix3D();
			super(texture);
			tempQuad = new VertexImage(texture);
		}

		/**
		 * Draws a collection of triangles filled with the textue supplied in the constructor
		 * @param vertices Vector.<Number> that alternates between X,Y values.
		 * @param uvData Vector.<Number> that alternates between U,V values.  Must be the same length as vertices.
		 * @param indices Vector.<uint> contains the vertex indices indicating how the triangles should be drawn.
		 * @throws Error
		 */
		public function drawTriangles(vertices:Vector.<Number>, uvData:Vector.<Number>, indices:Vector.<uint>=null):void
		{

			if (!_indices && !indices)
			{
				return;
			}
			/*mVertexData=new VertexData(vertices.length / 2, texture.premultipliedAlpha);

			for (var i:uint=0; i < vertices.length; i+=2)
			{

				mVertexData.setPosition(i >> 1, vertices[i], vertices[i + 1]);

			}*/
			mVertexData.setUniformColor(0xffffff);
			_vertices = vertices.concat();
			_uvData = uvData.concat();
			_indices=indices.concat();

			if (uvData.length != vertices.length)
			{
				throw new Error("uvData and vertices must be the same length.  Be sure that you are not supplying UVT data.");
			}
			/*for (var i:uint=0; i < uvData.length; i+=2)
			{
				mVertexData.setTexCoords(i >> 1, uvData[i], uvData[i + 1]);
			}*/
			/*createVertexBuffer();
			if (indices)
			{
				createIndexBuffer();
			}*/
		}

		/**
		 * draws triangles using the GraphicTrianglePath object from the Drawing API.  The index vector will automatically be converted from int to uint.
		 * @param trianglePath
		 */
		public function drawGraphicsTrianglePath(trianglePath:GraphicsTrianglePath):void
		{
			drawTriangles(trianglePath.vertices, trianglePath.uvtData, Vector.<uint>(trianglePath.indices));
		}

		/**
		 * @inherit
		 * @param targetSpace
		 * @return 
		 */
		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
		{
			return new Rectangle(0, 0, 100, 200);

		}

		/**
		 * Renders the triangles.  Overridden to allow for more than a rectangle to be drawn.
		 * @param support
		 * @param alpha
		 * @throws MissingContextError
		 */
		public override function render(support:RenderSupport, alpha:Number):void
		{
			if (_indices.length < 3 || mVertexData.numVertices < 3)
				return;
			/*var pma:Boolean = mVertexData.premultipliedAlpha;
			var context:Context3D = Starling.context;
			var dynamicAlpha:Boolean = alpha != 1.0;
			
			var program:String = "QB_iRn";
			
			RenderSupport.setDefaultBlendFactors(pma);
			
			context.setProgram(Starling.current.getProgram(program));
			context.setVertexBufferAt(0, mVertexBuffer, VertexData.POSITION_OFFSET, Context3DVertexBufferFormat.FLOAT_3); 
			context.setVertexBufferAt(1, mVertexBuffer, VertexData.COLOR_OFFSET,    Context3DVertexBufferFormat.FLOAT_4);
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mProjectionMatrix, true);            

			
			if (texture)
			{
				context.setTextureAt(0, texture.base);
				context.setVertexBufferAt(2, mVertexBuffer, VertexData.TEXCOORD_OFFSET, Context3DVertexBufferFormat.FLOAT_2);
			}
			
			context.drawTriangles(mIndexBuffer, 0, _indices.length/3);
			
			if (texture)
			{
				context.setTextureAt(0, null);
				context.setVertexBufferAt(2, null);
			}
			
			context.setVertexBufferAt(1, null);
			context.setVertexBufferAt(0, null);*/
			/*var time:uint = getTimer();
			for( var i:uint=0; i<_indices.length/3; i++){
				var inds:Vector.<uint> =new <uint>[];
				var ind:uint = _indices[i*3];
			 	tempQuad.setVertex(0, _vertices[ind*2], _vertices[ind*2+1],  _uvData[ind*2], _uvData[ind*2+1], 0xFFFFFF);	
				ind= _indices[i*3+1];
				tempQuad.setVertex(1, _vertices[ind*2], _vertices[ind*2+1],  _uvData[ind*2], _uvData[ind*2+1], 0xFFFFFF);	
				ind= _indices[i*3+2];
				tempQuad.setVertex(2, _vertices[ind*2], _vertices[ind*2+1],  _uvData[ind*2], _uvData[ind*2+1], 0xFFFFFF);
				tempQuad.setVertex(3, _vertices[ind*2], _vertices[ind*2+1],  _uvData[ind*2], _uvData[ind*2+1], 0xFFFFFF);	
				
				support.batchQuad(tempQuad, alpha,texture, smoothing);
				
			}
			trace(getTimer()-time);*/
		}
		
		/** Sets up the projection matrix for ortographic 2D rendering. */
		public function setOrthographicProjection(width:Number, height:Number, 
												  near:Number=-1.0, far:Number=1.0):void
		{
			sMatrixCoords[0] = 2.0 / width;
			sMatrixCoords[1] = sMatrixCoords[2] = sMatrixCoords[3] = sMatrixCoords[4] = 0.0;
			sMatrixCoords[5] = -2.0 / height;
			sMatrixCoords[6] = sMatrixCoords[7] = sMatrixCoords[8] = sMatrixCoords[9] = 0.0;
			sMatrixCoords[10] = -2.0 / (far - near);
			sMatrixCoords[11] = 0.0;
			sMatrixCoords[12] = -1.0;
			sMatrixCoords[13] = 1.0;
			sMatrixCoords[14] = -(far+near) / (far-near);
			sMatrixCoords[15] = 1.0;
			
			mProjectionMatrix.copyRawDataFrom(sMatrixCoords);
		}
		/** Helper object. */
		private static var sMatrixCoords:Vector.<Number> = new Vector.<Number>(16, true);
		/**
		 * updates the data that goes to the GPU for vertices. Think of this as part of what is needed to get your triangels to be drawn/re-drawn.
		 */
		protected  function createVertexBuffer():void
		{
			mVertexData.copyTo(mVertexData);
			texture.adjustVertexData(mVertexData, 0, 4);
		if (mVertexData.numVertices >= 3)
			{
				//mVertexData = new VertexData(
				mVertexBuffer=Starling.context.createVertexBuffer(mVertexData.numVertices, VertexData.ELEMENTS_PER_VERTEX);

				mVertexBuffer.uploadFromVector(mVertexData.rawData, 0, mVertexData.numVertices);
			}
		}
		/**
		 * updates the data that goes to the GPU for indices. Think of this as part of what is needed to get your triangels to be drawn/re-drawn.
		 */
		protected  function createIndexBuffer():void
		{
			//if (mIndexBuffer == null)
			if (_indices.length)
			{
				mIndexBuffer=Starling.context.createIndexBuffer(_indices.length);

				mIndexBuffer.uploadFromVector(_indices, 0, _indices.length);
			}
		}

	}
}
