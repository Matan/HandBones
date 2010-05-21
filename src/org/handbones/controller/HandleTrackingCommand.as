package org.handbones.controller 
{
	import org.handbones.core.ITracker;
	import org.handbones.events.TrackingEvent;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class HandleTrackingCommand extends Command 
	{

		[Inject]
		public var tracker : ITracker;

		[Inject]
		public var event : TrackingEvent;

		override public function execute() : void 
		{
			if(event.url)
				tracker.trackPageview(event.url);
			
			tracker.trackEvent(event.category, event.action, event.label, event.value);
		}
	}
}
