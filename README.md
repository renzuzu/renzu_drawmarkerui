# renzu_drawmarkerui
WIP marker NUI (not ready for production yet)

![image](https://user-images.githubusercontent.com/82306584/130764598-3061700e-f795-498f-b1ee-8e3f8a1b89ed.png)
# Sample Usage Server:

```
RegisterCommand("pdhelp", function(source , args, rawCommand)
    local source = source
    local t = {
        job = 'police',
        coord = GetEntityCoords(GetPlayerPed(source)),
        dist = tonumber(args[2]) or 200.0,
        label = args[1],
        fa = 'hands-helping',
        blip = Config.sprite, -- blip sprite
        sender = GetPlayerName(source),
        timeout = Config.timer
    }
    TriggerClientEvent('AddNuiMarker',-1,t)
end, false)
```
# Sample Usage Client

```
local source = source
    local t = {
        coord = vector3(-207.78691101074,-1319.1196289062,30.890409469604),
        dist = 40.0,
        label = 'Upgrade Section 3',
        fa = 'car',
        timeout = Config.timer -- or uncomment or change this to whatever number eg. 300 = 5minutes, when timer expire the marker dissapear
    }
    TriggerEvent('AddNuiMarker',t)
```

# Disclaimer
- Original Base Code
https://github.com/OfficialNoms/3dme-html
