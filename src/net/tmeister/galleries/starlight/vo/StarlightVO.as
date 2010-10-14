package net.tmeister.galleries.starlight.vo {
	/**
	 * @author Tmeister
	 */
	public class StarlightVO {
		public var width : Number;
		public var height : Number;
		public var swfBackgroundColor : Number;
		public var backgroundColor : Number;
		public var backgroundAlpha : Number;
		public var cornerRadius : Number;
		public var borderColor : Number;
		public var borderAlpha : Number;
		public var defaultTransition : String;
		public var defaultColumns : Number;
		public var defaultRows : Number;
		public var defaultTimeSlideEffect : Number;
		public var defaultTimeSlideEffectDelay : Number;
		public var shadow : Boolean;
		public var blurEffect : Boolean;

		public function StarlightVO(val : XML) : void {
			width = val.@width;
			height = val.@height;
			swfBackgroundColor = val.@swfBackgroundColor;
			backgroundColor = val.@backgroundColor;
			backgroundAlpha = val.@backgroundAlpha;
			cornerRadius = val.@cornerRadius;
			borderColor = val.@borderColor;
			borderAlpha = val.@borderAlpha;
			defaultTransition = val.@defaultTransition;
			defaultColumns = val.@defaultColumns;
			defaultRows = val.@defaultRows;
			defaultTimeSlideEffect = val.@defaultTimeSlideEffect;
			defaultTimeSlideEffectDelay = val.@defaultTimeSlideEffectDelay;
			shadow = val.@shadow;
			blurEffect = val.@blurEffect;
		}
	}
}
