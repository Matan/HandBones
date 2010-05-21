package org.handbones.core 
{

	/**
	 * @author Matan Uberstein
	 */
	public interface ITracker 
	{
		/**
		 * Invokes Google Analytics Event tracking.
		 * 
		 * @param category
		 * @param action
		 * @param label
		 * @param label
		 */
		function trackEvent(category : String, action : String, label : String = null, value : Number = NaN) : Boolean

		/**
		 * Invokes Google Analytics Pageview tracking.
		 * 
		 * @param pageURL
		 * 
		 * @example <code>tracker.trackPageview("/Home");</code>
		 */
		function trackPageview(pageURL : String = "") : void
	}
}
