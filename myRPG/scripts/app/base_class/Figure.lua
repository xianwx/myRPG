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
	self.m_weapon_sprite_ = nil;

	-- 创建出来默认的状态和朝向
	self.m_state_ = FigureState.STAND;
	self.m_direction_ = FigureDirection.DOWN;

	self.m_hp_ = 0;
end

-- 设置头发
function Figure:set_hair(hair_num)

	-- 如果已经有头发的存在，则重置
	if self.m_hair_sprite_ then
		self.m_hair_ = 0;
		self.m_hair_sprite_:removeFromParent();
		self.m_hair_sprite_ = nil;
	end

	-- todo 判断一下，如果是怪物则不创建头发（因为怪物全是动物）

	-- todo 因为命名问题，hair_num 需要先转换一下

	self.m_hair_sprite_ = CCSprite:create();
	self.m_hair_sprite_:setPosition(128 * 0.8, 128 * 0.8);
	self:addChild(self.m_hair_sprite_, 1, "hair");

	-- 交予update的时候再图片指定上去
end

-- 设置武器
function Figure:set_weapon(weapon_num)

	-- 如果已经有武器的存在，则重置
	if self.m_weapon_sprite_ then
		self.m_weapon_ = 0;
		self.m_weapon_sprite_:removeFromParent();
		self.m_weapon_sprite_ = nil;
	end

	-- todo 如果是怪物，则不加上武器（因为怪物都是动物）

	-- 记录weapon的值
	self.m_weapon_ = weapon_num;

	self.m_weapon_sprite_ = CCSprite:create();
	self.m_weapon_sprite_:setPosition(128 * 0.8, 128 * 0.8);
	self:addChild(self.m_weapon_sprite_, 1, "weapon");

	-- 交予update函数将图片加上
end

-- 设置状态和方向
function Figure:set_direction_and_state(state, direction)
	self.m_state_ = state;
	self.m_direction_ = direction;

	local changed = false;

	if state and state ~= FigureState.NONE and state ~= self.m_state_ then
		self.m_state_ = state;
		changed = true;
	end

	if direction and direction ~= FigureDirection.NONE and direction ~= self.m_direction_ then
		self.m_direction_ = direction;
		changed = true;
	end

	if changed then
		self:update_myself();
	end
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
