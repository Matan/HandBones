package org.handbones.controller 
{
	/**
	 * @author Matan Uberstein
	 */
	internal function toBoolean(value : String, defaultReturn : Boolean) : Boolean
	{
		value = value.toLowerCase();
			
		if(value == "1" || value == "yes" || value == "true")
				return true;
				
		if(value == "0" || value == "no" || value == "false")
				return false;
				
		return defaultReturn;
	}
}
