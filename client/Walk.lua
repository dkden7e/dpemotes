local latestWalkStyle = nil
local crouched = false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		DisableControlAction(0,36,true)--INPUT_DUCK
	end
end)

RegisterCommand("crouch", function()
    playerPed = PlayerPedId()
    if (DoesEntityExist(playerPed) and not IsEntityDead(playerPed)) then
    	if (not IsPauseMenuActive()) then
    		RequestAnimSet("move_ped_crouched")
    		while (not HasAnimSetLoaded("move_ped_crouched")) do
    			Citizen.Wait(25)
    		end
    		if crouched then
    			if latestWalkStyle then
    				SetPedMovementClipset(playerPed, latestWalkStyle, 0.2)
    			else
    				ResetPedMovementClipset(playerPed, 0)
    			end
    			crouched = false
    		else
    			SetPedMovementClipset(playerPed, "move_ped_crouched", 0.25)
    			crouched = true
    		end
    	end
    end
end)

RegisterKeyMapping("crouch", "Agacharse/levantarse", "keyboard", "LCONTROL")

function WalkMenuStart(name)
    RequestWalking(name)
    SetPedMovementClipset(PlayerPedId(), name, 0.2)
    latestWalkStyle = name
    RemoveAnimSet(name)
end

function RequestWalking(set)
    RequestAnimSet(set)
    while not HasAnimSetLoaded(set) do
        Citizen.Wait(1)
    end
end

function WalksOnCommand(source, args, raw)
    local WalksCommand = ""
    for a in pairsByKeys(DP.Walks) do
        WalksCommand = WalksCommand .. "" .. string.lower(a) .. ", "
    end
    EmoteChatMessage(WalksCommand)
    EmoteChatMessage("To reset do /walk reset")
end

function WalkCommandStart(source, args, raw)
    local name = firstToUpper(args[1])

    if name == "Reset" then
        ResetPedMovementClipset(PlayerPedId())
        return
    end

    if tableHasKey(DP.Walks, name) then
        local name2 = table.unpack(DP.Walks[name])
        WalkMenuStart(name2)
    else
        EmoteChatMessage("'" .. name .. "' is not a valid walk")
    end
end

function tableHasKey(table, key)
    return table[key] ~= nil
end
