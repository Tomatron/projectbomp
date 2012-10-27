package  
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Input;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import TJ.Vector2;
	/**
	 * ...
	 * @author 
	 */
	public class Ball extends Entity
	{
		public var _Direction: Vector2 = new Vector2(0, 0);
		public var _Radius: Number = 30;
		public var _Color: uint = 0xFFFFFF00;
		public var _Speed: Number = 25;
		public var _Alpha: Number = 1.0;
		
		public function get Center():Vector2 { return new Vector2(x,y); }
		
		public function Ball(x:Number = 0, y:Number = 0, graphic:Graphic = null, mask:Mask = null)
		{
			super(x, y, graphic, mask);
		}
		
		/**
		 * 
		 * @return newly created Ball entity.
		 */
		public static function CreateBall(): Ball
		{
			var bitmap:BitmapData = new BitmapData(16, 16, true, 0xFFFFFFFF);
			
			var image:Image = new Image(bitmap);
			
			var entity:Ball = new Ball(0, 0, image);

			return entity;
		}
		
		override public function render():void 
		{
			//super.render();
			
			Draw.circlePlus(x, y, _Radius, _Color, _Alpha);
			Draw.line(this.x, this.y, this.x + (_Direction.x * _Radius), this.y + (_Direction.y * _Radius), 0xFFFF0000);
		}
		
		public function Contains(point: Vector2):Boolean
		{
			var pos:Vector2 = new Vector2(x, y);
			var delta = Vector2.Subtract(pos, point);
			
			return (delta.Length() <= _Radius);
		}
		
		override public function update():void
		{
			super.update();
			
			/*
			var curPos: Vector2 = new Vector2(x, y);
			var mousePos: Vector2 = new Vector2(Input.mouseX, Input.mouseY);
			
			var dir: Vector2 = Vector2.Subtract(mousePos, curPos);
			var angle: Number = dir.Angle();
			
			var dirAngle: Number = _Direction.Angle();			
			var angleBetween: Number = Vector2.AngleBetween(_Direction, dir) * Vector2.Cross(_Direction, dir);
			
			angle = FP.clamp(angleBetween, -0.025, 0.025);
			_Direction.Rotate(angle);
			
			moveTowards(_Direction.x + curPos.x, _Direction.y + curPos.y, 10);
			*/
			
			// Reflect off edges.
			if (x < 0 || x > FP.width)
			{
				_Direction.x *= -1.0;
			}
			
			if (y < 0 || y > FP.height)
			{
				_Direction.y *= -1.0;
			}
			
			// Move foward
			moveTowards(_Direction.x + x, _Direction.y + y, _Speed);
		}
	}

}