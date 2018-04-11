local BreakableChests = RegisterMod("BreakableChests" , 1)
local game = Game()

local CHEST_HIT_DISTANCE = 15
local CHEST_HIT_POINTS = 12
local CHEST_KNOCKBACK_MULTIPLIER = 4
local COLOR_RED = Color(1, 0, 0, 1, 1, 1, 1)

-- Uncomment chest types below to enable them to be shot
local CHEST_ENTITY_VARIANTS = {
    -- PickupVariant.PICKUP_CHEST,
    -- PickupVariant.PICKUP_BOMBCHEST,
    PickupVariant.PICKUP_SPIKEDCHEST,
    -- PickupVariant.PICKUP_ETERNALCHEST,
    PickupVariant.PICKUP_MIMICCHEST,
    -- PickupVariant.PICKUP_LOCKEDCHEST
}

local CHEST_DESTROYED_ACTION = ChestDestroyedAction.RANDOM

local ChestDestroyedAction = {
    NOTHING = 0,
    SPAWN_POOP = 1,
    OPEN_CHEST = 2,
    RANDOM = 3
}

function BreakableChests:OnTearUpdate(tear)
    local player = Isaac.GetPlayer(0)
    local entities = Isaac:GetRoomEntities()
    for ei, entity in pairs(entities) do
        if entity.Type == EntityType.ENTITY_PICKUP then
            for _, variant in pairs(CHEST_ENTITY_VARIANTS) do
                if entity.Variant == variant then
                    if entity.SubType == ChestSubType.CHEST_CLOSED then
                        if entity.Position:Distance(tear.Position) < CHEST_HIT_DISTANCE then
                            local knockback = tear.Velocity:__div(CHEST_KNOCKBACK_MULTIPLIER)
                            BreakableChests.DamageChest(entity, player.Damage, knockback)
                            tear:Kill()
                            return
                        end
                    end
                end
            end
        end
    end
end

function BreakableChests.DamageChest(chest, damage, knockback)
    chest.HitPoints = chest.HitPoints - damage
    chest:AddVelocity(knockback)
    if chest.HitPoints < 1 then
        chest:Kill()
    else
        chest:SetColor(COLOR_RED, 1, 1, true, true)
    end
end

function BreakableChests:OnPickupInit(pickup)
    if pickup.Variant == PickupVariant.PICKUP_SPIKEDCHEST
    or pickup.Variant == PickupVariant.PICKUP_MIMICCHEST then
        pickup.HitPoints = CHEST_HIT_POINTS
    end
end


function BreakableChests:onEntityKilled(entity)
    if entity.Type == EntityType.ENTITY_PICKUP then
        if entity.Variant == PickupVariant.PICKUP_SPIKEDCHEST
        or entity.Variant == PickupVariant.PICKUP_MIMICCHEST then
            local pos = entity.Position
            Isaac.GridSpawn(GridEntityType.GRID_POOP, 0, pos, false)
        else
            return nil
        end
    end
end

BreakableChests:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, BreakableChests.onPickupInit)
BreakableChests:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, BreakableChests.onTearUpdate)
BreakableChests:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, BreakableChests.onEntityKilled)