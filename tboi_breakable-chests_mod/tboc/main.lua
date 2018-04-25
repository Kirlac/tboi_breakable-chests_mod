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

local CHEST_DESTROYED_ACTION = ChestDestroyedAction.OPEN_CHEST

function DebugTearFlags(value)
    Isaac.DebugString("TEAR_NORMAL: "..tostring(HasFlag(value, TearFlags.TEAR_NORMAL)))
    Isaac.DebugString("TEAR_SPECTRAL: "..tostring(HasFlag(value, TearFlags.TEAR_SPECTRAL)))
    Isaac.DebugString("TEAR_PIERCING: "..tostring(HasFlag(value, TearFlags.TEAR_PIERCING)))
    Isaac.DebugString("TEAR_HOMING: "..tostring(HasFlag(value, TearFlags.TEAR_HOMING)))
    Isaac.DebugString("TEAR_SLOW: "..tostring(HasFlag(value, TearFlags.TEAR_SLOW)))
    Isaac.DebugString("TEAR_POISON: "..tostring(HasFlag(value, TearFlags.TEAR_POISON)))
    Isaac.DebugString("TEAR_FREEZE: "..tostring(HasFlag(value, TearFlags.TEAR_FREEZE)))
    Isaac.DebugString("TEAR_SPLIT: "..tostring(HasFlag(value, TearFlags.TEAR_SPLIT)))
    Isaac.DebugString("TEAR_GROW: "..tostring(HasFlag(value, TearFlags.TEAR_GROW)))
    Isaac.DebugString("TEAR_BOMBERANG: "..tostring(HasFlag(value, TearFlags.TEAR_BOMBERANG)))
    Isaac.DebugString("TEAR_PERSISTENT: "..tostring(HasFlag(value, TearFlags.TEAR_PERSISTENT)))
    Isaac.DebugString("TEAR_WIGGLE: "..tostring(HasFlag(value, TearFlags.TEAR_WIGGLE)))
    Isaac.DebugString("TEAR_MIGAN: "..tostring(HasFlag(value, TearFlags.TEAR_MIGAN)))
    Isaac.DebugString("TEAR_EXPLOSIVE: "..tostring(HasFlag(value, TearFlags.TEAR_EXPLOSIVE)))
    Isaac.DebugString("TEAR_CHARM: "..tostring(HasFlag(value, TearFlags.TEAR_CHARM)))
    Isaac.DebugString("TEAR_CONFUSION: "..tostring(HasFlag(value, TearFlags.TEAR_CONFUSION)))
    Isaac.DebugString("TEAR_HP_DROP: "..tostring(HasFlag(value, TearFlags.TEAR_HP_DROP)))
    Isaac.DebugString("TEAR_ORBIT: "..tostring(HasFlag(value, TearFlags.TEAR_ORBIT)))
    Isaac.DebugString("TEAR_WAIT: "..tostring(HasFlag(value, TearFlags.TEAR_WAIT)))
    Isaac.DebugString("TEAR_QUADSPLIT: "..tostring(HasFlag(value, TearFlags.TEAR_QUADSPLIT)))
    Isaac.DebugString("TEAR_BOUNCE: "..tostring(HasFlag(value, TearFlags.TEAR_BOUNCE)))
    Isaac.DebugString("TEAR_FEAR: "..tostring(HasFlag(value, TearFlags.TEAR_FEAR)))
    Isaac.DebugString("TEAR_SHRINK: "..tostring(HasFlag(value, TearFlags.TEAR_SHRINK)))
    Isaac.DebugString("TEAR_BURN: "..tostring(HasFlag(value, TearFlags.TEAR_BURN)))
    Isaac.DebugString("TEAR_ATTRACTOR: "..tostring(HasFlag(value, TearFlags.TEAR_ATTRACTOR)))
    Isaac.DebugString("TEAR_KNOCKBACK: "..tostring(HasFlag(value, TearFlags.TEAR_KNOCKBACK)))
    Isaac.DebugString("TEAR_PULSE: "..tostring(HasFlag(value, TearFlags.TEAR_PULSE)))
    Isaac.DebugString("TEAR_SPIRAL: "..tostring(HasFlag(value, TearFlags.TEAR_SPIRAL)))
    Isaac.DebugString("TEAR_FLAT: "..tostring(HasFlag(value, TearFlags.TEAR_FLAT)))
    Isaac.DebugString("TEAR_SAD_BOMB: "..tostring(HasFlag(value, TearFlags.TEAR_SAD_BOMB)))
    Isaac.DebugString("TEAR_BUTT_BOMB: "..tostring(HasFlag(value, TearFlags.TEAR_BUTT_BOMB)))
    Isaac.DebugString("TEAR_GLITTER_BOMB: "..tostring(HasFlag(value, TearFlags.TEAR_GLITTER_BOMB)))
    Isaac.DebugString("TEAR_SQUARE: "..tostring(HasFlag(value, TearFlags.TEAR_SQUARE)))
    Isaac.DebugString("TEAR_GLOW: "..tostring(HasFlag(value, TearFlags.TEAR_GLOW)))
    Isaac.DebugString("TEAR_GISH: "..tostring(HasFlag(value, TearFlags.TEAR_GISH)))
    Isaac.DebugString("TEAR_SCATTER_BOMB: "..tostring(HasFlag(value, TearFlags.TEAR_SCATTER_BOMB)))
    Isaac.DebugString("TEAR_STICKY: "..tostring(HasFlag(value, TearFlags.TEAR_STICKY)))
    Isaac.DebugString("TEAR_CONTINUUM: "..tostring(HasFlag(value, TearFlags.TEAR_CONTINUUM)))
    Isaac.DebugString("TEAR_LIGHT_FROM_HEAVEN: "..tostring(HasFlag(value, TearFlags.TEAR_LIGHT_FROM_HEAVEN)))
    Isaac.DebugString("TEAR_COIN_DROP: "..tostring(HasFlag(value, TearFlags.TEAR_COIN_DROP)))
    Isaac.DebugString("TEAR_BLACK_HP_DROP: "..tostring(HasFlag(value, TearFlags.TEAR_BLACK_HP_DROP)))
    Isaac.DebugString("TEAR_TRACTOR_BEAM: "..tostring(HasFlag(value, TearFlags.TEAR_TRACTOR_BEAM)))
    Isaac.DebugString("TEAR_GODS_FLESH: "..tostring(HasFlag(value, TearFlags.TEAR_GODS_FLESH)))
    Isaac.DebugString("TEAR_GREED_COIN: "..tostring(HasFlag(value, TearFlags.TEAR_GREED_COIN)))
    Isaac.DebugString("TEAR_MYSTERIOUS_LIQUID_CREEP: "..tostring(HasFlag(value, TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP)))
    Isaac.DebugString("TEAR_BIG_SPIRAL: "..tostring(HasFlag(value, TearFlags.TEAR_BIG_SPIRAL)))
    Isaac.DebugString("TEAR_PERMANENT_CONFUSION: "..tostring(HasFlag(value, TearFlags.TEAR_PERMANENT_CONFUSION)))
    Isaac.DebugString("TEAR_BOOGER: "..tostring(HasFlag(value, TearFlags.TEAR_BOOGER)))
    Isaac.DebugString("TEAR_EGG: "..tostring(HasFlag(value, TearFlags.TEAR_EGG)))
    Isaac.DebugString("TEAR_ACID: "..tostring(HasFlag(value, TearFlags.TEAR_ACID)))
    Isaac.DebugString("TEAR_BONE: "..tostring(HasFlag(value, TearFlags.TEAR_BONE)))
    Isaac.DebugString("TEAR_BELIAL: "..tostring(HasFlag(value, TearFlags.TEAR_BELIAL)))
    Isaac.DebugString("TEAR_MIDAS: "..tostring(HasFlag(value, TearFlags.TEAR_MIDAS)))
    Isaac.DebugString("TEAR_NEEDLE: "..tostring(HasFlag(value, TearFlags.TEAR_NEEDLE)))
    Isaac.DebugString("TEAR_JACOBS: "..tostring(HasFlag(value, TearFlags.TEAR_JACOBS)))
    Isaac.DebugString("TEAR_HORN: "..tostring(HasFlag(value, TearFlags.TEAR_HORN)))
    Isaac.DebugString("TEAR_LASER: "..tostring(HasFlag(value, TearFlags.TEAR_LASER)))
    Isaac.DebugString("TEAR_POP: "..tostring(HasFlag(value, TearFlags.TEAR_POP)))
    Isaac.DebugString("TEAR_ABSORB: "..tostring(HasFlag(value, TearFlags.TEAR_ABSORB)))
    Isaac.DebugString("TEAR_LASERSHOT: "..tostring(HasFlag(value, TearFlags.TEAR_LASERSHOT)))
    Isaac.DebugString("TEAR_LUDOVICO: "..tostring(HasFlag(value, TearFlags.TEAR_LUDOVICO)))
end

function HasFlag(value, flag)
    return value & flag == flag
end

function TBOC:OnTearUpdate(tear)
    local collides = TBOC:CheckCollision(tear.Position, tear.Velocity)
    if collides == true then
        local tearFlags = tear.TearFlags
        if HasFlag(tearFlags, TearFlags.TEAR_SPECTRAL) 
        or HasFlag(tearFlags, TearFlags.TEAR_PIERCING) then
            Isaac.DebugString("Pass through")
        elseif HasFlag(tearFlags, TearFlags.TEAR_BOUNCE) then
           Isaac.DebugString("Bouncy!")
        else
            tear:Kill()
        end
    end
end

function TBOC:OnLaserUpdate(laser)
    if laser:IsSampleLaser() then
        local samples = laser:GetNonOptimizedSamples()
        local len = samples:__len()
        for i=0,len-1,1 do
            local s = samples:Get(i)
            -- Get previous/next sample to calculate velocity
            local velocity
            if (i > 1) then
                -- Calculate difference between this sample and previous
                velocity = s:__sub(samples:Get(i-1))
            else
                -- Calculate difference between next sample and this one
                velocity =  samples:Get(i+1):__sub(s)
            end
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
                            local knockback = velocity:__div(CHEST_KNOCKBACK_MULTIPLIER)
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
        chest:AddVelocity(knockback)
    end
end

function TBOC:OnPickupInit(pickup)
    for _, variant in pairs(CHEST_ENTITY_VARIANTS) do
        if pickup.Variant == variant then
            pickup.HitPoints = CHEST_HIT_POINTS
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