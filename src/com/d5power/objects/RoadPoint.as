package com.d5power.objects
{
	import com.d5power.D5Game;
	import com.d5power.controller.BaseControler;
	
	import flash.geom.Point;
	
	public class RoadPoint extends GameObject
	{
		/**
		 * 要切换到的地图Id
		 */ 
		public var toMap:uint;
		/**
		 * 要切换到的地图坐标
		 */ 
		public var toX:uint;
		/**
		 * 要切换到的地图坐标
		 */ 
		public var toY:uint;
		
		/**
		 * 碰撞检测频度，默认为500毫秒
		 */ 
		protected var checkfps:uint = 500;
		
		/**
		 * 上次检测时间
		 */ 
		protected var lastCheck:uint = 0;
		
		/**
		 * 锁定状态
		 */ 
		protected var lock:Boolean=false;
		
		/**
		 * 传送检测精度
		 */ 
		protected var checkSize:uint = 100;
		
		/**
		 * 恢复传送检测的精度（角色如果传送失败，则必须跑出该距离才能恢复传送）
		 */ 
		protected var recheckSize:uint = 200;
		
		public function RoadPoint(ctrl:BaseControler=null)
		{
			objectName = 'RoadPoint';
			super(ctrl);
		}
		
		override protected function renderAction():void
		{
			super.renderAction();
			if(Global.Timer-lastCheck>checkfps && D5Game.me.scene.Player!=null)
			{
				lastCheck = Global.Timer;
				if(lock)
				{
					if(Point.distance(D5Game.me.scene.Player._POS,pos)>recheckSize) lock=false;
				}else{
					if(Point.distance(D5Game.me.scene.Player._POS,pos)<checkSize)
					{
						D5Game.me.changeScene(toMap,toX,toY);
						lock = true;
					}
				}
			}
		}
	}
}