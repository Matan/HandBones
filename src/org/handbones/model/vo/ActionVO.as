package org.handbones.model.vo 
{
	import mu.utils.ToStr;

	/**
	 * @author Matan Uberstein
	 */
	public class ActionVO 
	{
		public var event : String;
		public var ref : String;
		public var gotoPageId : String;

		public var invokeUrl : String;
		public var urlWindow : String;
		public var changeAddress : String;
		public var keepHistory : Boolean;

		public var showStatus : Boolean;

		public var trackers : Array;

		public function toString() : String 
		{
			return String(new ToStr(this));
		}
	}
}
