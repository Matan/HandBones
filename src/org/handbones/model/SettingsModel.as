package org.handbones.model 
{
	import org.handbones.base.PageSettings;
	import org.robotlegs.mvcs.Actor;

	/**
	 * @author Matan Uberstein
	 */
	public class SettingsModel extends Actor 
	{
		public var pages : Array;
		public var actions : Array;

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

		public function getPageSettingsById(id : String) : PageSettings 
		{
			var dL : int = pages.length;
			for(var i : int = 0;i < dL;i++) 
			{
				var vo : PageSettings = pages[i];
				if(vo.id == id)
					return vo;
			}
			return null;
		}

		public function getPageSettingsByAddress(address : String) : PageSettings 
		{
			address = (address) ? address.toLowerCase() : "";
			
			var dL : int = pages.length;
			
			for(var i : int = 0;i < dL;i++) 
			{
				var vo : PageSettings = pages[i];
				
				if(vo.address.toLowerCase() == address)
					return vo;
			}
			
			return null;
		}
	}
}
