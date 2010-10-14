package net.tmeister.utils.preload {
	import flash.display.Sprite;

	/**
	 * ...
	 * @author Enrique Chavez
	 */
	public class Circle extends Sprite {
		public static function drawSegment(x : Number, y : Number, r : Number, aStart : Number, aEnd : Number, step : Number = 1, color : Number = 0x9FC604, alpha : Number = .75) : Sprite {
			var degreesPerRadian : Number = Math.PI / 180;
			var container : Sprite = new Sprite();
			aStart *= degreesPerRadian;
			aEnd *= degreesPerRadian;
			step *= degreesPerRadian;
			container.graphics.beginFill(color, alpha);
			container.graphics.moveTo(x, y);
			for (var theta : Number = aStart; theta < aEnd; theta += Math.min(step, aEnd - theta)) {
				container.graphics.lineTo(x + r * Math.cos(theta), y + r * Math.sin(theta));
			}
			container.graphics.lineTo(x + r * Math.cos(aEnd), y + r * Math.sin(aEnd));
			container.graphics.lineTo(x, y);
			container.graphics.endFill();
			return container;
		}
	}
}