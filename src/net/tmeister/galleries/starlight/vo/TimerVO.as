package net.tmeister.galleries.starlight.vo {
	/**
	 * @author Tmeister
	 */
	public class TimerVO {
		public var enabled : Boolean;
		public var timetoWait : Number;
		public var color : Number;
		public var alpha : Number;

		public function TimerVO(val : XMLList) : void {
			enabled = ( val.@enabled == "true" ) ? true : false;
			timetoWait = val.@timetoWait;
			color = val.@color;
			alpha = val.@alpha;
		}
	}
}
