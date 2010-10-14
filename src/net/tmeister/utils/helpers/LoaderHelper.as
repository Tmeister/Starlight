package net.tmeister.utils.helpers {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;

	/**
	 * @author Tmeister
	 */
	public class LoaderHelper extends EventDispatcher {
		public static const URLLOADER : String = "URLLOADER";
		public static const LOADER : String = "LOADER";
		public static const STREAMLOADER : String = "STREAMLOADER";
		protected var _type : String;
		protected var _url : String;
		protected var _urlLoader : URLLoader;
		protected var _loader : Loader;

		public function LoaderHelper(type : String, url : String) {
			_type = type;
			_url = url;
			switch(type) {
				case URLLOADER:
					getUrlLoader();
					break;
				case LOADER:
					getLoader();
					break;
				case STREAMLOADER:
					break;
				default:
					throw new Error("type not supported.");
			}
		}

		private function getLoader() : void {
			_loader = new Loader();
			_loader.load(new URLRequest(url));
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}

		private function getUrlLoader() : void {
			_urlLoader = new URLLoader(new URLRequest(url));
			_urlLoader.addEventListener(Event.COMPLETE, onUrlLoaderComplete);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}

		private function onSecurityError(e : SecurityErrorEvent) : void {
			dispatchEvent(e);
			throw new Error("onSecurityError");
		}

		private function onIOError(e : IOErrorEvent) : void {
			dispatchEvent(e);
			throw new Error("onIOError");
		}

		private function onUrlLoaderComplete(e : Event) : void {
			dispatchEvent(e);
		}

		private function onLoaderComplete(e : Event) : void {
			dispatchEvent(e);
		}

		public function onProgress(e : ProgressEvent) : void {
			dispatchEvent(e);
		}

		public function get type() : String {
			return _type;
		}

		public function get url() : String {
			return _url;
		}

		public function flushMemory() : void {
			switch(type) {
				case URLLOADER:
					_urlLoader = null;
					break;
				case LOADER:
					_loader = null;
					break;
				case STREAMLOADER:
					break;
				default:
					throw new Error("Can't find a valid type");
			}
			System.gc();
		}

		public function get loader() : * {
			switch(type) {
				case URLLOADER:
					return _urlLoader;
					break;
				case LOADER:
					return _loader;
					break;
				case STREAMLOADER:
					break;
				default:
					throw new Error("Can't find a valid type");
			}
		}
	}
}