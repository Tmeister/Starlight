package net.tmeister.utils.helpers {
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	/**
	 * @author Tmeister
	 */
	public class DrawHelper {
		public static function drawRoundRec(width : Number = 200, height : Number = 200, background : Number = 0xd4d4d4, cornerRadius : Number = 5, backgroundAlpha : Number = 1, border : Number = 0xc4c4c4, borderAlpha : Number = 1) : Sprite {
			var tmp : Sprite = new Sprite();
			tmp.graphics.beginFill(background, backgroundAlpha);
			tmp.graphics.lineStyle(1, border, borderAlpha);
			tmp.graphics.drawRoundRect(0, 0, width, height, cornerRadius);
			tmp.graphics.endFill();
			return tmp;
		}

		public static function drawRec(width : Number = 200, height : Number = 200, background : Number = 0xd4d4d4, backgroundAlpha : Number = 1, border : Number = 0xc4c4c4, borderAlpha : Number = 1) : Sprite {
			var tmp : Sprite = new Sprite();
			tmp.graphics.beginFill(background, backgroundAlpha);
			tmp.graphics.lineStyle(1, border, borderAlpha);
			tmp.graphics.drawRect(0, 0, width, height);
			tmp.graphics.endFill();
			return tmp;
		}

		public static function createShadow(src : Sprite, color : Number) : void {
			var dropShadow : DropShadowFilter = new DropShadowFilter();
			dropShadow.distance = 2;
			dropShadow.blurX = 4;
			dropShadow.blurY = 4;
			dropShadow.color = color;
			dropShadow.strength = .25;
			src.filters = [dropShadow];
		}
		public static function drawPorcentLine(width:uint = 0, percentage:uint = 0, thickness:uint = 0, color:Number = 0, alpha:Number = .5):Sprite 
		{
			var lineWidth : uint = Math.ceil(( percentage * width ) / 100);
			var frontLine:Sprite = new Sprite();
			frontLine.graphics.lineStyle(thickness, color, alpha);
			frontLine.graphics.lineTo( lineWidth  , 0);
			return frontLine;
		}
	}
}
