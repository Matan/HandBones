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
		function invokeURL(url : String, window : String = "_blank") : void

		/**
		 * Gets the current deeplinking value.
		 */
		function getAddress() : String;

		/**
		 * Changes the address of the browser using <code>SWFAddress</code>.
		 * 
		 * @param address The address.
		 * @param history Switched browser history on or off.
		 */
		function setAddress(address : String, history : Boolean = true) : void

		/**
		 * Gets the current browser title.
		 * 
		 * @return String of title.
		 */
		function get title() : String;

		/**
		 * Changes the title of the browser using <code>SWFAddress</code>.
		 * 
		 * @param value The title.
		 */
		function set title(value : String) : void

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
		 * Removes all query variables from the address bar without reloading the browser using <code>SWFAddress</code>.
		 */
		function clearUrlVariables() : void

		/**
		 * Gets the query variables from the address bar using <code>SWFAddress</code>.
		 * 
		 * @return <code>URLVariables</code> instance of the address bar variables.
		 */
		function getUrlVariables() : URLVariables 

		/**
		 * Sets the query variables of the address bar using <code>SWFAddress</code>.
		 * 
		 * @param value <code>URLVariables</code> instance of the address bar variables.
		 */
		function setUrlVariables(value : URLVariables) : void 

		/**
		 * Gets the value of the query string with parameter name passed.
		 * 
		 * @return String
		 */
		function getUrlVariable(param : String) : String;

		/**
		 * Gets the all the names of the query string variables.
		 * 
		 * @return Array
		 */
		function getUrlVariableNames() : Array;

		/**
		 * Steps back one place in browser history.
		 */
		function back() : void;

		/**
		 * Steps forward one place in browser history.
		 */
		function forward() : void;

		/**
		 * Steps on level up in deep linking value.
		 */
		function up() : void;

		/**
		 * Gets the base url.
		 * 
		 * @return String
		 */
		function get baseURL() : String;

		/**
		 * Gets if the browser is keeping history or not.
		 * 
		 * @return Boolean
		 */
		function get history() : Boolean;

		/**
		 * Sets if the browser is keeping history or not.
		 */
		function set history(value : Boolean) : void;

		/**
		 * Creates a html popup window.
		 */
		function popup(url : String, name : String = "popup", options : String = '""', handler : String = "") : void;

		/**
		 * Resets the browser's status.
		 */
		function resetStatus() : void;

		/**
		 * Get the current browser status.
		 * 
		 * @return String
		 */
		function get status() : String;

		/**
		 * Sets the browser status.
		 * 
		 * @param value String
		 */
		function set status(value : String) : void;
	}
}
