package net.tmeister.events {
	import flash.events.Event;

	/**
	 * @author Tmeister
	 */
	public class NavEvent extends Event {
		public static const CLICK : String = "NavClick";
		public var item : Object;

		public function NavEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
