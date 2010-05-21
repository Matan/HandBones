package org.handbones.events 
{
	import org.handbones.base.PageSettings;

	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class PageEvent extends Event 
	{
		public static const STARTUP : String = "STARTUP";
		public static const STARTUP_COMPLETE : String = "STARTUP_COMPLETE";
		public static const SHUTDOWN : String = "SHUTDOWN";
		public static const SHUTDOWN_COMPLETE : String = "SHUTDOWN_COMPLETE";

		public static const PAGE_CHANGE : String = "PAGE_CHANGE";

		protected var _settings : PageSettings;

		public function PageEvent(type : String, settings : PageSettings = null)
		{
			super(type);
			_settings = settings;
		}

		public function get settings() : PageSettings
		{
			return _settings;
		}
	}
}
