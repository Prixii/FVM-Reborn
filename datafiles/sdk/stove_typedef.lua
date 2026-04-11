---@meta

-- FOOD

---@class SpriteSheet
---@field path string 图片路径
---@field frameCount integer 帧数
local _spriteSheet = {}

---@class AnimationClip
---@field spriteSheet SpriteSheet 雪碧图配置
---@field start_frame integer 起始帧
---@field end_frame integer 结束帧
local _animationClip = {}

---@class SkillInfo
---@field key string 技能标识
---@field data number[] 技能数据数值列表
local _skillInfo = {}

---@class FoodBasicInfo
---@field name string 名称
---@field shape integer 形状标识
---@field description string 描述
---@field defaultHp number 初始生命值
---@field defaultCost number 初始消耗
---@field defaultCooldown number 初始冷却时间
---@field foodType string 植物类型
---@field featureType string 特性类型
---@field targetFood string 目标食物
local _foodBasicInfo = {}

---@class FoodAnimatable
---@field idleAnimation AnimationClip 待机动画
---@field attackAnimation AnimationClip 攻击动画
local _foodAnimatable = {}

---@class Damage
---@field type string 伤害类型 (例如 "single")
---@field atk number 攻击力数值
local _damage = {}

---@class Kinematic
---@field speed number 移动速度
---@field direction string 移动方向
local _kinematic = {}

---@class Bullet
---@field damage Damage 伤害配置
---@field kinematic Kinematic 运动学配置
---@field tags string[] 标签列表 (如 "projectile", "magic")
local _bullet = {}

---@class AttackArea
---@field type string 区域类型 (如 "line")
---@field direction string 方向
---@field distance number 距离/范围
local _attackArea = {}

---@class FoodAttackable
---@field attackLayer string[] 攻击层级 (如 "ground", "air")
---@field defaultBullets Bullet[] 默认子弹列表
---@field attackArea AttackArea 攻击范围配置
---@field defaultCycle number 默认攻击周期 (单位通常为毫秒或秒)
local _foodAttackable = {}

---@class ShapedCardData
---@field basicInfo FoodBasicInfo 基础信息
---@field animatable FoodAnimatable 动画配置
---@field attackable FoodAttackable 战斗配置
local _shapedCardData = {}

---@class FoodMetaData
---@field id string 唯一标识符
---@field infoIslandDescription string 详情描述
---@field skillInfo SkillInfo 技能信息
---@field shapedCardDatas ShapedCardData[] 多形态/配置数据列表
---@field tags string[] 标签
local _foodMetaData = {}

-- STAGE

---@alias StoveAssetManager.AssetSource integer
---@alias StoveAssetManager.OriginalMusic integer
---@alias StoveAssetManager.OriginalSprite integer

---@class StoveAsset
---@field source StoveAssetManager.AssetSource 资源来源
---@field path string 资源路径
---@field gmlAsset StoveAssetManager.OriginalSprite 原生资源
local _asset = {}

---@class StageMetaData
---@field name string 关卡名称
---@field description string 关卡描述
---@field preMusic StoveAsset 音乐
---@field eliteMusic StoveAsset 音乐
---@field bossMusic StoveAsset 音乐
---@field background StoveAsset 背景
---@field author string 作者
---@field jsonPath string JSON 资源路径
local _stageMetaData = {}
