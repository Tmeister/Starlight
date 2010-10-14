package 
{
	import net.tmeister.galleries.starlight.Starlight;

	import flash.display.Sprite;
	
	/**
	 * @author Tmeister
	 */
	public class Main extends Sprite 
	{
		private var starlight:Starlight;
		public function Main() 
		{
			starlight = new Starlight("http://klr20mg.com/starlight/config.xml");
			starlight.x = 20;
			starlight.y = 20;
			addChild(starlight);
		}
	}
}
