package org.handbones.mvcs 
{
	import org.handbones.controller.HandBonesStartupCommand;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Matan Uberstein
	 */
	public class HandBonesContext extends Context 
	{
		public function HandBonesContext(contextView : DisplayObjectContainer = null)
		{
			super(contextView, false);
			preStartup();
			startup();
		}

		protected function preStartup() : void
		{
			commandMap.mapEvent(ContextEvent.STARTUP, HandBonesStartupCommand, ContextEvent, true);
		}

		/**
		 * Prevents Robotlegs from dispatching <code>ContextEvent.STARTUP_COMPLETE</code>.
		 * At default HandBones will dispatch <code>ContextEvent.STARTUP_COMPLETE</code> when the settings have been loaded.
		 * 
		 * @see org.robotlegs.base.ContextEvent
		 */
		override public function startup() : void 
		{
		}
	}
}
