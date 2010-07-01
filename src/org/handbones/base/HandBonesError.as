package org.handbones.base 
{

	/**
	 * @author Matan Uberstein
	 */
	public class HandBonesError extends Error 
	{
		public static const NOT_IPAGE : String = "SWF Loaded does not implement IPage [org.handbones.core::IPage]";

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
