package com.d5power.graphics
{
	import com.d5power.D5Game;
	import com.d5power.net.D5StepLoader;
	
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.utils.getTimer;
	
	public class Swf2d implements ISwfDisplayer
	{
		private var _list:Array;
		private var _time:int = 0;
		private var _bmd:Bitmap;
		private var _frame:int = 0;
		private var _shadow:Shape;
		
		private var _swfPath:String;
		private var _nowFrame:uint;
		private var _totalFrame:uint;
		private var _onResReady:Function;
		private var _playSpeed:uint;
		private var _loop:Boolean=true;
		
		private var _offsetX:int;
		private var _offsetY:int;
		
		
		public function Swf2d()
		{
			_bmd = new Bitmap();
			_shadow = new Shape();
			super();
		}
		
		public function set onReady(f:Function):void
		{
			_onResReady = f;
		}
		
		public function get swfDir():String
		{
			var index:int = _swfPath.lastIndexOf('/');
			return index==-1 ? '' : _swfPath.substr(0,index);
		}
		
		public function get maxFrame():uint
		{
			return _list.length;
		}
		
		public function get nowFrame():uint
		{
			return _nowFrame;
		}
		
		public function get swfPath():String
		{
			return _swfPath;
		}
		
		public function set direction(v:int):void
		{
			
		}
		
		public function get renderDirection():int
		{
			return 0;
		}
		
		public function set action(v:int):void
		{
			
		}
		
		public function get monitor():Bitmap
		{
			return _bmd;
		}
		
		public function get shadow():Shape
		{
			return _shadow;
		}
		
		public function dispose():void
		{
			_onResReady = null;
			_bmd.bitmapData=null;
			_list = null;
		}
		
		public function changeSWF(file:String,inPool:Boolean=true):void
		{
			_swfPath = file;
			if(_bmd)
			{
				_bmd.bitmapData = null;
				
				_list = null;
			}
			
			if(_shadow)
			{
				_shadow.graphics.clear();
			}
			
			_frame = 0;
			D5StepLoader.me.addLoad(D5Game.me.projPath+file,setSWF,inPool,D5StepLoader.TYPE_SWF);
		}
		
		public function setSWF(data:Object):void
		{
			_list = data.list;
			_offsetX = int(data.xml.@X);
			_offsetY = int(data.xml.@Y);
			_time = getTimer();
			_playSpeed = int(data.xml.@Time);
			
			_bmd.bitmapData = _list[0];
			
			
			var px:int=_bmd.scaleX>0 ? 0 : _bmd.width;
			var py:int;
			
			
			_bmd.x = _offsetX + px;
			_bmd.y = _offsetY + py;
			
			
			var matr:Matrix = new Matrix();
			matr.createGradientBox(50, 30,0,-25,-15);
			_shadow.graphics.beginGradientFill(GradientType.RADIAL,[0,0],[1,0],[0,255],matr);
			_shadow.graphics.drawEllipse(-25, -15, 50, 30);
			_shadow.scaleX = Number(data.xml.@shadowX) * 0.01;
			_shadow.scaleY = Number(data.xml.@shadowY) * 0.01;
			
			if(_onResReady!=null)
			{
				_onResReady();
				_onResReady = null;
			}
		}
		
		private var lastRender:uint;
		public function render():void
		{
			if(_list==null || (!_loop && _nowFrame==_totalFrame) || Global.Timer-lastRender<_playSpeed) return;
			
			lastRender = Global.Timer;
			var cost_time:Number = (lastRender - _time) / _playSpeed;
			
			if (_frame != cost_time)
			{
				_nowFrame = int(cost_time % _list.length);
				_frame = cost_time;
				_bmd.bitmapData = _list[_nowFrame];
			}
		}
		
		public function set scaleX(v:Number):void
		{
			_bmd.scaleX = v;
			if(_list==null) return;
			if(v<0)
			{
				_bmd.x = _offsetX-_bmd.width*v;
			}else{
				_bmd.x = _offsetX;
			}
		}
	}
}