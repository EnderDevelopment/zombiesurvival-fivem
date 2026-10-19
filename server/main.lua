-- Server-side script for Zombie Survival Server

-- Variables
local players = {}
local zombies = {}

-- Function to handle player death
local function handlePlayerDeath(playerId)
    DropPlayer(playerId, 'You have been infected and died.')
end

-- Function to spawn zombies
local function spawnZombie()
    local x, y, z = math.random(-1000, 1000), math.random(-1000, 1000), 0.0
    local zombie = CreatePed(4, GetHashKey('a_m_m_hillbilly_01'), x, y, z, 0.0, true, true)
    SetPedCombatAttributes(zombie, 46, true)
    SetPedFleeAttributes(zombie, 0, 0)
    SetPedCombatAbility(zombie, 100)
    SetPedCombatRange(zombie, 2)
    SetPedCombatMovement(zombie, 3)
    SetPedSeeingRange(zombie, 100.0)
    SetPedHearingRange(zombie, 100.0)
    SetPedAlertness(zombie, 3)
    SetPedAccuracy(zombie, 100)
    SetPedCanRagdoll(zombie, true)
    SetPedCanBeKnockedOffVehicle(zombie, true)
    SetPedDiesWhenInjured(zombie, true)
    SetPedRelationshipGroupHash(zombie, GetHashKey('HATES_PLAYER'))
    table.insert(zombies, zombie)
end

-- Event handlers
RegisterNetEvent('playerDied')
AddEventHandler('playerDied', function()
    handlePlayerDeath(source)
end)

RegisterNetEvent('requestZombieSpawn')
AddEventHandler('requestZombieSpawn', function()
    spawnZombie()
    TriggerClientEvent('spawnZombie', -1)
end)

-- Player events
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local playerId = source
    players[playerId] = { health = 100, armor = 0 }
end)

AddEventHandler('playerDropped', function(reason)
    local playerId = source
    players[playerId] = nil
end)

-- Main thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for playerId, playerData in pairs(players) do
            local ped = GetPlayerPed(playerId)
            playerData.health = GetEntityHealth(ped) - 100
            playerData.armor = GetPedArmour(ped)
            TriggerClientEvent('updatePlayerHealth', playerId, playerData.health, playerData.armor)
        end
    end
end)