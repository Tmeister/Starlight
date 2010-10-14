package net.tmeister.galleries.starlight.vo {
	/**
	 * @author Tmeister
	 */
	public class ShadowVO {
		public var color : Number;
		public var alpha : Number;
		public var distance : Number;
		public var blurX : Number;
		public var blurY : Number;
		public var angle : Number;

		public function ShadowVO(val : XMLList) : void {
			color = val.@color;
			alpha = val.@alpha;
			distance = val.@distance;
			blurX = val.@blurX;
			blurY = val.@blurY;
			angle = val.@angle;
		}
	}
}
