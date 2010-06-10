package org.handbones.controller 
{
	import org.handbones.model.SizeModel;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	internal class PostStartupCompleteCommand extends Command 
	{

		[Inject]
		public var sizeModel : SizeModel;

		override public function execute() : void 
		{
			//Update size after context has been created to ensure that views receive an update event.
			sizeModel.updateSize(contextView.stage.stageWidth, contextView.stage.stageHeight);
		}
	}
}
