package net.tmeister.galleries.starlight {
	import net.tmeister.events.NavEvent;
	import net.tmeister.galleries.starlight.vo.NavButtonVO;
	import net.tmeister.galleries.starlight.vo.PreloadVO;
	import net.tmeister.galleries.starlight.vo.ShadowVO;
	import net.tmeister.galleries.starlight.vo.StarlightVO;
	import net.tmeister.galleries.starlight.vo.TimerVO;
	import net.tmeister.utils.ArrayUtil;
	import net.tmeister.utils.NavManager;
	import net.tmeister.utils.helpers.DrawHelper;
	import net.tmeister.utils.helpers.LoaderHelper;
	import net.tmeister.utils.preload.Circle;

	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.*;
	import com.gskinner.motion.plugins.MotionBlurPlugin;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.system.System;
	import flash.utils.Timer;

	/**
	 * @author Tmeister
	 */
	public class Starlight extends Sprite {
		public static const NORMAL : String = "NORMAL";
		public static const RANDOM : String = "RANDOM";
		public static const REVERSE : String = "REVERSE";
		public static const NORMAL_FROM_BOTTOM : String = "NORMAL_FROM_BOTTOM";
		public static const RANDOM_FROM_BOTTOM : String = "RANDOM_FROM_BOTTOM";
		public static const REVERSE_FROM_BOTTOM : String = "REVERSE_FROM_BOTTOM";
		public static const NORMAL_FROM_TOP : String = "NORMAL_FROM_TOP";
		public static const RANDOM_FROM_TOP : String = "RANDOM_FROM_TOP";
		public static const REVERSE_FROM_TOP : String = "REVERSE_FROM_TOP";
		public static const NORMAL_FROM_LEFT : String = "NORMAL_FROM_LEFT";
		public static const RANDOM_FROM_LEFT : String = "RANDOM_FROM_LEFT";
		public static const REVERSE_FROM_LEFT : String = "REVERSE_FROM_LEFT";
		public static const NORMAL_FROM_RIGHT : String = "NORMAL_FROM_RIGHT";
		public static const RANDOM_FROM_RIGHT : String = "RANDOM_FROM_RIGHT";
		public static const REVERSE_FROM_RIGHT : String = "REVERSE_FROM_RIGHT";
		protected var _configFile : String;
		protected var _configXml : XML;
		private var mainBackground : Sprite;
		private var imageMask : Sprite;
		private var container : Sprite;
		private var nav : NavManager;
		private var images : XMLList;
		private var currentImage : XML;
		private var imagesCache : Object = {};
		private var displayImage : Loader = new Loader();
		private var slidesContainer : Sprite = new Sprite();
		private var oldSlidesContainer : Sprite;
		private var slides : Array;
		private var currentIndex : int;
		private var totalSlides : int;
		private var timerEnable : Boolean = false;
		private var timer : Timer;
		private var timerDelay : Number;
		private var timerRep : Number;
		private var timerInterval : Number = 50;
		private var timerCount : Number = 0;
		private var timerSlide : Sprite = new Sprite();
		private var timerAnimation : Sprite = new Sprite();
		private var preload : Sprite = new Sprite();
		private var preloadLine : Sprite = new Sprite;
		private var defaultTransition : String;
		private var defaultColumns : uint;
		private var defaultRows : uint;
		private var defaultTimeSlideEffect : Number;
		private var defaultTimeSlideEffectDelay : Number;
		private var starlightVO : StarlightVO;
		private var shadowVO : ShadowVO;
		private var timerVO : TimerVO;
		private var navButtonVO : NavButtonVO;
		private var preloadVO : PreloadVO;

		public function Starlight(configFile : String = null) {
			if ( configFile != null ) {
				_configFile = configFile;
			}
			if ( stage ) {
				create();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, create);
			}
		}

		public function create(e : Event = null) : void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			MotionBlurPlugin.install();
			var lhelper : LoaderHelper = new LoaderHelper(LoaderHelper.URLLOADER, configFile);
			lhelper.addEventListener(Event.COMPLETE, onConfigLoaded);
			lhelper.addEventListener(ProgressEvent.PROGRESS, onProgress);
			lhelper.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}

		private function onIOError(e : IOErrorEvent) : void {
			// trace("Error IOE " + e.toString());
		}

		private function onProgress(e : ProgressEvent) : void {
			// trace("onProgress " + e.bytesLoaded);
		}

		private function onConfigLoaded(e : Event) : void {
			_configXml = new XML(URLLoader(LoaderHelper(e.target).loader).data);
			starlightVO = new StarlightVO(_configXml);
			shadowVO = new ShadowVO(_configXml.shadow);
			timerVO = new TimerVO(_configXml.timer);
			navButtonVO = new NavButtonVO(_configXml.navButton);
			preloadVO = new PreloadVO(_configXml.preload);
			images = configXml.images.image;
			defaultTransition = starlightVO.defaultTransition;
			defaultColumns = starlightVO.defaultRows;
			defaultRows = starlightVO.defaultColumns;
			defaultTimeSlideEffect = starlightVO.defaultTimeSlideEffect;
			defaultTimeSlideEffectDelay = starlightVO.defaultTimeSlideEffectDelay;
			currentIndex = 0;
			currentImage = images[currentIndex];
			drawMainInterface();
			loadImage();
		}

		private function drawMainInterface() : void {
			createBackground();
			createContainer();
			createTimer();
			createPreload();
		}

		private function createPreload() : void {
			preload = new Sprite();
			preload.y = starlightVO.height + 5;
			preload.x = 5;
			preload.addChild(preloadLine);
			addChild(preload);
		}

		private function createTimer() : void {
			if ( timerVO.enabled) {
				timerEnable = true;
				timerDelay = (timerVO.timetoWait) ? timerVO.timetoWait : 5;
				timerRep = Math.ceil(( timerDelay * 1000 ) / timerInterval);
				timer = new Timer(timerInterval, timerRep);
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				timerAnimation.addChild(timerSlide);
				timerAnimation.x = starlightVO.width - 5;
				timerAnimation.y = starlightVO.height - 5;
				timerAnimation.buttonMode = true;
				timerAnimation.useHandCursor = true;
				timerAnimation.mouseChildren = false;
				timerAnimation.addEventListener(MouseEvent.CLICK, toogleTimer);
				addChild(timerAnimation);
			}
		}

		private function toogleTimer(event : MouseEvent) : void {
			if ( timerEnable ) {
				stopTimer();
			} else {
				timerEnable = true;
				timer.start();
			}
		}

		private function stopTimer() : void {
			if ( timerEnable ) {
				timerCount = 0;
				timer.reset();
				timer.stop();
				timerEnable = false;
				timerAnimation.removeChild(timerSlide);
				timerSlide = Circle.drawSegment(0, 0, 6, 0, 360, 1, timerVO.color, timerVO.alpha);
				timerAnimation.addChild(timerSlide);
			}
		}

		private function onTimer(event : TimerEvent) : void {
			var por : uint = ( ( timerCount++ * 360 ) / timerRep );
			timerAnimation.removeChild(timerSlide);
			timerSlide = Circle.drawSegment(0, 0, 6, 0, por, 1, timerVO.color, timerVO.alpha);
			timerAnimation.addChild(timerSlide);
		}

		private function onTimerComplete(e : TimerEvent) : void {
			timerCount = 0;
			timer.stop();
			timer.reset();
			currentIndex++;
			if ( images.length() == currentIndex ) {
				currentIndex = 0;
			}
			currentImage = images[currentIndex];
			nav.nextItem(currentIndex);
			loadImage();
		}

		private function createNav() : void {
			var src : Array = [];
			for (var i : int = 0; i < images.length(); i++) {
				var obj : Object = {};
				obj.index = i;
				src.push(obj);
			}
			nav = new NavManager();
			nav.type = NavManager.SQUARE;
			nav.options = navButtonVO;
			nav.src = src;
			nav.y = starlightVO.height - ( nav.height );
			nav.x = 10;
			nav.addEventListener(NavEvent.CLICK, navClick);
			addChild(nav);
		}

		private function navClick(e : NavEvent) : void {
			stopTimer();
			currentIndex = e.item.index;
			currentImage = images[currentIndex];
			loadImage();
		}

		private function createContainer() : void {
			container = new Sprite();
			imageMask = DrawHelper.drawRoundRec(starlightVO.width, starlightVO.height, Number(0xfff000), starlightVO.cornerRadius);
			imageMask.x = imageMask.y = 5;
			container.x = container.y = 5;
			container.mask = imageMask;
			container.addChild(slidesContainer);
			addChild(imageMask);
			addChild(container);
		}

		private function createBackground() : void {
			var back : Sprite = DrawHelper.drawRoundRec(starlightVO.width + 10, starlightVO.height + 10, starlightVO.backgroundColor, starlightVO.cornerRadius, starlightVO.backgroundAlpha, starlightVO.borderColor, starlightVO.borderAlpha);
			var innerBorder : Sprite = DrawHelper.drawRoundRec(starlightVO.width, starlightVO.height, starlightVO.backgroundColor, starlightVO.cornerRadius, 0, starlightVO.borderColor, starlightVO.borderAlpha);
			if ( starlightVO.shadow == true ) {
				createBackgroundShadow(back, shadowVO.color);
			}
			mainBackground = DrawHelper.drawRec(back.width, back.height, starlightVO.swfBackgroundColor, 1, starlightVO.swfBackgroundColor, 1);
			addChild(mainBackground);
			innerBorder.y = innerBorder.x = 5;
			addChild(back);
			addChild(innerBorder);
		}

		private function createBackgroundShadow(src : Sprite, color : Number) : void {
			var dropShadow : DropShadowFilter = new DropShadowFilter();
			dropShadow.distance = shadowVO.distance;
			dropShadow.blurX = shadowVO.blurX;
			dropShadow.blurY = shadowVO.blurY;
			dropShadow.strength = shadowVO.alpha;
			dropShadow.angle = shadowVO.angle;
			dropShadow.color = color;
			src.filters = [dropShadow];
		}

		private function loadImage() : void {
			oldSlidesContainer = slidesContainer;
			if ( imagesCache[currentImage.@src] != null ) {
				displayImage = imagesCache[currentImage.@src];
				splitImage();
			} else {
				var lh : LoaderHelper = new LoaderHelper(LoaderHelper.LOADER, currentImage.@src);
				lh.addEventListener(Event.COMPLETE, onImageLoaded);
				lh.addEventListener(ProgressEvent.PROGRESS, onImageProgress);
			}
		}

		private function onImageProgress(e : ProgressEvent) : void {
			var por : uint = ( e.bytesLoaded * 100 ) / e.bytesTotal;
			preload.removeChild(preloadLine);
			preloadLine = DrawHelper.drawPorcentLine(starlightVO.width - 10, por, preloadVO.thickness, preloadVO.color, preloadVO.alpha);
			preload.addChild(preloadLine);
		}

		private function onImageLoaded(e : Event) : void {
			var lh : LoaderHelper = LoaderHelper(e.target);
			displayImage = lh.loader;
			imagesCache[currentImage.@src] = displayImage;
			lh.flushMemory();
			preloadLine.alpha = 0;
			splitImage();
		}

		private function splitImage() : void {
			var columns : uint = ( String(images[currentIndex].@rows).length  ) ? uint(images[currentIndex].@rows) : defaultColumns;
			var rows : uint = ( String(images[currentIndex].@columns).length ) ? uint(images[currentIndex].@columns) : defaultRows;
			var transition : String = ( String(images[currentIndex].@transition).length ) ? images[currentIndex].@transition : defaultTransition;
			var w : int = Math.ceil(displayImage.width / rows);
			var h : int = Math.ceil(displayImage.height / columns);
			slides = [];
			totalSlides = columns * rows;
			slidesContainer = new Sprite();
			container.addChild(slidesContainer);
			for (var i : int = 0;i < columns; i++) {
				for (var j : int = 0;j < rows; j++) {
					var bitmapData : BitmapData = new BitmapData(w, h, true, 0x00FFFFFF);
					var bitmap : Bitmap = new Bitmap(bitmapData);
					var mat : Matrix = displayImage.transform.matrix;
					var point : Point = new Point(displayImage.x + w * j + 0 * j, displayImage.y + h * i + 0 * i);
					var slide : Sprite = new Sprite();
					mat.translate(-w * j, -h * i);
					bitmapData.draw(displayImage, mat);
					slide.alpha = 0;
					slide.addChild(bitmap);
					slide.x = point.x;
					slide.y = point.y;
					slides.push(slide);
					slidesContainer.addChild(slide);
				}
			}
			createTransition(transition);
			System.gc();
		}

		private function createTransition(type : String) : void {
			var src : Array;
			switch(type) {
				case NORMAL:
				case NORMAL_FROM_BOTTOM:
				case NORMAL_FROM_TOP:
				case NORMAL_FROM_LEFT:
				case NORMAL_FROM_RIGHT:
					src = slides;
					break;
				case RANDOM:
				case RANDOM_FROM_BOTTOM:
				case RANDOM_FROM_TOP:
				case RANDOM_FROM_LEFT:
				case RANDOM_FROM_RIGHT:
					src = ArrayUtil.randomize(slides);
					break;
				case REVERSE:
				case REVERSE_FROM_BOTTOM:
				case REVERSE_FROM_TOP:
				case REVERSE_FROM_LEFT:
				case REVERSE_FROM_RIGHT:
					src = slides.reverse();
					break;
					src = slides;
				default:
					return;
			}
			var d : int = 0;
			var effectTime : Number = ( String(images[currentIndex].@timeSlideEffect).length ) ? Number(images[currentIndex].@timeSlideEffect) : defaultTimeSlideEffect;
			var effectTimeDelay : Number = ( String(images[currentIndex].@timeSlideEffectDelay).length ) ? Number(images[currentIndex].@timeSlideEffectDelay) : defaultTimeSlideEffectDelay;
			for (var i : int = 0; i < src.length; i++) {
				var slide : Sprite = src[i] as Sprite;
				var origY : Number;
				var origX : Number;
				var props : Object = {};
				switch(type) {
					case NORMAL_FROM_BOTTOM:
					case REVERSE_FROM_BOTTOM:
					case RANDOM_FROM_BOTTOM:
						origY = slide.y;
						slide.y = displayImage.height;
						props.alpha = 1;
						props.y = origY;
						break;
					case NORMAL_FROM_TOP:
					case REVERSE_FROM_TOP:
					case RANDOM_FROM_TOP:
						origY = slide.y;
						slide.y = -displayImage.height;
						props.alpha = 1;
						props.y = origY;
						break;
					case NORMAL_FROM_LEFT:
					case REVERSE_FROM_LEFT:
					case RANDOM_FROM_LEFT:
						origX = slide.x;
						slide.x = -displayImage.width;
						props.alpha = 1;
						props.x = origX;
						break;
					case NORMAL_FROM_RIGHT:
					case REVERSE_FROM_RIGHT:
					case RANDOM_FROM_RIGHT:
						origX = slide.x;
						slide.x = displayImage.width;
						props.alpha = 1;
						props.x = origX;
						break;
					default:
						props.alpha = 1;
				}
				var blurEnabled : Boolean = (configXml.@blurEffect == "true") ? true : false;
				new GTween(slide, effectTime, props, {ease:Sine.easeOut, delay:(d++ * effectTimeDelay), dispatchEvents:true, onComplete:cleanOldImage, data:{id:d}}, {MotionBlurEnabled:blurEnabled});
			}
		}

		private function cleanOldImage(e : GTween) : void {
			if ( totalSlides == e.data.id && oldSlidesContainer != null ) {
				container.removeChild(oldSlidesContainer);
				if ( timerEnable && timer) {
					timer.start();
				}
			}
			if ( nav == null ) {
				createNav();
			}
		}

		public function get configFile() : String {
			return _configFile;
		}

		public function set configFile(configFile : String) : void {
			_configFile = configFile;
		}

		public function get configXml() : XML {
			return _configXml;
		}
	}
}