package org.handbones.base 
{
	import mu.utils.ToStr;

	/**
	 * @author Matan Uberstein
	 */
	public class PageSettings {
		
		public var id : String;		public var src : String;		public var address : String;		public var title : String;
		public var actions : Array;
		public var data : XML;
		
		public var autoStartup : Boolean = true;		public var autoShutdown : Boolean = true;

		public function toString() : String {
			return String(new ToStr(this));
		}			}
}
