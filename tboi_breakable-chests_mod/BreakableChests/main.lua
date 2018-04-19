local TBOC = RegisterMod("TBOC", 1)
local game = Game()

local CHEST_HIT_DISTANCE = 15
local CHEST_HIT_POINTS = 12
local CHEST_KNOCKBACK_MULTIPLIER = 4
local COLOR_RED = Color(1, 0, 0, 1, 1, 1, 1)
local ISAAC_REACTS = true

-- Uncomment chest types below to enable them to be shot
local CHEST_ENTITY_VARIANTS = {
    -- PickupVariant.PICKUP_CHEST,
    -- PickupVariant.PICKUP_BOMBCHEST,
    PickupVariant.PICKUP_SPIKEDCHEST,
    -- PickupVariant.PICKUP_ETERNALCHEST,
    PickupVariant.PICKUP_MIMICCHEST,
    -- PickupVariant.PICKUP_LOCKEDCHEST
}

local ChestDestroyedAction = {
    NOTHING = 0,
    SPAWN_POOP = 1,
    OPEN_CHEST = 2,
    RANDOM = 3
}

local CHEST_DESTROYED_ACTION = ChestDestroyedAction.RANDOM

function TBOC:OnTearUpdate(tear)
    local collides = TBOC:CheckCollision(tear.Position, tear.Velocity)
    if collides == true then
        tear:Kill()
    end
end

function TBOC:OnLaserUpdate(laser)
    if laser:IsSampleLaser() then
        local samples = laser:GetNonOptimizedSamples()
        local len = samples:__len()
        for i=0,len-1,1 do
            local s = samples:Get(i)
            local collides = TBOC:CheckCollision(s, velocity)
            if collides == true then
                -- Laser doesn't die
                return
            end
        end
    end
end

function TBOC:OnKnifeUpdate(knife)
    local collides = TBOC:CheckCollision(knife.Position, knife.Velocity)
    if collides == true then
        -- Knife doesn't die
    end
end

function TBOC:OnProjectileUpdate(projectile)
    local collides = TBOC:CheckCollision(projectile.Position, projectile.Velocity)
    if collides == true then
        projectile:Kill()
    end
end

function TBOC:CheckCollision(tearPosition, velocity)
    local entities = Isaac:GetRoomEntities()
    for ei, entity in pairs(entities) do
        if entity.Type == EntityType.ENTITY_PICKUP then
            for _, variant in pairs(CHEST_ENTITY_VARIANTS) do
                if entity.Variant == variant then
                    if entity.SubType == ChestSubType.CHEST_CLOSED then
                        if entity.Position:Distance(tearPosition) < CHEST_HIT_DISTANCE then
                            local player = Isaac.GetPlayer(0)
                            local knockback = nil
                            --local knockback = tearVelocity:__div(CHEST_KNOCKBACK_MULTIPLIER)
                            TBOC:DamageChest(entity, player.Damage, knockback)
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

function TBOC:DamageChest(chest, damage, knockback)
    chest.HitPoints = chest.HitPoints - damage
    if chest.HitPoints < 1 then
        TBOC:DestroyChest(chest)
    else
        chest:SetColor(COLOR_RED, 1, 1, true, true)
        --chest:AddVelocity(knockback)
    end
end

function TBOC:OnPickupInit(pickup)
    for _, variant in pairs(CHEST_ENTITY_VARIANTS) do
        if pickup.Variant == variant then
            pickup.HitPoints = CHEST_HIT_POINTS
            if ISAAC_REACTS then
                local player = Isaac.GetPlayer(0)
                player:AnimateSad()
            end
        end
    end
end

function TBOC:DestroyChest(chest)    
    if ISAAC_REACTS then
        local player = Isaac.GetPlayer(0)
        player:AnimateHappy()
    end
    local action = CHEST_DESTROYED_ACTION
    if action == ChestDestroyedAction.RANDOM then
        local rng = chest:GetDropRNG()
        action = rng:RandomInt(ChestDestroyedAction.RANDOM)
    end

    if action == ChestDestroyedAction.NOTHING then
        -- Do nothing
        chest:Kill()
    elseif action == ChestDestroyedAction.SPAWN_POOP then
        chest:Kill()
        Isaac.GridSpawn(GridEntityType.GRID_POOP, 0, chest.Position, false)
    elseif action == ChestDestroyedAction.OPEN_CHEST then
        -- TODO: Chest opening logic
        chest:ToPickup():TryOpenChest()
    end
end

TBOC:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, TBOC.OnPickupInit)

TBOC:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, TBOC.OnTearUpdate)
TBOC:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, TBOC.OnLaserUpdate)
TBOC:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, TBOC.OnKnifeUpdate)
TBOC:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, TBOC.OnProjectileUpdate)