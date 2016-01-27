#include "script_component.hpp"

params ["", "_sel"];
TRACE_1("params",_sel);

disableSerialization;

{
    _x ctrlShow (_forEachIndex == _sel);
} forEach UI_TABS_CONTROLS;

switch (_sel) do {
case (0): {
        TRACE_1("showing zeus tab", _sel);
        lbClear UI_TAB_ZEUS_PLAYERS;
        if (player in allPlayers) then {
            GVAR(ui_zeusTargets) = [player];
        } else {
            GVAR(ui_zeusTargets) = [];
        };

        { if ((_x != player)) then {GVAR(ui_zeusTargets) pushBack _x;}; } forEach allPlayers;

        {
            if (!isNull (getAssignedCuratorLogic _x)) then {
                UI_TAB_ZEUS_PLAYERS lbAdd format ["[ZEUS] %1", (name _x)];
            } else {
                UI_TAB_ZEUS_PLAYERS lbAdd format ["%1", (name _x)];
            };
        } forEach GVAR(ui_zeusTargets);

        UI_TAB_ZEUS_PLAYERS lbSetCurSel 0;
    };
case (1): {
        TRACE_1("showing supplies tab", _sel);
        lbClear UI_TAB_SUPPLIES_TYPE;
        GVAR(supplyClassNames) = [];
        {
            private _className = configName _x;
            if (isClass (configFile >> "CfgVehicles" >> _className)) then {
                TRACE_2("veh exists in modset",_x,_className);
                GVAR(supplyClassNames) pushBack _className;
                private _description = if (isText (_x >> "displayName")) then {
                    getText (_x >> "displayName"); //use custom name
                } else {
                    getText (configFile >> "CfgVehicles" >> _className >> "displayName"); // use veh name
                };
                _index = UI_TAB_SUPPLIES_TYPE lbAdd format ["%1", _description];
                UI_TAB_SUPPLIES_TYPE lbSetTooltip [_index, _className];
            } else {
                TRACE_2("veh missing from modset",_x,_className);
            };
        } forEach (configProperties [configFile >> QGVAR(supplies)]);
        UI_TAB_SUPPLIES_TYPE lbSetCurSel 0;

        lbClear UI_TAB_SUPPLIES_GROUP;
        GVAR(groupsArray) = [];
        {
            if ( ({(isPlayer _x)&&{alive _x}} count (units _x)) > 0) then {
                GVAR(groupsArray) pushBack _x;
                private _grpMembers = "";
                {_grpMembers = _grpMembers + format ["%1, ", (name _x)];} forEach (units _x);
                _txt = format ["%1 [%2]", _x, _grpMembers];
                private _index = UI_TAB_SUPPLIES_GROUP lbAdd _txt;
                UI_TAB_SUPPLIES_GROUP lbSetTooltip [_index, _grpMembers];
            };
        } forEach allGroups;
        UI_TAB_SUPPLIES_GROUP lbSetCurSel 0;
    };
case (2): {
        TRACE_2("showing end mission tab", _sel, GVAR(openEndMission));
        if (GVAR(openEndMission)) then {
            UI_TAB_END_TEXT ctrlShow true;
            UI_TAB_END_UNLOCK ctrlShow false;
            _txt = format ["Players Alive: %1<br/>", ({(alive _x)&&{isPlayer _x}} count allUnits)];
            _txt = _txt + format ["<br/><t color='#9999FF'>West Alive: %1 [Players: %2]</t>", ({(alive _x)&&{side _x == west}} count allUnits), ({(alive _x)&&(side _x == west)&&(isPlayer _x)} count allUnits)];
            _txt = _txt + format ["<br/><t color='#FF9999'>East Alive: %1 [Players: %2]</t>", ({(alive _x)&&{side _x == east}} count allUnits), ({(alive _x)&&(side _x == east)&&(isPlayer _x)} count allUnits)];
            _txt = _txt + format ["<br/><t color='#99FF99'>Indp Alive: %1 [Players: %2]</t>", ({(alive _x)&&{side _x == resistance}} count allUnits), ({(alive _x)&&(side _x == resistance)&&(isPlayer _x)} count allUnits)];
            _txt = _txt + format ["<br/><t color='#FF99FF'>Civ  Alive: %1 [Players: %2]</t>", ({(alive _x)&&{side _x == civilian}} count allUnits), ({(alive _x)&&(side _x == civilian)&&(isPlayer _x)} count allUnits)];
            UI_TAB_END_TEXT ctrlSetStructuredText parseText _txt;
        } else {
            UI_TAB_END_TEXT ctrlShow false;
            UI_TAB_END_UNLOCK ctrlShow true;
        };
    };
case (3): {
        TRACE_1("showing teleport tab", _sel);
        lbClear UI_TAB_TELEPORT_PERSON;
        GVAR(teleportPersonList) = [];
        {
            if ((isPlayer _x) && {alive _x} && {_x getVariable [QGVAR(didJip), false]}) then {
                GVAR(teleportPersonList) pushBack _x;
                UI_TAB_TELEPORT_PERSON lbAdd format ["JIP: %1", (name _x)];
            };
        } forEach allUnits;
        {
            if ((isPlayer _x) && {alive _x} && {!(_x getVariable [QGVAR(didJip), false])}) then {
                GVAR(teleportPersonList) pushBack _x;
                UI_TAB_TELEPORT_PERSON lbAdd format ["%1", (name _x)];
            };
        } forEach allUnits;
        UI_TAB_TELEPORT_PERSON lbSetCurSel 0;
        lbClear UI_TAB_TELEPORT_GROUP;
        GVAR(groupsArray) = [];
        {
            if ( ({(isPlayer _x)&&(alive _x)} count (units _x)) != 0) then {
                GVAR(groupsArray) pushBack _x;
                private _grpMembers = "";
                {_grpMembers = _grpMembers + format ["%1, ", (name _x)];} forEach (units _x);
                _txt = format ["%1 [%2]", _x, _grpMembers];
                private _index = UI_TAB_TELEPORT_GROUP lbAdd _txt;
                UI_TAB_TELEPORT_GROUP lbSetTooltip [_index, _grpMembers];
            };
        } forEach allGroups;
        UI_TAB_TELEPORT_GROUP lbSetCurSel 0;
    };
};
