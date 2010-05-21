package org.handbones.events 
{
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author Matan Uberstein
	 */
	public class SizeEvent extends Event 
	{
		
		public static const RESIZE : String = "RESIZE";
		public static const PAGE_RESIZE : String = "PAGE_RESIZE";

		public var width : Number;
		public var height : Number;
		public var center : Point;
		public var pageWidth : Number;
		public var pageHeight : Number;
		public var pageCenter : Point;

		public function SizeEvent(type : String)
		{
			super(type);
		}
	}
}
