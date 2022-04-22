isInRagdoll = false
local cooldown = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if isInRagdoll then
            SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
        end
    end
end)

for _, command in pairs({"ragdoll", "suelo"}) do
	RegisterKeyMapping(command, "/suelo || /ragdoll", "keyboard", Config.RagdollKeybind)
    RegisterCommand(command, function()
        ragdoll()
    end)
end

function ragdoll()
    if not cooldown and Config.RagdollEnabled and IsPedOnFoot(PlayerPedId()) then
        cooldown = true
        isInRagdoll = not isInRagdoll
        Citizen.Wait(2000)
        cooldown = false
    end
end