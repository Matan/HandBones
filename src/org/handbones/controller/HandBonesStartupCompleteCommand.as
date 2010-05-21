package org.handbones.controller 
{
	import org.handbones.core.IActionMap;
	import org.handbones.core.INavigator;
	import org.handbones.model.SizeModel;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class HandBonesStartupCompleteCommand extends Command 
	{

		[Inject]
		public var sizeModel : SizeModel;

		[Inject]
		public var actionMap : IActionMap;
		
		/**
		 * Injecting INavigator to ensure it's constructed.
		 */
		[Inject]
		public var navigator : INavigator;

		override public function execute() : void 
		{
			//Ensure that sizing model is populated before any reference to it occures
			sizeModel.updateSize(contextView.stage.stageWidth, contextView.stage.stageHeight);
			
			//This will map all actions that don't have a reference to the shell dispatcher.
			actionMap.mapAction(eventDispatcher, "");
		}
	}
}
