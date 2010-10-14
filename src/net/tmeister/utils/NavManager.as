package net.tmeister.utils {
	import net.tmeister.events.NavEvent;
	import net.tmeister.galleries.starlight.vo.NavButtonVO;
	import net.tmeister.utils.helpers.DrawHelper;

	import com.gskinner.motion.GTween;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Tmeister
	 */
	public class NavManager extends Sprite {
		public static const SQUARE : String = "square";
		public static const CIRCLE : String = "circle";
		public static const SQUARE_THUMB : String = "squareThumb";
		public static const CIRCLE_THUMB : String = "circleThumb";
		protected var _type : String;
		protected var _src : Array;
		protected var _options : NavButtonVO;
		private var items : Array;
		private var currentItem : Sprite;
		private var activeItem : Sprite;

		public function NavManager(type : String = null, src : Array = null, options : NavButtonVO = null) {
			if ( type != null ) {
				this.type = type;
			}
			if ( src != null ) {
				this.src = src;
			}
			if ( options != null ) {
				this.options = options;
			}
		}

		private function create() : void {
			if ( type == null) {
				throw new Error("Type no valid!");
			}
			items = [];
			activeItem = DrawHelper.drawRec(10, 10, options.activeColor, options.activeAlpha, options.activeBorderColor, options.activeBorderAlpha);
			addChild(activeItem);
			var x : Number = 0;
			var box : Sprite;
			for (var i : int = 0; i < src.length; i++) {
				box = DrawHelper.drawRec(10, 10, options.inactiveColor, options.inactiveAlpha, options.inactiveBorderColor, options.inactiveBorderAlpha);
				currentItem = (i == 0) ? box : currentItem;
				box.name = src[i].index;
				box.buttonMode = true;
				box.alpha = 0;
				box.useHandCursor = true;
				box.addEventListener(MouseEvent.CLICK, boxClick);
				box.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
				box.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
				DrawHelper.createShadow(box, 0x000000);
				box.x = x;
				x += box.width + 5;
				items.push(box);
				addChild(box);
			}
			startInitAnimation();
		}

		private function startInitAnimation() : void {
			var i : int;
			for each (var box : Sprite in items) {
				new GTween(box, .4, {alpha:1}, {delay:1 * i++, useFrames:true});
			}
		}

		private function mouseOut(e : MouseEvent) : void {
		}

		private function mouseOver(e : MouseEvent) : void {
		}

		private function boxClick(e : MouseEvent) : void {
			var box : Sprite = Sprite(e.target);
			if ( box != currentItem ) {
				new GTween(activeItem, .3, {x:box.x}, null, {MotionBlurEnabled:true});
				currentItem = box;
				var nEvnt : NavEvent = new NavEvent(NavEvent.CLICK);
				nEvnt.item = src[ Number(box.name) ];
				dispatchEvent(nEvnt);
			}
		}

		public function nextItem(index : Number) : void {
			var box : Sprite = items[index];
			if ( box != currentItem ) {
				new GTween(activeItem, .3, {x:box.x}, null, {MotionBlurEnabled:true});
				currentItem = box;
			}
		}

		public function get type() : String {
			return _type;
		}

		public function set type(type : String) : void {
			_type = type;
		}

		public function get src() : Array {
			return _src;
		}

		public function set src(src : Array) : void {
			_src = src;
			create();
		}

		public function get options() : NavButtonVO {
			return _options;
		}

		public function set options(options : NavButtonVO) : void {
			_options = options;
		}
	}
}
