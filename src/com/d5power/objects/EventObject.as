package com.d5power.objects
{
	import com.d5power.D5Game;
	import com.d5power.controller.BaseControler;
	import com.d5power.display.D5TextField;
	
	import flash.geom.Point;
	
	/**
	 * 游戏事件对象
	 */ 
	public class EventObject extends GameObject
	{
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
		 * 事件检测精度
		 */ 
		protected var _checkSize:uint = 200;
		
		/**
		 * 恢复事件检测的精度（角色如果传送失败，则必须跑出该距离才能恢复传送）
		 */ 
		protected var recheckSize:uint = 300;
		
		public function EventObject(ctrl:BaseControler=null)
		{
			objectName = 'EventObject';
			super(ctrl);
		}
		
		/**
		 * 事件检测精度
		 */ 
		public function set checkSize(v:uint):void
		{
			_checkSize = v;
		}
		
		override public function set visible(value:Boolean):void
		{
			if(visible)
			{
				var t:D5TextField = new D5TextField('',0xffffff);
				t.width = 60;
				t.height = 30;
				t.fontSize = 16;
				t.fontBold=true;
				t.text = ID.toString();
				addChild(t);
				
				graphics.beginFill(Math.random()*0xffffff);
				graphics.drawRect(-30,-30,60,60);
				graphics.endFill();
			}else{
				removeChildren(0,numChildren-1);
				graphics.clear();
			}
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
					if(Point.distance(D5Game.me.scene.Player._POS,pos)<_checkSize)
					{
						D5Game.me.makeRPGEvent(ID);
						lock = true;
					}
				}
			}
		}
	}
}