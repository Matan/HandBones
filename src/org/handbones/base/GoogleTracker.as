package org.handbones.base 
{
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;

	import org.handbones.core.ITracker;
	import org.handbones.model.SettingsModel;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Matan Uberstein
	 */
	public class GoogleTracker implements ITracker 
	{

		[Inject]
		public var settingsModel : SettingsModel;

		[Inject]
		public var contextView : DisplayObjectContainer;

		protected var _ga : AnalyticsTracker;

		[PostConstruct]

		public function init() : void 
		{
			if(settingsModel.trackerUID != "")
				_ga = AnalyticsTracker(new GATracker(contextView.stage, settingsModel.trackerUID, "AS3", settingsModel.trackerDebug));
		}

		public function trackEvent(category : String, action : String, label : String = null, value : Number = NaN) : Boolean 
		{
			if(_ga)
				return _ga.trackEvent(category, action, label, value);
			return false;	
		}

		public function trackPageview(pageURL : String = "") : void 
		{
			if(_ga && pageURL != "")
				_ga.trackPageview(pageURL);
		}
	}
}
