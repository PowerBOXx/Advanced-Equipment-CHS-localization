/**
 * Compiles the device from config for an object's class.
 * Analoge to ACE3 MenuCompile.
 *
 * Argmuments:
 * 0: Entity
 *
 * Returns:
 * None
 *
 */

params['_entity'];


private _class = typeOf _entity;

if(isNil {missionNamespace getVariable _class}) then 
{

	private _deviceCfg = configFile >> "CfgVehicles" >> _class >> "AE3_Device";

	if (isNull _deviceCfg) exitWith 
	{
		missionNamespace setVariable [_class, "", True];
	};

	private _config = createHashMap;
	missionNamespace setVariable [_class, _config, True];

	[_deviceCfg, _config] call AE3_power_fnc_compileConfig;

	private _internalCfg = configFile >> "CfgVehicles" >> _class >> "AE3_InternalDevice";

	if (!isNull _internalCfg) then
	{
		_config set ["internal", createHashMap];
		[_internalCfg, _config get "internal"] call AE3_power_fnc_compileConfig;	
	};
};

private _config = missionNamespace getVariable _class;

if(_config isEqualType "") exitWith {};

[_entity] + (_config get 'device') call AE3_power_fnc_initDevice;

if('powerInterface' in _config) then 
{
	[_entity] + (_config get 'powerInterface') call AE3_power_fnc_initPowerInterface;
};

if('battery' in _config) then 
{
	[_entity] + (_config get 'battery') call AE3_power_fnc_initBattery;
};

if('generator' in _config) then 
{
	[_entity] + (_config get 'generator') call AE3_power_fnc_initGenerator;
};

if('consumer' in _config) then 
{
	[_entity] + (_config get 'consumer') call AE3_power_fnc_initConsumer;
};

if(!("internal" in _config)) exitWith {};

private _internalConfig = _config get "internal";
private _internal = true call CBA_fnc_createNamespace;

_entity setVariable ['AE3_internal', _internal, true];
_internal setVariable ['AE3_parent', _entity, true];

[_internal] + (_internalConfig get 'device') call AE3_power_fnc_initDevice;

if('powerInterface' in _internalConfig) then 
{
	[_internal] + (_internalConfig get 'powerInterface') call AE3_power_fnc_initPowerInterface;
};

if('battery' in _internalConfig) then 
{
	[_internal] + (_internalConfig get 'battery') call AE3_power_fnc_initBattery;
};

if('generator' in _internalConfig) then 
{
	[_internal] + (_internalConfig get 'generator') call AE3_power_fnc_initGenerator;
};