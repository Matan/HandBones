package org.handbones.core 
{
	import flash.net.URLVariables;

	/**
	 * @author Matan Uberstein
	 */
	public interface INavigator 
	{
		/**
		 * Navigates to the page identifier given.
		 * 
		 * @param id Page id specified in init settings.
		 */
		function gotoPageId(id : String) : void

		/**
		 * Invokes the URL given.
		 * 
		 * @param url URL
		 * @param window The window type. Defaults to <code>"_blank"</code>.
		 */
		function invokeURL(url : String, window : String = null) : void

		/**
		 * Changes the address of the browser using <code>SWFAddress</code>.
		 * 
		 * @param address The address.
		 * @param history Switched browser history on or off.
		 */
		function setAddress(address : String, history : Boolean = true) : void

		/**
		 * Changes the title of the browser using <code>SWFAddress</code>.
		 * 
		 * @param title The title.
		 */
		function setTitle(title : String) : void

		/**
		 * Removes all query variables from the address bar without reloading the browser using <code>SWFAddress</code>.
		 */
		function clearUrlVariables() : void

		/**
		 * Gets all the address names from the address bar using <code>SWFAddress</code>.
		 * 
		 * @return An <code>Array</code> containing address names in order of occurance.
		 */
		function getAddressNames() : Array 

		/**
		 * Gets the root address name using <code>SWFAddress</code>.
		 * 
		 * @return A <code>String</code> of the root address.
		 */
		function getRootAddress() : String 

		/**
		 * Gets the query variables from the address bar using <code>SWFAddress</code>.
		 * 
		 * @return <code>URLVariables</code> instance of the address bar variables.
		 */
		function getUrlVariables() : URLVariables 
	}
}
