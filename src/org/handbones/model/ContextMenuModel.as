package org.handbones.model 
{
	import org.handbones.model.vo.ActionVO;
	import org.handbones.base.ActionMap;
	import org.handbones.core.IActionMap;
	import org.robotlegs.core.ICommandMap;

	import flash.events.ContextMenuEvent;

	import org.handbones.model.vo.ContextMenuItemVO;
	import org.handbones.model.vo.ContextMenuVO;
	import org.robotlegs.mvcs.Actor;

	import flash.display.DisplayObjectContainer;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.ui.ContextMenuItem;

	/**
	 * @author Matan Uberstein
	 */
	public class ContextMenuModel extends Actor
	{

		[Inject]
		public var commandMap : ICommandMap;
		
		protected var _actions : Array;
		
		protected var _actionMap : IActionMap;
		protected var _menu : ContextMenu;
		protected var _vo : ContextMenuVO;

		[Inject]

		public function ContextMenuModel(contextView : DisplayObjectContainer) 
		{
			_menu = new ContextMenu();
			contextView.contextMenu = _menu;
		}

		public function set contextMenuVo(vo : ContextMenuVO) : void 
		{
			if(!_vo)
			{
				_vo = vo;
			
				createActionMap();
			
				var iL : int = _vo.items.length;
				for(var i : int = 0;i < iL;i++) 
				{
					var itemVo : ContextMenuItemVO = _vo.items[i];
					addItem(itemVo.caption, itemVo.separator, itemVo.enabled, itemVo.visible);
				}
				
				if(_vo.hideDefault)
					hideBuiltInItems(_vo.print, _vo.zoom, _vo.quality);
			}
		}

		public function hideBuiltInItems(print : Boolean = false, zoom : Boolean = false, quality : Boolean = false) : void
		{
			_menu.hideBuiltInItems();
			
			var defaultItems : ContextMenuBuiltInItems = _menu.builtInItems;
			defaultItems.print = print;			defaultItems.zoom = zoom;			defaultItems.quality = quality;
		}

		public function addItem(caption : String, separator : Boolean = false, enabled : Boolean = true, visible : Boolean = true) : ContextMenuItem
		{
			var item : ContextMenuItem = new ContextMenuItem(caption, separator, enabled, visible);
			
			_actionMap.mapAction(item, caption, ContextMenuEvent);
			
			_menu.customItems.push(item);
			
			return item;
		}

		protected function createActionMap() : void
		{
			_actions = [];
			
			var iL : int = _vo.items.length;
			for(var i : int = 0;i < iL;i++) 
			{
				var itemVo : ContextMenuItemVO = _vo.items[i];
				
				var aL : int = itemVo.actions.length;
				for(var j : int = 0;j < aL;j++) 
				{
					var action : ActionVO = itemVo.actions[j];
					action.ref = itemVo.caption;					action.event = ContextMenuEvent.MENU_ITEM_SELECT;
					
					_actions.push(action);
				}
			}
			
			_actionMap = new ActionMap(eventDispatcher, _actions);
		}
		
		public function get actions() : Array
		{
			return _actions;
		}
	}
}
