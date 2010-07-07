package org.handbones.controller 
{
	import org.handbones.core.INavigator;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class RemoveStatusCommand extends Command 
	{

		[Inject]
		public var navigator : INavigator;

		override public function execute() : void 
		{
			navigator.resetStatus();
		}
	}
}
