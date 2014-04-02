package com.d5power.stuff
{
	import com.d5power.objects.CharacterObject;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * Hp/Sp 条
	 */ 
	public class HSpbar extends CharacterStuff
	{
		/**
		 * 当前值
		 */ 
		private var _nowVal:uint;
		
		public static const UP:uint = 0;
		public static const DOWN:uint = 1;
		
		private var _size:uint = 50;
		/**
		 * 上次渲染的值，用来进行渲染优化，同值不渲染
		 */ 
		private var _lastRender:uint;
		
		/**
		 * @param		target		跟踪目标
		 * @param		attName		跟踪属性名
		 * @param		attMaxName	最大值跟踪
		 * @param		ytype		Y轴位置，若大于1则使用该值进行定位
		 * @param		resource	使用素材
		 */ 
		public function HSpbar(target:CharacterObject,attName:String,attMaxName:String,ytype:int = 1)
		{
			y = ytype;
			x = -(_size>>1);
			
			super(target,attName,attMaxName);
			
			update();
		}
		
		private function waitForFly(e:TimerEvent):void
		{
		}
		
		/**
		 * 渲染
		 * @param		buffer		缓冲区
		 * @param		p			角色的标准渲染坐标
		 */ 
		public function update():void
		{
			if(_lastRender==_target[_attName]) return;
			_lastRender = _target[_attName];
			graphics.clear();
			graphics.beginFill(0x990000);
			graphics.drawRect(0,0,int(_size*_target[_attName]/_target[_attMaxName]),4);
			graphics.endFill();
			graphics.lineStyle(1);
			graphics.lineTo(_size,0);
			graphics.lineTo(_size,4);
			graphics.lineTo(0,4);
			graphics.lineTo(0,0);
			
		}
	}
}