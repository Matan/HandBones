package org.handbones.controller 
{
	import org.handbones.core.INavigator;
	import org.handbones.events.NavigatorEvent;
	import org.handbones.base.Action;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class HandleActionCommand extends Command 
	{

		[Inject]
		public var event : NavigatorEvent;

		[Inject]
		public var navigator : INavigator;

		override public function execute() : void 
		{
			var action : Action = event.action;
			
			if(action.gotoPageId) 
				navigator.gotoPageId(action.gotoPageId);
			
			else if(action.invokeUrl) 
				navigator.invokeURL(action.invokeUrl, action.urlWindow);
			
			else if(action.changeAddress) 
				navigator.setAddress(action.changeAddress, action.keepHistory);
		}
	}
}
