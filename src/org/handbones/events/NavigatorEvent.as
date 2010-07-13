package org.handbones.events 
{
	import org.handbones.core.IPage;
	import org.handbones.model.vo.ActionVO;

	import flash.events.Event;
	import flash.net.URLVariables;

	/**
	 * @author Matan Uberstein
	 */
	public class NavigatorEvent extends Event {

		public static const PAGE_CHANGE : String = "PAGE_CHANGE";		public static const ADDRESS_CHANGE : String = "ADDRESS_CHANGE";
		public static const INVALID_ADDRESS : String = "INVALID_ADDRESS";

		protected var _page : IPage;
		
		public var action : ActionVO;
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
