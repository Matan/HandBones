package org.handbones.base 
{

	/**
	 * @author Matan Uberstein
	 */
	public class HandBonesError extends Error 
	{
		public static const NOT_IPAGE : String = "SWF Loaded does not implement IPage [org.handbones.core::IPage].";
		public static const COOKIES_NAME_UNDEFINED : String = "COOKIE NAME UNDEFINED: You did not specify the 'name' attribute of the 'cookies' node.";
		public static const COOKIES_NAME_INVALID : String = "COOKIE NAME INVALID: The 'cookies' node's 'name' attribute can not contain the following characters. ~ % & \\ ; : \" ' , < > ? # and spaces.";

		public function HandBonesError(message : * = "", id : * = 0)
		{
			super(message, id);
		}

		public static function TRACK_VAR_NOT_ASSIGNED(varName : String, property : String) : String 
		{
			return "Variable (" + varName + ") defined in site.xml could not be assigned to TrackVO property (" + property + ")";
		}
	}
}
