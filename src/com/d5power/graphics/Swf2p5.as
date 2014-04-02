package com.d5power.graphics
{
	import com.d5power.D5Game;
	import com.d5power.controller.Actions;
	import com.d5power.net.D5StepLoader;
	import com.d5power.objects.Direction;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	public class Swf2p5 implements ISwfDisplayer
	{
		private var _lib:Array;
		private var _list:Vector.<BitmapData>;
		private var _time:int = 0;
		private var _bmd:Bitmap;
		private var _frame:int = 0;
		private var _shadow:Shape;
		private var _direction:int;
		private var _nowFrame:uint;
		private var _loop:Boolean=true;
		private var _totalFrame:uint;
		private var _openShadow:Boolean;
		private var _offsetX:int;
		private var _offsetY:int;
		
		private var _swfPath:String;
		
		/**
		 * 阴影缩放系数，请根据实际项目情况修改
		 */ 
		protected var _shadowScale:Number = 0.05;
		
		private var _onResReady:Function;
		
		private var _playSpeed:uint;
		
		private static const transformMartix:Matrix = new Matrix();
		
		public function Swf2p5(openShadow:Boolean=false)
		{
			_bmd = new Bitmap();
			_shadow = new Shape();
			_openShadow = openShadow;
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
		
		public function dispose():void
		{
			_onResReady = null;
			_bmd.bitmapData=null;
			_list = null;
		}
		
		public function get monitor():Bitmap
		{
			return _bmd;
		}
		
		public function get shadow():Shape
		{
			return _shadow;
		}
		
		public function set direction(v:int):void
		{
			if(_direction==v) return;

			if(v*_direction<=0)
			{
				_direction = v;
				resetMartix();
			}else{
				_direction = v;
			}
			
			
			if(_lib==null) return;
			
			
			_list = _lib[renderDirection];
		}
		
		public function get renderDirection():int
		{
			return _direction>0 ? _direction : -_direction;
		}
		
		public function set loop(b:Boolean):void
		{
			_loop = b;
		}
		
		public function set action(v:int):void
		{
			
		}
		
		public function get playFrame():uint
		{
			return _nowFrame;
		}
		
		public function get totalFrame():uint
		{
			return _totalFrame;
		}
		
		public function changeSWF(file:String,inPool:Boolean=true):void
		{
			_swfPath = file;
			if(_bmd)
			{
				_bmd.bitmapData = null;
				
				_lib = null;
				_list = null;
			}else{
				_bmd = new Bitmap(null, "auto", true);
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
			_lib = data.list;
			_list = _lib[renderDirection];
			_totalFrame = int(data.xml.@Frame)-1;
			_playSpeed = int(data.xml.@Time);
			_bmd.x = _offsetX = int(data.xml.@X);
			_bmd.y = _offsetY = int(data.xml.@Y);
			
			_time = getTimer();
			_bmd.bitmapData = _list[0];
			
			resetMartix()
			
			if(_openShadow)
			{
				if(_shadow==null) _shadow = new Shape();
				var matr:Matrix = new Matrix();
				matr.createGradientBox(50, 30,0,-25,-15);
				_shadow.graphics.beginGradientFill(GradientType.RADIAL,[0,0],[1,0],[0,255],matr);
				_shadow.graphics.drawEllipse(-25, -15, 50, 30);
				_shadow.scaleX = Number(data.xml.@shadowX) * _shadowScale;
				_shadow.scaleY = Number(data.xml.@shadowY) * _shadowScale;
			}
			
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
		
		
		private function resetMartix():void
		{
			if(_direction<0)
			{
				transformMartix.a = -1;
				transformMartix.ty = _offsetY;
				transformMartix.tx = -_offsetX;
			}else{
				transformMartix.a = 1;
				transformMartix.ty = _offsetY;
				transformMartix.tx = _offsetX;
			}
			
			_bmd.transform.matrix = transformMartix;
		}
	}
}