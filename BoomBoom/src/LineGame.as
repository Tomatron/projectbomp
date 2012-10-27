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
	public class LineGame extends World
	{
		private var _ScoreText:Entity;
		private var _Line:LineEntity;
		private var _Selection:Ball;
		private var _Discs:Array;
		
		public function LineGame() 
		{
			super();
			
			_Discs = new Array();
			_Selection = null;			
			_Line = null;
		}
		
		/**
		 * Game start up.
		 * @author 
		 */
		override public function begin():void 
		{
			super.begin();
						
			var text:Text = new Text("Line Game!", 0, 0);
			_ScoreText = new Entity(0, 0, text);
			_ScoreText.layer = 10;			
			text.scale = 2.0;
			add(_ScoreText);
			
			
			_Line = new LineEntity();
			_Line.P0 = new Vector2(0, 0);
			_Line.P1 = new Vector2(0, 0);
			_Line.Thickness = 5.0;
			add(_Line);
			
			Reset();
		}
		
		/**
		 * Per-frame update.
		 * @author 
		 */
		override public function update():void 
		{
			super.update();
			
			var cursor:Vector2 = new Vector2(Input.mouseX, Input.mouseY);
			
			if (Input.mousePressed)
			{
				_Selection = null;
			}
			
			for (var i:int = 0; i < _Discs.length; ++i)
			{
				var disc:Ball = _Discs[i];
				if (disc.Contains(cursor) && _Selection == null)
				{
					disc._Color = 0xFFFF0000;
					_Selection = disc;
				}
				else
				{
					disc._Color = 0xFFFFFFFF;
				}
			}
			
			
			if (_Selection != null)
			{
				_Line.P0 = _Selection.Center;
				_Line.P1 = cursor;
				_Line.Alpha = 0.5;
				
				var len:Number = Math.sqrt((FP.width * FP.width) + (FP.height * FP.height));
				_Line.Thickness = FP.lerp(40.0, 1.0, FP.clamp(_Line.Length / len, 0.0, 1.0));
			}
		}
		
		
		public function Reset():void
		{
			FP.randomSeed = 0;	// randomizeSeed();		
			
			var radius:int = 20;
			for (var i:int = 0; i < 20; ++i)
			{
				var ball:Ball = Ball.CreateBall();
				ball.x = FP.rand(FP.width - (radius*2)) + (radius);
				ball.y = FP.rand(FP.height - (radius*2)) + (radius);
				ball._Color = 0x7FFFFFFF;
				ball._Alpha = 0.5;
				ball._Radius = radius;
				_Discs.push(ball);
				add(ball);
			}
		}
	}

}