package utility 
{
	import entities.NPC;
	import entities.Player;
	/**
	 * ...
	 * @author dolgion
	 */
	public class DialogManager
	{
		public var currentDialog:Array = new Array;
		public var currentLine:int;
		public var currentTurn:int;
		
		public function DialogManager() 
		{
			
		}
		
		public function get dialogHasEnded():Boolean
		{
			if (currentLine >= currentDialog[currentTurn].lines.length) 
			{
				currentTurn = 0;
				currentLine = 0;
				return true;
			}
			else return false;
		}
		
		public function nextNPCLine(_playerResponse:int):String
		{
			var nextLine:String = currentDialog[0].lines[currentLine].versions[_playerResponse];
			currentTurn = 1;
			
			return nextLine;
		}
		
		public function get nextPlayerLineVersions():Array
		{
			var nextLineVersions:Array = currentDialog[1].lines[currentLine].versions;
			currentTurn = 0;
			currentLine++;
			
			return nextLineVersions;
		}
		
		public function setCurrentDialogWithPlayer(_player:Player, _npcName:String, _npcs:Array):Boolean
		{
			if (_player.dialogCounters[_npcName] == undefined)
			{
				return false;
			}
			else if (_player.dialogCounters[_npcName] >= _player.dialogsInTotal[_npcName])
			{
				return false
			}
			else 
			{
				var d:Dialog;
				var i:int;
				var dialogPartner:NPC = getDialogPartner(_npcName, _npcs);
				
				if (dialogPartner == null) return false;
				
				var dialogsWithGivenNPC:Array = new Array();
				for (i = 0; i < _player.dialogs.length; i++)
				{
					d = _player.dialogs[i];
					if (d.partner == _npcName)
					{
						dialogsWithGivenNPC.push(d);
					}
				}
				
				var dialogsOfGivenNPC:Array = new Array();
				for (i = 0; i < dialogPartner.dialogs.length; i++)
				{
					d = dialogPartner.dialogs[i];
					if (d.partner == "player")
					{
						dialogsOfGivenNPC.push(d);
					}
				}
				
				
				currentDialog.push(dialogsOfGivenNPC[dialogPartner.dialogCounters["player"]]);
				currentDialog.push(dialogsWithGivenNPC[_player.dialogCounters[_npcName]]);
				currentTurn = 0;
				currentLine = 0;
				_player.dialogCounters[_npcName]++;
				return true;
			}
		}
		
		public function getDialogPartner(_npcName:String, _npcs:Array):NPC
		{
			for each (var n:NPC in _npcs)
			{
				if (n.name == _npcName) return n;
			}
			
			return null;
		}
		
	}

}