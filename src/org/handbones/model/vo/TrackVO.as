package org.handbones.model.vo 
{
	import mu.utils.ToStr;

	/**
	 * @author Matan Uberstein
	 */
	public class TrackVO 
	{

		public var url : String;

		public var category : String;		public var action : String;		public var label : String;		public var value : Number;

		public function toString() : String 
		{
			return String(new ToStr(this));
		}
	}
}
