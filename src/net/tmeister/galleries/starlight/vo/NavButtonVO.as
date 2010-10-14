package net.tmeister.galleries.starlight.vo {
	/**
	 * @author Tmeister
	 */
	public class NavButtonVO {
		public var activeColor : Number;
		public var activeAlpha : Number;
		public var activeBorderColor : Number;
		public var activeBorderAlpha : Number;
		public var inactiveColor : Number;
		public var inactiveAlpha : Number;
		public var inactiveBorderColor : Number;
		public var inactiveBorderAlpha : Number;

		public function NavButtonVO(val : XMLList) : void {
			activeColor = val.@activeColor;
			activeAlpha = val.@activeAlpha;
			activeBorderColor = val.@activeBorderColor;
			activeBorderAlpha = val.@activeBorderAlpha;
			inactiveColor = val.@inactiveColor;
			inactiveAlpha = val.@inactiveAlpha;
			inactiveBorderColor = val.@inactiveBorderColor;
			inactiveBorderAlpha = val.@inactiveBorderAlpha;
		}
	}
}
