local BreakableChests = RegisterMod("BreakableChests" , 1)
local game = Game()

local CHEST_HIT_DISTANCE = 15
local CHEST_HIT_POINTS = 12
local CHEST_KNOCKBACK_MULTIPLIER = 4
local COLOR_RED = Color(1, 0, 0, 1, 1, 1, 1)

function BreakableChests:onTearUpdate(tear)
    local player = Isaac.GetPlayer(0)
    local entities = Isaac:GetRoomEntities()
    for ei, entity in pairs(entities) do
        if entity.Type == EntityType.ENTITY_PICKUP then
            if entity.Variant == PickupVariant.PICKUP_SPIKEDCHEST then
                if entity.SubType == ChestSubType.CHEST_CLOSED then
                    if entity.Position:Distance(tear.Position) < CHEST_HIT_DISTANCE then
                        entity.HitPoints = entity.HitPoints - player.Damage
                        entity:AddVelocity(tear.Velocity:__div(CHEST_KNOCKBACK_MULTIPLIER))
                        tear:Kill()
                        if entity.HitPoints < 1 then
                            entity:Kill()
                        else
                            entity:SetColor(COLOR_RED, 1, 1, true, true)
                        end
                    end
                end
            end
        end
    end
end


function BreakableChests:onPickupInit(pickup)
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