package org.handbones.events 
{
	import org.handbones.core.IPageModel;

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

		public static const LOADED : String = "LOADED";

		protected var _model : IPageModel;

		public function PageEvent(type : String, model : IPageModel = null)
		{
			super(type);
			_model = model;
		}

		public function get model() : IPageModel
		{
			return _model;
		}
	}
}
