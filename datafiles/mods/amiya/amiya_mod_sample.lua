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

function RegisterStage()
    -- 与 datafiles/sdk/stove_asset_manager.lua 中枚举值一致（避免 GMLua 上 StoveAssetManager.x.y 链式索引异常）
    local AS_IN_GAME = 0x00
    local MUS_PRE = 0x2000
    local MUS_ELITE = 0x2001
    local MUS_BOSS = 0x2002
    local SPR_PUDDING_NIGHT = 0x1008
    --- @class (partial) StoveAsset
    local preMusic = {
        ["source"] = AS_IN_GAME,
        ["gmlAsset"] = MUS_PRE
    }
    --- @class (partial) StoveAsset
    local eliteMusic = {
        ["source"] = AS_IN_GAME,
        ["gmlAsset"] = MUS_ELITE
    }
    --- @class (partial) StoveAsset
    local bossMusic = {
        ["source"] = AS_IN_GAME,
        ["gmlAsset"] = MUS_BOSS
    }
    --- @class (partial) StoveAsset
    local background = {
        ["source"] = AS_IN_GAME,
        ["gmlAsset"] = SPR_PUDDING_NIGHT
    }
    --- @class (partial) StageMetaData
    local stageMetaData = {
        ["name"] = "test_stage",
        ["description"] = "test stage",
        ["preMusic"] = preMusic,
        ["eliteMusic"] = eliteMusic,
        ["bossMusic"] = bossMusic,
        ["background"] = background,
        ["author"] = "Wis'adel",
        ["jsonPath"] = "tower-9-2_hard.json"
    }

    Stove.RegisterModStage(stageMetaData)
end

function AmiyaMain()
    print("Hello! Here is Amiya Mod!")
    -- RegisterCard()
    RegisterStage()
end
