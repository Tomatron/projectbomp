package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author 
	 */
	public class Main extends Engine 
	{
		
		public function Main():void 
		{
			super(800, 600);
		}
		
		override public function init():void 
		{
			trace("initialized Engine");
			
			FP.world = new LineGame();
			
			super.init();
		}
	}
	
}