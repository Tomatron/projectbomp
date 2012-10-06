package  
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import TJ.Vector2;
	
	
	/**
	 * ...
	 * @author 
	 */
	public class GameWorld extends World
	{
		private var _Balls:Dictionary;		
		private var _Explosions:Dictionary;
		private var _DoneExplosions:Dictionary;
		private var _BallToExplosion:Dictionary;
		
		private var _Score:int = 0;
		private var _ScoreMax:int = 5;
		private var _ScoreText:Entity;
		
		private var LAYER_BALLS:int = 10;
		private var LAYER_SCORE:int = 5;
		
		public static const STATE_IDLE: int = 0;
		public static const STATE_PERFORM_MOVE: int = 1;
		public static const STATE_WAITING_TO_FINISH: int = 2;
		private var _State: int = STATE_IDLE;
		
		
		public function GameWorld() 
		{
			_Balls = new Dictionary();
			_Explosions = new Dictionary();
			_BallToExplosion = new Dictionary();
			_DoneExplosions = new Dictionary();		
			
			super();		
		}
		
		private function GoToState(state:int)
		{
			_State = state;
		}
		
		override public function begin():void 
		{
			super.begin();
			
			var text:Text = new Text("_", 0, 0);
			_ScoreText = new Entity(0, 0, text);
			_ScoreText.layer = LAYER_SCORE;			
			text.scale = 2.0;
			add(_ScoreText);
			
			Reset();
		}
		
		protected function SetScore(score:int): void 
		{
			_Score = score;
			(_ScoreText.graphic as Text).text = _Score.toString() + " / " + _ScoreMax.toString();
		}
		
		public function Reset():void
		{
			FP.randomizeSeed();		
			
			// reset score
			SetScore(0);
			
			GoToState(STATE_PERFORM_MOVE);		
			
			// Cleanup existing balls.
			for each(var ball:Ball in _Balls)
			{	
				remove(ball);
				_Balls[ball] = null;
				delete _Balls[ball];
				ball = null;
			}
				
			
			for (var i:int = 0; i < 20; ++i)
			{
				var ball:Ball = Ball.CreateBall();
				ball.x = FP.rand(FP.width);
				ball.y = FP.rand(FP.height);
				ball._Color = FP.rand(0xffffffff);
				ball.layer = LAYER_BALLS;
				
				// [0,2pi]
				var dir: Vector2 = new Vector2(1, 0);
				dir.Rotate(FP.rand(100) / 100 * Math.PI * 2);
				dir.Normalize();
				
				ball._Direction = dir;
				ball._Radius = 15;
				add(ball);
				_Balls[ball] = ball;
			}
		}
		
		
		// Turns ball into explosion
		protected function MakeExplosion(ball: Ball): ExplosionState
		{
			ball._Color = 0xFFFFFFFF;
			ball._Direction.x = 0;
			ball._Direction.y = 0;
			
			var state: ExplosionState = new ExplosionState(ball);
			
			// Attach tweens
			var tween: VarTween = new VarTween(state.OnFinishExpand);
			tween.tween(ball, "_Radius", 100, 1);
			addTween(tween, true);
			
			tween = new VarTween();
			tween.tween(state.GetBall(), "_Alpha", 0.5, 1.0, Ease.expoOut);
			addTween(tween, true);
			
			//var colorTween:ColorTween = new ColorTween ();
			//colorTween.tween()
			
			return state;
		}
		
		public function OnFinishExpand(state: ExplosionState) : void
		{
			//var tween: VarTween = new VarTween(state.OnFinishLinger);
			var wait: NumTween = new NumTween(state.OnFinishLinger);
			wait.tween(0, 0, 0.5);
			//tween.tween(ball._Ball, "_Alpha", 100, 1);
			addTween(wait, true);
			
			
		}
		
		public function OnFinishLinger(state: ExplosionState) : void
		{
			var tween: VarTween = new VarTween(state.OnFinishFadeout);
			tween.tween(state.GetBall(), "_Radius", 0, 1);
			//tween.tween(state.GetBall(), "_Alpha", 0, 2);
			addTween(tween, true);			
		}
		
		public function OnFinishFadeout(state: ExplosionState) : void
		{
			// remove!
			remove(state.GetBall());
			_Explosions[state.GetBall()] = null;
			delete _Explosions[state.GetBall()];
			state = null;
		}
		
		override public function update():void 
		{
			super.update();
						
			if (_State == STATE_PERFORM_MOVE && Input.mouseReleased)
			{
				// create the explosion and lock input...
				var exp: Ball = Ball.CreateBall();
				exp.x = Input.mouseX;
				exp.y = Input.mouseY;				
				exp._Radius = 0;				

				 _Explosions[exp] = MakeExplosion(exp);
				add(exp);		
				
				GoToState(STATE_WAITING_TO_FINISH);
			}
			
			var explosions:int = 0;
					
			for (var key:Object in _Explosions)
			{
				explosions++;
				
				var exp:Ball = key as Ball;
				
				// update explosion radius...
				var expState: ExplosionState = _Explosions[exp];
				
				//if (!expState.Update(FP.elapsed))
				//{
				//	_DoneExplosions[exp] = expState;
				//}
				
				//exp._Radius = Math.min(MAX_EXP_RADIUS, exp._Radius + EXP_RADIUS_SPEED * FP.elapsed);
				
				for each (var ball:Ball in _Balls)
				{
					var delta:Vector2 = new Vector2(exp.x - ball.x, exp.y - ball.y);
					
					if(delta.Length() <= (exp._Radius + ball._Radius))
					{
						_BallToExplosion[ball] = ball;
					}
				}				
			}
			
			// cleanup explosions
			/*for(var k:Object in _DoneExplosions)
			{	
				var exp:Ball = k as Ball;
				remove(exp);
				_Explosions[exp] = null;
				delete _Explosions[exp];
				_DoneExplosions[exp] = null;
				delete _DoneExplosions[exp];
			}*/
			
			// Convert the hit balls to explosions.
			for each(var ball:Ball in _BallToExplosion)
			{				
				//ball._Radius = 100;
				SetScore(_Score + 1);
				
				// Remove from ball list
				_Balls[ball] = null;
				delete _Balls[ball];
				_BallToExplosion[ball] = null;
				delete _BallToExplosion[ball];
				
				// Add to explosion
				_Explosions[ball] = MakeExplosion(ball);
			}		
			
			if (_State == STATE_WAITING_TO_FINISH && explosions == 0)
			{
				Reset();
			}
		}	
		
	}

}