local BreakableChests = RegisterMod("BreakableChests" , 1)
local game = Game()

function BreakableChests:onPickupInit(pickup)
    if pickup.Variant == PickupVariant.PICKUP_SPIKEDCHEST
    or pickup.Variant == PickupVariant.PICKUP_MIMICCHEST then
        --pickup.HitPoints = 12
    end
end

function BreakableChests:onPickupCollision(pickup, collider)
    if pickup.Variant == PickupVariant.PICKUP_SPIKEDCHEST
    or pickup.Variant == PickupVariant.PICKUP_MIMICCHEST then
        if collider.Type == EntityType.ENTITY_TEAR
        or collider.Type == EntityType.ENTITY_LASER 
        or collider.Type == EntityType.ENTITY_KNIFE then
            --return true
            return false
        else
            return nil
        end
    end
end

function BreakableChests:onEntityKilled(entity)
    if (entity.Type == EntityType.ENTITY_PICKUP) then
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
BreakableChests:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, BreakableChests.onPickupCollision)
BreakableChests:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, BreakableChests.onEntityKilled)