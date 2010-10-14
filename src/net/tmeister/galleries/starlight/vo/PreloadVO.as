package net.tmeister.galleries.starlight.vo {
	/**
	 * @author Tmeister
	 */
	public class PreloadVO {
		public var color : Number;
		public var alpha : Number;
		public var thickness : Number;

		public function PreloadVO(val : XMLList) : void {
			color = val.@color;
			alpha = val.@alpha;
			thickness = val.@thickness;
		}
	}
}
