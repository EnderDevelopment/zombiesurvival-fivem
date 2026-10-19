-- Client-side script for Zombie Survival Server

-- Variables
local playerHealth = 100
local playerArmor = 0
local zombies = {}

-- Function to spawn zombies
local function spawnZombie()
    local x, y, z = GetEntityCoords(PlayerPedId())
    local zombie = CreatePed(4, GetHashKey('a_m_m_hillbilly_01'), x + math.random(-10, 10), y + math.random(-10, 10), z, 0.0, true, true)
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
    TaskCombatPed(zombie, PlayerPedId(), 0, 16)
    table.insert(zombies, zombie)
end

-- Function to handle player damage
local function handlePlayerDamage()
    if playerHealth <= 0 then
        TriggerServerEvent('playerDied')
    end
end

-- Event handlers
RegisterNetEvent('spawnZombie')
AddEventHandler('spawnZombie', function()
    spawnZombie()
end)

RegisterNetEvent('updatePlayerHealth')
AddEventHandler('updatePlayerHealth', function(health, armor)
    playerHealth = health
    playerArmor = armor
    handlePlayerDamage()
end)

-- Main thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if #zombies < 10 then
            TriggerServerEvent('requestZombieSpawn')
        end
    end
end)