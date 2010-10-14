package net.tmeister.utils {
	/**
	 * @author Tmeister
	 */
	public class ArrayUtil {
		public static function randomize(array : Array) : Array {
			var newArray : Array = new Array();
			while (array.length > 0) {
				var obj : Array = array.splice(Math.floor(Math.random() * array.length), 1);
				newArray.push(obj[0]);
			}
			return newArray;
		}
	}
}
