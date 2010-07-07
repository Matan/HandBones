package org.handbones.events 
{
	import org.handbones.model.vo.ActionVO;

	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class ActionMapEvent extends Event 
	{
		public static const EXECUTE : String = "EXECUTE";
		public static const SET_STATUS : String = "SET_STATUS";
		public static const REMOVE_STATUS : String = "REMOVE_STATUS";

		public var action : ActionVO;

		public function ActionMapEvent(type : String, action : ActionVO)
		{
			super(type);
			this.action = action;
		}
	}
}
