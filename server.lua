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