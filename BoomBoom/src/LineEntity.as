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
	public class LineEntity extends Entity
	{
		var _P0:Vector2;
		var _P1:Vector2;
		public var Thickness:Number;
		public var Alpha:Number;
		public var Color:uint;
		
		public function set P0(val:Vector2):void { _P0 = val; }
		public function get P0():Vector2 { return _P0; }
		public function set P1(val:Vector2):void { _P1 = val; }
		public function get P1():Vector2 { return _P1; }
		public function get Length():Number { return Vector2.Subtract(_P0, _P1).Length(); }
		
		public function LineEntity(x:Number = 0, y:Number = 0, graphic:Graphic = null, mask:Mask = null)
		{
			super(x, y, graphic, mask);
			
			Alpha = 1.0;
			Color = 0xFFFFFFFF;
			Thickness = 1.0;
		}
		
		override public function render():void 
		{
			Draw.linePlus(_P0.x, _P0.y, _P1.x, _P1.y, Color, Alpha, Thickness);
		}
	}
}