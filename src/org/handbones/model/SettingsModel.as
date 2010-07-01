package org.handbones.model 
{
	import org.handbones.core.IPageModel;
	import org.robotlegs.mvcs.Actor;

	/**
	 * @author Matan Uberstein
	 */
	public class SettingsModel extends Actor 
	{
		public var pages : Array;
		public var actions : Array;
		public var assets : Array;

		public var titleBody : String;
		public var titlePrefix : String;
		public var titleSuffix : String;

		public var trackerUID : String;
		public var trackerDebug : Boolean;

		public var shellDispatchContextStartupComplete : Boolean = true;

		public var data : XML;

		public function SettingsModel() 
		{
		}

		public function getPageModelById(id : String) : IPageModel 
		{
			var dL : int = pages.length;
			for(var i : int = 0;i < dL;i++) 
			{
				var model : IPageModel = pages[i];
				if(model.id == id)
					return model;
			}
			return null;
		}

		public function getPageModelByAddress(address : String) : IPageModel 
		{
			address = (address) ? address.toLowerCase() : "";
			
			var dL : int = pages.length;
			for(var i : int = 0;i < dL;i++) 
			{
				var model : IPageModel = pages[i];
				
				if(model.address.toLowerCase() == address)
					return model;
			}
			return null;
		}
	}
}
