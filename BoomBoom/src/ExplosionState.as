package  
{
	//import Ball;
	
	/**
	 * ...
	 * @author 
	 */
	public class ExplosionState 
	{
		private var _Ball: Ball;
		private var _Time: Number = 0.0;
			
						
		public static var MAX_EXP_RADIUS:Number  = 100;	// max explosion radius
		public static var EXP_EXPAND_TIME:Number = 0.75;	// time to interp from 0 to max rad
		public static var EXP_LINGER:Number = 1.5;		// time to linger at max rad
		public static var EXP_SHRINK_TIME:Number = 0.5;	// time to shrink
		
		private static var STATE_EXPAND:int = 0;
		private static var STATE_LINGER:int = 1;
		private static var STATE_HIDE:int = 2;
		private var _State:int = STATE_EXPAND;
		
		public function ExplosionState(ball: Ball) 
		{
			_Ball = ball;		
		}
		
		/*
		public function get Ball(): Ball
		{
			return _Ball;
		}*/
		public function GetBall(): Ball
		{
			return _Ball;
		}
		
		
		public function OnFinishExpand() : void
		{
			(_Ball.world as GameWorld).OnFinishExpand(this);
		}
		
		public function OnFinishLinger(): void
		{
			(_Ball.world as GameWorld).OnFinishLinger(this);
		}
		
		public function OnFinishFadeout(): void
		{
			(_Ball.world as GameWorld).OnFinishFadeout(this);
		}
		
		// Returns if it is done
		
		public function Update(dt:Number): Boolean
		{
			if (_State == STATE_EXPAND)
			{
				//_Ball._Radius = Math.min(MAX_EXP_RADIUS, _Ball._Radius + ((MAX_EXP_RADIUS / EXP_EXPAND_TIME)  * dt));
				
				if (_Ball._Radius == MAX_EXP_RADIUS)
				{
					_State = STATE_LINGER;
				}
			}
			else if (_State == STATE_LINGER)
			{
				_Time += dt;
				_Ball._Alpha -= dt
				if (_Time >= EXP_LINGER)
				{
					_State = STATE_HIDE
				}
				
			}
			else if (_State == STATE_HIDE)
			{
				//_Ball._Radius = Math.max(0, _Ball._Radius - ((MAX_EXP_RADIUS / EXP_SHRINK_TIME)  * dt));
			}
			
			return !(_State == STATE_HIDE && _Ball._Radius == 0.0);
		}
	}
}