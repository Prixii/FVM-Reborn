function RegisterAmiyaMod()
    RegisterCard()
end

RegisterAmiyaMod()

SECOND = 1

function GML_RegisterCard(cardData)

end

function RegisterCard()
    local _spriteSheet1 = {
        path = "mods/amiya_mod_texture_1.png",
        frameCount = 20,
    }
    local _spriteSheet2 = {
        path = "mods/amiya_mod_texture_2.png",
        frameCount = 4,
    }

    local _attackAnimation = {
        spriteSheet = _spriteSheet1,
        start_frame = 0,
        end_frame = 8,
    }

    local _idleAnimation = {
        spriteSheet = _spriteSheet1,
        start_frame = 9,
        end_frame = 20,
    }


    local _bulletAnimation = {
        spriteSheet = _spriteSheet2,
        start_frame = 0,
        end_frame = 4,
    }

    local _bullet = {
        damage = {
            type = "single",
            atk = 20,
        },
        animation = _bulletAnimation,
        kinematic = {
            speed = 5,
            direction = "forward",
        },
        tags = { "projectile", "magic" },
    }

    local _skillInfo = {
        key = "atk",
        data = { 20, 30, 40, 50, 60, 70, 100, 90, 110, 120, 130, 140 }
    }

    local _cardData = {
        name = "阿米娅",
        id = "amiya",
        description = "罗德岛尊贵的CEO",
        infoIslandDescription = "这可是罗德岛尊贵的CEO口牙",
        defaultBullets = { _bullet },
        attack_layer = { "ground", "air" },
        attack_area = {
            type = "line",
            direction = "forward",
            distance = 9,
        },
        defaultHp = 100,
        defaultCost = 325,
        defaultAtk = 20,
        defaultCooldown = 20 * SECOND,
        defaultCycle = 1 * SECOND,
        plantType = "normal",
        featureType = "normal",
        targetCard = "none",
        attackAnimation = _attackAnimation,
        idleAnimation = _idleAnimation,
        skillInfo = _skillInfo
    }

    GML_RegisterCard(_cardData)
end
