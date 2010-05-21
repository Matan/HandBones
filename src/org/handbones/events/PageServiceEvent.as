package org.handbones.events 
{
	import mu.utils.ToStr;

	import org.handbones.core.IPage;
	import org.handbones.base.PageSettings;

	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class PageServiceEvent extends Event {

		public static const LOADING : String = "LOADING";
		public static const PROGRESS : String = "PROGRESS";
		public static const LOADED : String = "LOADED";
		public static const ERROR : String = "ERROR";

		protected var _pageSettings : PageSettings;
		protected var _message : String;
		protected var _percentageLoaded : Number;
		protected var _page : IPage;

		public function PageServiceEvent(type : String, pageSettings : PageSettings, message : String = "", percentageLoaded : Number = 0, page : IPage = null) {
			super(type);
			_pageSettings = pageSettings;
			_message = message;
			_percentageLoaded = percentageLoaded;
			_page = page;
		}

		public function get pageSettings() : PageSettings {
			return _pageSettings;
		}

		public function get message() : String {
			return _message;
		}

		public function get percentageLoaded() : Number {
			return _percentageLoaded;
		}

		public function get page() : IPage {
			return _page;
		}

		override public function toString() : String {
			return new ToStr(this).toString();
		}
	}
}
