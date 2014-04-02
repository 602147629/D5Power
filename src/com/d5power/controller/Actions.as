/**
 * D5Power Studio FPower 2D MMORPG Engine
 * 第五动力FPower 2D 多人在线角色扮演类网页游戏引擎
 * 
 * copyright [c] 2010 by D5Power.com Allrights Reserved.
 */ 
package com.d5power.controller
{
	public class Actions
	{
		/**
		 * 特殊状态：复活
		 */ 
		public static const RELIVE:int = -1;
		/**
		 * Stop 停止
		 * */
		public static const Stop:int=0; 
		/**
		 * Run 跑动
		 * */
		public static const Run:int=1;
		/**
		 * Attack 物理攻击
		 * */
		public static const Attack:int=2;
		/**
		 * 弓箭攻击
		 * */
		public static const BowAtk:int=3;
		
		/**
		 * 坐下
		 */ 
		public static const Sit:int = 4;
		
		/**
		 * 死亡 5
		 */ 
		public static const Die:int = 5;
		
		/**
		 * 拾取
		 */ 
		public static const Pickup:uint = 6;
		
		/**
		 * 被攻击
		 */
		public static const BeAtk:uint = 7;
		
		/**
		 * 等待（备战）8
		 */ 
		public static const Wait:uint = 8;
		
		/**
		 * 若无特殊情况，只播放一次的动作
		 */ 
		public static var OnePlay:Array = [2,6,7];
		
		/**
		 * 播放一次的动作结束后，自动切换入等待动作的
		 */ 
		public static var StopToWait:Array = [2,7];
		
		public function Actions()
		{
		}
	}
}