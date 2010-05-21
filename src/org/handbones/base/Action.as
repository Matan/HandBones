package org.handbones.base 
{
	import mu.utils.ToStr;

	/**
	 * @author Matan Uberstein
	 */
	public class Action 
	{
		public var event : String;
		public var ref : String;
		public var gotoPageId : String;

		public var invokeUrl : String;
		public var urlWindow : String;
		public var changeAddress : String;
		public var keepHistory : Boolean;

		public var trackActions : Array;

		public function toString() : String 
		{
			return String(new ToStr(this));
		}
	}
}
