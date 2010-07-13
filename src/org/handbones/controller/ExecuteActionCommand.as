package org.handbones.controller 
{
	import org.handbones.core.INavigator;
	import org.handbones.core.ITracker;
	import org.handbones.events.ActionMapEvent;
	import org.handbones.model.vo.ActionVO;
	import org.handbones.model.vo.TrackVO;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class ExecuteActionCommand extends Command 
	{

		[Inject]
		public var event : ActionMapEvent;

		[Inject]
		public var tracker : ITracker;

		[Inject]
		public var navigator : INavigator;

		override public function execute() : void 
		{
			var action : ActionVO = event.action;
			
			//Tracking
			var tL : int = action.trackers.length;
			for(var i : int = 0;i < tL;i++) 
			{
				var track : TrackVO = action.trackers[i];
				
				if(track.url)
					tracker.trackPageview(track.url);
			
				tracker.trackEvent(track.category, track.action || event.type, track.label, track.value);
			}
			
			//Navigation
			if(action.gotoPageId) 
				navigator.gotoPageId(action.gotoPageId, action.keepHistory);
			
			else if(action.changeAddress) 
				navigator.setAddress(action.changeAddress, action.keepHistory);
				
			if(action.invokeUrl) 
				navigator.invokeURL(action.invokeUrl, action.urlWindow);
		}
	}
}
