// https://community.bistudio.com/wiki/DIK_KeyCodes
#include "\a3\ui_f\hpp\definedikcodes.inc"

params ["_terminalCtrl"];

/* ---------------------------------------- */

private _result = _terminalCtrl ctrlAddEventHandler
[
	"KeyDown", 
	{
		params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

		//hint format ["OUTPUT CONTROL KEY: %1 \n SHIFT: %2 \n CTRL: %3 \n ALT: %4", _key call BIS_fnc_keyCode, _shift, _ctrl, _alt];

		private _computer = _displayorcontrol getVariable "AE3_computer";
		private _terminal = _computer getVariable "AE3_terminal";
		private _terminalApplication = _terminal get "AE3_terminalApplication";

		hint format ["TERMINAL: %1", _terminal];

		private _localGameLanguage = language;

		// we can determine the language of arma 3 but not the language of the keyboard layout
		// if the language is german, it's obvious, that the keyboard layout is also german (this is not the case, if game language is english)
		// perhaps we need to provide a CBA setting for changing keyboard layout or allow to change the layout directly in the terminal window
		private _allowedKeys = createHashMap;
		if (_localGameLanguage == "German") then
		{
			_allowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysGerman;
		};

		private _keyCombination = format ["%1-%2-%3-%4", _key, _shift, _ctrl, _alt];

		if (_keyCombination in _allowedKeys) then
		{
			private _keyChar = _allowedKeys get _keyCombination;
			[_computer, _keyChar] call AE3_armaos_fnc_terminal_addChar;
		};

		if (_key isEqualTo DIK_BACKSPACE) then
		{
			[_computer] call AE3_armaos_fnc_terminal_removeChar;
		};


		if ((_key isEqualTo DIK_RETURN) || (_key isEqualTo DIK_NUMPADENTER)) then	
		{
			switch (_terminalApplication) do
			{
				case "LOGIN": { /*_result = [_consoleInput, _inputText, _outputText] call AE3_armaos_fnc_login;*/ };
				case "PASSWORD": { /*_result = [_consoleInput, _inputText, _outputText] call AE3_armaos_fnc_login;*/ };
				case "SHELL":
					{
						private _terminalBuffer = _terminal get "AE3_terminalBuffer";
						private _terminalPrompt = _terminal get "AE3_terminalPrompt";

						private _lastBufferLineIndex = (count _terminalBuffer) - 1;
						private _lastBufferLine = _terminalBuffer # (_lastBufferLineIndex);

						private _commandString = _lastBufferLine select [(count _terminalPrompt), (count _lastBufferLine)];

						hint format ["LAST BUFFER LINE: %1 \n\n PROMPT: %2 \n\n COMMAND: %3", _lastBufferLine, _terminalPrompt, _commandString];

						private _result = [_computer, _commandString] call AE3_armaos_fnc_shell_process;
					};
			};
		};

		[_computer, _displayorcontrol] call AE3_armaos_fnc_terminal_updateOutput;

		true // Intercepts the default action, eg. pressing escape won't close the dialog.
	}
];

/* ---------------------------------------- */