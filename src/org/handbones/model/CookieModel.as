package org.handbones.model 
{
	import org.handbones.core.ICookieModel;

	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	/**
	 * @author Matan Uberstein
	 */
	public class CookieModel implements ICookieModel
	{
		protected var _sharedObject : SharedObject;
		protected var _data : Object;
		protected var _deniedAccess : Boolean;

		protected var _pendingState : Boolean;
		protected var _queuedSaveRequests : Array;

		public function CookieModel(name : String, clearPreviousSession : Boolean = false) 
		{
			_data = {};
			_sharedObject = SharedObject.getLocal(name);
			_queuedSaveRequests = [];
			
			if(clearPreviousSession)
				deleteAll();
				
			if(!setCookieDefault("firstVisit", true))
				setCookie("firstVisit", false);
		}

		/**
		 * @return Boolean if the default was created or not.
		 */
		public function setCookieDefault(id : String, value : *) : Boolean		
		{
			if(!hasCookie(id)) 
			{
				setCookie(id, value);
				return true;
			}
			return false;
		}

		public function hasCookie(id : String) : Boolean		
		{
			return (getCookie(id) != undefined);
		}

		public function getCookie(id : String) : *		
		{
			return dataObject[id];
		}

		public function setCookie(id : String, value : *, minDiskSpace : int = 10, overrideDenial : Boolean = false) : void
		{
			if(!_pendingState)
			{
				dataObject[id] = value;
            
				if(!_deniedAccess || overrideDenial)
				{
					var flushStatus : String = null;
					try 
					{
						flushStatus = _sharedObject.flush(minDiskSpace);
					} catch (error : Error) 
					{
					}
					if (flushStatus != null) 
					{
						switch (flushStatus) 
						{
							case SharedObjectFlushStatus.PENDING:
								_pendingState = true;
								_sharedObject.addEventListener(NetStatusEvent.NET_STATUS, sharedObject_netStatus_handler);
								break;
						}
					}
				}
			}
			else
			{
				_queuedSaveRequests.push(arguments);
			}
		}

		public function deleteCookie(property : String) : void 
		{
			delete dataObject[property];
		}

		public function deleteAll() : void 
		{
			if(_deniedAccess)
				_data = {};
			
			else
				_sharedObject.clear();
		}

		public function getCookieIds() : Array
		{
			var ids : Array = [];
			for (var id : String in dataObject) 
			{
				ids.push(id);
			}
			return ids;
		}

		protected function sharedObject_netStatus_handler(event : NetStatusEvent) : void 
		{
			_pendingState = false;
			_sharedObject.removeEventListener(NetStatusEvent.NET_STATUS, sharedObject_netStatus_handler);
			
			switch (event.info.code) 
			{
				case "SharedObject.Flush.Success":
					_deniedAccess = false;
					break;
				
				case "SharedObject.Flush.Failed":
					_deniedAccess = true;
					break;
			}
			
			var qL : int = _queuedSaveRequests.length;
			for(var i : int = 0;i < qL;i++) 
			{
				setCookie.apply(null, _queuedSaveRequests.shift());
			}
		}

		public function get firstVisit() : Boolean 
		{
			return getCookie("firstVisit");
		}

		public function get dataObject() : Object
		{
			return (_deniedAccess) ? _data : _sharedObject.data;
		}

		public function get sharedObject() : SharedObject
		{
			return _sharedObject;
		}

		public function get deniedAccess() : Boolean
		{
			return _deniedAccess;
		}
	}
}
