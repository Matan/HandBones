package org.handbones.events {
	import flash.net.URLVariables;
	import org.handbones.base.Action;
	import org.handbones.core.IPage;
	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class NavigatorEvent extends Event {

		public static const PAGE_CHANGE : String = "PAGE_CHANGE";
		public static const ADDRESS_CHANGE : String = "ADDRESS_CHANGE";		public static const ADDRESS_NOT_HANDLED : String = "ADDRESS_NOT_HANDLED";
				public static const HANDLE_ACTION : String = "HANDLE_ACTION";

		protected var _page : IPage;
		
		public var action : Action;
		public var addressNames : Array;
		public var urlVariables : URLVariables;

		public function NavigatorEvent(type : String, page : IPage = null) {
			super(type);
			_page = page;
		}

		public function get page() : IPage {
			return _page;
		}
	}
}
