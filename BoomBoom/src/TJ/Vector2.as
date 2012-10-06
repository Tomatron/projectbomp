package TJ 
{
	/**
	 * ...
	 * @author 
	 */
	public class Vector2 
	{
		public var y:Number;
		public var x:Number;
		
		public function Vector2(_x:Number = 0, _y:Number = 0)
		{
			x = _x;
			y = _y;
		}
		
		// Length-Squared
		public function LengthSq() : Number
		{	
			return (x * x) + (y * y);
		}
		
		public function Normalize(): void
		{
			var len: Number = Length();
			if (len > 0)
			{
				x /= len;
				y /= len;
			}
			else 
			{
				x = 0;
				y = 0;
			}
		}
		
		// Length
		public function Length() : Number
		{
			return Math.sqrt((x * x) + (y * y));
		}
		
		public function Angle(): Number
		{
			return Math.atan2(y, x);
		}
		
		public function Rotate(angle: Number): void
		{
			var len: Number = Length();
			var a: Number = Angle();
			
			x = len * Math.cos(a + angle);
			y = len * Math.sin(a + angle);
		}
		
		/**
		 * Dot product.
		 * @param	v0
		 * @param	v1
		 * @return
		 */
		public static function Dot(v0:Vector2, v1: Vector2) : Number
		{
			return (v0.x * v1.x) + (v0.y * v1.y);
		}
		
		public static function Subtract(v0: Vector2, v1: Vector2) : Vector2
		{
			return new Vector2(v0.x - v1.x, v0.y - v1.y);
		}
		
		public static function Add(v0: Vector2, v1: Vector2) : Vector2
		{
			return new Vector2(v0.x + v1.x, v0.y + v1.y);
		}
		
		public static function AngleBetween(v0:Vector2, v1: Vector2) : Number
		{
			return Math.acos(Dot(v0, v1)/(v0.Length() * v1.Length()));
		}
		
		public static function Cross(v0: Vector2, v1: Vector2) : Number
		{
			return (v0.x * v1.y) - (v0.y * v1.x);
		}
	}

}