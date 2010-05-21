package org.handbones.model 
{
	import org.handbones.events.SizeEvent;
	import org.robotlegs.mvcs.Actor;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author Matan Uberstein
	 */
	public class SizeModel extends Actor 
	{
		protected var _contextView : DisplayObjectContainer;

		protected var _width : Number;
		protected var _height : Number;
		protected var _center : Point;

		protected var _pageWidth : Number;
		protected var _pageHeight : Number;
		protected var _pageCenter : Point;

		[Inject]

		public function SizeModel(contextView : DisplayObjectContainer)
		{
			_contextView = contextView;
			
			_center = new Point();
			_pageCenter = new Point();
			
			//Breaking the rules, but it's needed for auto size updating
			eventMap.mapListener(_contextView.stage, Event.RESIZE, stage_resize_handler, Event);
		}

		public function updateSize(width : Number, height : Number) : void 
		{
			_width = width;
			_height = height;
			
			_center.x = Math.round(_width / 2);
			_center.y = Math.round(_height / 2);
			
			dispatchSizeEvent(SizeEvent.RESIZE);
		}

		public function updatePageSize(width : Number, height : Number) : void 
		{
			_pageWidth = width;
			_pageHeight = height;
			
			_pageCenter.x = Math.round(_pageWidth / 2);
			_pageCenter.y = Math.round(_pageHeight / 2);
			
			dispatchSizeEvent(SizeEvent.PAGE_RESIZE);
		}

		public function get width() : Number 
		{
			return _width;
		}

		public function get height() : Number 
		{
			return _height;
		}

		public function get center() : Point 
		{
			return _center;
		}

		public function get pageWidth() : Number 
		{
			return _pageWidth;
		}

		public function get pageHeight() : Number 
		{
			return _pageHeight;
		}

		public function get pageCenter() : Point 
		{
			return _pageCenter;
		}

		protected function dispatchSizeEvent(type : String) : void 
		{
			var event : SizeEvent = new SizeEvent(type);
			
			event.width = _width;			event.height = _height;			event.center = _center;
			
			event.pageWidth = _pageWidth;			event.pageHeight = _pageHeight;			event.pageCenter = _pageCenter;
			
			dispatch(event);
		}

		protected function stage_resize_handler(event : Event) : void 
		{
			updateSize(_contextView.stage.stageWidth, _contextView.stage.stageHeight);
		}
	}
}
