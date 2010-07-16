package org.handbones.core 
{
	import flash.net.SharedObject;

	/**
	 * @author Matan Uberstein
	 */
	public interface ICookieModel 
	{
		/**
		 * @return Boolean if the default was created or not.
		 */
		function setCookieDefault(id : String, value : *) : Boolean

		function hasCookie(id : String) : Boolean

		function getCookie(id : String) : * 

		function setCookie(id : String, value : *, minDiskSpace : int = 10, overrideDenial : Boolean = false) : void 

		function deleteCookie(id : String) : void 

		function deleteAll() : void 
		
		function getCookieIds() : Array;
		
		function get firstVisit() : Boolean 
		
		function get dataObject() : Object

		function get sharedObject() : SharedObject

		function get deniedAccess() : Boolean

	}
}
