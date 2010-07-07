package org.handbones.controller 
{
	import org.handbones.core.IPageModel;
	import org.handbones.model.SettingsModel;
	import org.handbones.model.vo.ActionVO;
	import org.handbones.events.ActionMapEvent;
	import org.handbones.core.INavigator;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class SetStatusCommand extends Command 
	{

		[Inject]
		public var event : ActionMapEvent;

		[Inject]
		public var navigator : INavigator;

		[Inject]
		public var settingsModel : SettingsModel;

		override public function execute() : void 
		{
			var action : ActionVO = event.action;
			
			if(action.gotoPageId) 
			{
				var pageModel : IPageModel = settingsModel.getPageModelById(action.gotoPageId);
				
				if(pageModel)
					navigator.status = pageModel.address;
			}
			
			else if(action.changeAddress) 
				navigator.status = action.changeAddress;
				
			if(action.invokeUrl) 
				navigator.status = action.invokeUrl;
		}
	}
}
