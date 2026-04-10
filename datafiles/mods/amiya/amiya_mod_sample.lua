function RegisterCard()
    local _spriteSheet1 = {
        ["path"] = "amiya_sheet.png",
        ["frameCount"] = 29
    }

    local _attackAnimation = {
        ["spriteSheet"] = _spriteSheet1,
        ["startFrame"] = 0,
        ["endFrame"] = 12
    }

    local _idleAnimation = {
        ["spriteSheet"] = _spriteSheet1,
        ["startFrame"] = 13,
        ["endFrame"] = 24
    }

    local _skillInfo = {
        ["key"] = "atk",
        ["data"] = { 20, 30, 40, 50, 60, 70, 100, 90, 110, 120, 130, 140 }
    }

    local _basicInfo = {
        ["name"] = "阿米娅",
        ["shape"] = 0,
        ["description"] = "罗德岛尊贵的CEO",
        ["defaultHp"] = 100,
        ["defaultCost"] = 325,
        ["defaultAtk"] = 20,
        ["defaultCooldown"] = 20 * StoveConstant.SECOND,
        ["foodType"] = "normal",
        ["featureType"] = "normal",
        ["targetFood"] = "none"
    }

    local _animatable = {
        ["idleAnimation"] = _idleAnimation,
        ["attackAnimation"] = _attackAnimation
    }

    local _attackable = {
        ["attackLayer"] = { "ground" },
        ["defaultBullets"] = {},
        ["attackArea"] = {
            ["type"] = "line",
            ["direction"] = "forward",
            ["distance"] = 100
        },
        ["defaultCycle"] = 1000
    }

    local _shapedCardData = {
        ["basicInfo"] = _basicInfo,
        ["animatable"] = _animatable,
        ["attackable"] = _attackable
    }

    local _amiyaMetaData = {
        ["id"] = "amiya",
        ["infoIslandDescription"] = "这可是罗德岛尊贵的CEO口牙",
        ["skillInfo"] = _skillInfo,
        ["shapedCardDatas"] = { _shapedCardData },
        ["tags"] = { "tag1", "tag2" }
    }

    Stove.RegisterModFood(_amiyaMetaData)
end

function AmiyaMain()
    print("Hello! Here is Amiya Mod!")
    -- RegisterCard()
end
