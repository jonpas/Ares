_logic = _this select 0;
_units = _this select 1;
_activated = _this select 2;

if (_activated && local _logic) then
{
	// Generate list of the players to teleport.
	_playersToTeleport = [];
	{
		if (isPlayer _x && (side _x) == civilian) then
		{
			_playersToTeleport set [count _playersToTeleport, _x];
		};
	} forEach allUnits;

	// Get the location to teleport them to.
	_location = getPos _logic;

	// Call the teleport function.
	[_playersToTeleport, _location] call Ares_fnc_TeleportPlayers;

	[objNull, format["Teleported %1 players to %2", (count _playersToTeleport), _location]] call bis_fnc_showCuratorFeedbackMessage;
};

deleteVehicle _logic;
true
