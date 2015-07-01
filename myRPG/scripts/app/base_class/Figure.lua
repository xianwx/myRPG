-- Figure.lua
-- 人物基类，包括玩家，NPC，怪物。
-- created by xianwx, 2015-06-30 13:57:29

local scheduler = require("framework.scheduler");
local TextureController = require("app.base_class.TextureController");

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

local TAG_ANIMATE = 123456;

local Figure = class("Figure", function ()
	return display.newSprite();
end);

function Figure:ctor(texture_type, figure_num)
	self.m_hair_ = 0;
	self.m_weapon_ = 0;
	self.m_hair_sprite_ = nil;
	self.m_weapon_sprite_ = nil;

	-- 创建出来默认的状态和朝向
	self.m_state_ = FigureState.STAND;
	self.m_direction_ = FigureDirection.DOWN;

	-- 纹理的种类（人物的种类）
	self.m_texture_type_ = texture_type;
	self.m_figure_num_ = figure_num;

	-- 人物的转率？
	self.m_rate_ = 0.5;

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

	if self.m_texture_type_ == Texture_type_path.NONE or self.m_texture_type_ == Texture_type_path.MONSTER then
		return;
	end

	-- todo 因为命名问题，hair_num 需要先转换一下
	self.m_hair_ = hair_num * 10 + self.m_figure_num_ % 10;
    TextureController.add_sprite_frame(Texture_type_path.HAIR, self.m_hair_, handler(self, self.update_myself));

	self.m_hair_sprite_ = CCSprite:create();
	self.m_hair_sprite_:setPosition(128 * 0.8, 128 * 0.8);
	self:addChild(self.m_hair_sprite_, 1, 999);

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

	if self.m_texture_type_ == Texture_type_path.NONE or self.m_texture_type_ == Texture_type_path.MONSTER then
		return;
	end

	-- 记录weapon的值
	self.m_weapon_ = weapon_num;
	TextureController.add_sprite_frame(Texture_type_path.WEAPON, self.m_weapon_, handler(self, self.update_myself));

	self.m_weapon_sprite_ = CCSprite:create();
	self.m_weapon_sprite_:setPosition(128 * 0.8, 128 * 0.8);
	self:addChild(self.m_weapon_sprite_, 1, 888);

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

local function get_frame_rate(state, frame_type)
    local frame_rate = 0

    if (frame_type == Texture_type_path.FIGURE) then
        if (state == FigureState.STAND) then
            frame_rate = 1 / 3.0;
        elseif (state == FigureState.WALK) then
            frame_rate = 0.6 / 16.0;
        elseif (state == FigureState.RUN) then
            frame_rate = 0.6 / 16.0;
        elseif (state == FigureState.ATTACK) then
            frame_rate = 1 / 8.0;
        elseif (state == FigureState.CASTER) then
            frame_rate = 1 / 8.0;
        elseif (state == FigureState.HURT) then
            frame_rate = 1 / 8.0;
        elseif (state == FigureState.DEATH) then
            frame_rate = 1 / 4.0;
        end
    end

    if (frame_type == Texture_type_path.MONSTER) then
        if (state == FigureState.Stand) then
            frame_rate = 1 / 5.0;
        elseif (state == FigureState.WALK) then
            frame_rate = 0.6 / 8.0;
        elseif (state == FigureState.RUN) then
            frame_rate = 0.6 / 8.0;
        elseif (state == FigureState.ATTACK) then
            frame_rate = 1 / 8.0;
        elseif (state == FigureState.CASTER) then
            frame_rate = 1 / 8.0;
        elseif (state == FigureState.HURT) then
            frame_rate = 1 / 8.0;
        elseif (state == FigureState.DEATH) then
            frame_rate = 1 / 8.0;
        end
    end

    return frame_rate
end

function Figure:get_run_action_from_sprite(path)
    local nDirection = self.m_direction_;
    if (8 > nDirection and nDirection > 4) then
        nDirection = 8 - nDirection
    end

    local flag = 0
    local array = CCArray:createWithCapacity(8)

    while (true) do
        local frameName = string.format("%s_%d_%d_%02d.png", path, self.m_state_, nDirection, flag)
        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
        if (not frame) then
            break
        end
        array:addObject(frame)
        flag = flag + 1
    end

    local animation = cc.Animation:createWithSpriteFrames(array, self.m_rate_);
    local animate = cc.Animate:create(animation)
    return animate
end


function Figure:update_myself()

	self.m_rate_ = get_frame_rate(self.m_state_, self.m_texture_type_);

	if self.m_direction_ == FigureDirection.LEFT or self.m_direction_ == FigureDirection.LEFTANDUP or self.m_direction_ == FigureDirection.LeftAndDown then
		self:setRotationY(180);
	else
		self:setRotationY(0);
	end

    self:run_action();
end

function Figure:run_action()

	-- 停止当前所播放的效果
	self:stopActionByTag(TAG_ANIMATE);

	local path = TextureController.get_texture_path(self.m_texture_type_, self.m_figure_num_);
	local animate = self:get_run_action_from_sprite(path);

	local delay_time;
	local callFunc_doing;
	local callFunc_end;
	local array;

	if self.m_state_ == FigureState.ATTACK then
		delay_time = cc.DelayTime:create(animate:getDuration() / 2);
		callFunc_doing = cc.CallFunc:create(handler(self, self.attack));
		callFunc_end = cc.CallFunc:create(handler(self, self.attack_complete));
		array = CCArray:create();
		array:addObject(delay_time);
		array:addObject(callFunc_doing);
		array:addObject(delay_time);
		array:addObject(callFunc_end);
		self:runAction(cc.Sequence:create(array));

		animate:setTag(TAG_ANIMATE);
		self:runAction(animate);
	elseif self.m_state_ == FigureState.CASTER then
		delay_time = cc.DelayTime:create(animate:getDuration() / 2);
		callFunc_doing = cc.CallFunc:create(handler(self, self,attack));
		callFunc_end = cc.CallFunc:create(handler(self, self.attack_complete));
		array = CCArray:create();
		array:addObject(delay_time);
		array:addObject(callFunc_doing);
		array:addObject(delay_time);
		array:addObject(callFunc_end);
		self:runAction(cc.Sequence:create(array));

		animate:setTag(TAG_ANIMATE);
		self:runAction(animate);
	elseif self.m_state_ == FigureState.HURT then
		array = CCArray:craete();
		callFunc_end = cc.CallFunc:create(handler(self, self.hurt_complete));
		array:addObject(animate);
		array:addOject(callFunc_end);
		local sequence = cc.Sequence:create(array);
		sequence:setTag(TAG_ANIMATE);
		self:runAction(sequence);
	elseif self.m_state_ == FigureState.DEATH then
		array = CCArray:create();
		array:addObject(Animate);
		array:addObject(cc.CallFunc:create(handler(self, self.death)));
		local sequence = cc.Sequence:create(array);
		sequence:setTag(TAG_ANIMATE);
		self:runAction(sequence);
	else
		-- 不停的动的动画
		local repeat_forever = cc.RepeatForever:create(animate);
		repeat_forever:setTag(TAG_ANIMATE);
		self:runAction(repeat_forever);
	end

	if self.m_hair_sprite_ then
		self.m_hair_sprite_:stopAllActions();

		path = TextureController.get_texture_path(Texture_type_path.HAIR, self.m_hair_);
		animate = self:get_run_action_from_sprite(path);

		if self.m_state_ > 3 then
			self.m_hair_sprite_:runAction(animate);
		else
			self.m_hair_sprite_:runAction(cc.RepeatForever:create(animate));
		end
	end

	if self.m_weapon_sprite_ then
		self.m_weapon_sprite_:stopAllActions();

		path = TextureController.get_texture_path(Texture_type_path.WEAPON, self.m_weapon_);
		if self.m_state_ == FigureState.DEATH then
			path = path .. string.sub(TextureController.get_texture_path(self.m_texture_type_, self.m_figure_num_), -1);
		else
			path = path .. "0";
		end

		animate = self:get_run_action_from_sprite(path);
        if self.m_state_ > 3 then
            self.m_weapon_sprite_:runAction(animate);
        else
            self.m_weapon_sprite_:runAction(cc.RepeatForever:create(animate));
        end
	end
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
