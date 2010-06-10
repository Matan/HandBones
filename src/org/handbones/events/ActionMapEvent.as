package org.handbones.events 
{
	import org.handbones.model.vo.ActionVO;

	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class ActionMapEvent extends Event 
	{
		public static const EXECUTE_ACTION : String = "EXECUTE_ACTION";

		public var action : ActionVO;

		public function ActionMapEvent(type : String, action : ActionVO)
		{
			super(type);
			this.action = action;
		}
	}
}
