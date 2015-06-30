-- Figure.lua
-- 人物基类，包括玩家，NPC，怪物。
-- created by xianwx, 2015-06-30 13:57:29

-- 人物的状态
FigureState = {
	DEATH     = 7,  -- 死亡
    HURT      = 6,  -- 伤害
    CASTING   = 5,  -- 投掷
    ATTACK    = 4,  -- 攻击
    RUN       = 3,  -- 跑
    WALK      = 2,  -- 走
    STAND     = 1,  -- 站立
    NONE      = -1
};

-- 人物的朝向
FigureDirection = {
	UP              = 8,    -- 上
    LEFTANDUP       = 7,    -- 左上
    LEFT            = 6,    -- 左
    LEFTANDDOWN     = 5,    -- 左下
    DOWN            = 4,    -- 下
    RIGHTANDDOWN    = 3,    -- 右下
    RIGHT           = 2,    -- 右
    RIGHTANDUP      = 1,    -- 右上
    NONE            = 0
}

local Figure = class("Figure", function ()
	return display.newSprite();
end);

function Figure:ctor()
	self.m_hair_ = 0;
	self.m_weapon_ = 0;
	self.m_hair_sprite_ = nil;
	self.m_weapon_sptite_ = nil;

	-- 创建出来默认的状态和朝向
	self.m_state_ = FigureState.STAND;
	self.m_direction_ = FigureDirection.DOWN;

	self.m_hp_ = 0;
end

-- 设置头发
function Figure:set_hair(hair_num)
	self.m_hair_ = hair_num;

	-- todo,根据num创建sprite
end

-- 设置武器
function Figure:set_weapon(weapon_num)
	self.m_weapon_ = weapon_num;

	-- todo,根据num创建srpite
end

-- 设置状态和方向
function Figure:set_direction_and_state(state, direction)
	self.m_state_ = state;
	self.m_direction_ = direction;

	self:update_myself();
end

function Figure:update_myself()
	-- todo 重新创建武器，头发，设置状态朝向等
end

function Figure:run_action()
	-- todo 播放动画
end

-- 攻击
function Figure:attack()

end

-- 攻击完成
function Figure:attack_complete()
	-- todo 减少蓝或者一些Buff
end

-- 被击伤
function Figure:hurted(...)
	-- todo 减少hp
end

-- 被击伤完毕
function Figure:hurt_complete(...)
	-- body
end

-- 死亡
function Figure:death(...)
	self.m_hp_ = 0;

	-- todo 播放死亡特效
end

return Figure;
