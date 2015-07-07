-- Monomer.lua
-- 单体类，人物，动物之类的基类
-- created by xianwx, 2015-07-06 09:24:48
local Figure = require("app.base_class.Figure");

local Monomer = class("Monomer", function ()
	return display.newSprite();
end)

function Monomer:ctor()

	-- 血量以及蓝量
	self.m_hp_ = 0;
	self.m_mp_ = 0;

	self.run_speed = 5;
	self.walk_speed = 1;

	self.m_direction_ = FigureDirection.DOWN;
	self.m_state_ = FigureState.STAND;

	self.m_figure_id_ = 0;
	self.m_texture_type_ = 0;

	self.m_figure_ = nil;
end

function Monomer:onEnter()
	print("Monomer:onEnter()");
end

function Monomer:set_hair(hair_id)

	-- 人物才有头发
	if self.m_texture_type_ ~= Texture_type_path.FIGURE then
		return;
	end

	if hair_id then
		self.m_hair_id_ = hair_id;
	end

	if self.m_figure_ then
		self.m_figure_:set_hair(hair_id);
	end
end

function Monomer:set_weapon(weapon_num)
	-- 人物才有武器
	if self.m_texture_type_ ~= Texture_type_path.FIGURE then
		return;
	end

	if weapon_num then
		self.m_weapon_num_ = weapon_num;
	end

	if self.m_figure_ then
		self.m_figure_:set_weapon(weapon_num);
	end
end

-- 设置纹理类型以及要创建的人物的id
function Monomer:set_figure_num_and_texture_type(figure_id, texture_type)

	if figure_id then
		self.m_figure_id_ = figure_id;
	end

	if texture_type then
		self.m_texture_type_ = texture_type;
	end

	if self.m_figure_ then
		self:hide_and_clean_figure();
		self:show_figure();
	end
end

function Monomer:runBy(mpoint)
    local pos = cc.p(self:getPosition())
    local relust = MoveInfo.new(0.0, MapPoint.new(pos), false)

    if (self.m_bIsCanMoved == false) then
        return relust
    end

    local nState = self:getState()
    if (nState == FigureState.Death or
        nState == FigureState.Attack or
        nState == FigureState.Caster or
        nState == FigureState.Hurt) then
        return relust
    end

    if (self:isMoveRunning()) then
        return relust
    end

    self:stopActionByTag(TAG_MOVET)
    self:stopActionByTag(TAG_FOLLOWATTACK)
    self:stopActionByTag(TAG_COOLINGTIMEATTACK)

    local mpos = MapPoint.new(pos)

    local dequeMPoint = g_mainScene:getPathNextRunGrid(mpos, MapPoint.add(mpos, mpoint))

    if (#dequeMPoint <= 1) then
        self:stand()
        relust.bIsCanNotFineTheWay = true
        return relust
    end

    local array = self:actionsWithMoveTo(dequeMPoint)

    local callFunc = cc.CallFunc:create(handler(self, self.moveByBegin))
    local callFunc2 = cc.CallFunc:create(handler(self, self.moveByEnd))
    array:insertObject(callFunc, 0)
    array:addObject(callFunc2)

    local sequence = cc.Sequence:create(array)
    sequence:setTag(TAG_MOVET)
    self:runAction(sequence)

    relust.fTime = sequence:getDuration()
    relust.mpoint = dequeMPoint[#dequeMPoint]

    return relust
end

-- 是否在移动
function Monomer:get_is_moving()
	local pos = cc.p(self:getPosition());
	local map_pos = MapPoint.new(pos);
	return cc.PoingtDistance(map_pos:getCCPointValue(), pos) >= 5.0;
end

-- 以跑动的形式移动
function Monomer:run_to_derection(move_direction)
	local pos = cc.p(self:getPosition());
	local result = { time = 0.0, map_point = MapPoint.new(pos), is_can_not_find_the_way = false };

	if self:get_is_moving() or
	   self.m_state_ == FigureState.DEATH or
	   self.m_state_ == FigureState.ATTACK or
	   self.m_state_ == FigureState.HURT or
	   self.m_state_ == FigureState.CASTING then
		return result;
	end

	self:stopActionByTag(TAG_MOVET);

	-- 有攻击之后再加上
	-- self:stopActionByTag(TAG_FOLLOWATTACK);
	-- self:stopActionByTag(TAG_COOLINGTIMEATTACK);

	return result;
end

-- 以走动的形式移动
function Monomer:walk_to_derection(move_direction)
	-- body
end

-- 直接走到某个点
function Monomer:go_to_point(aims_point)
	-- body
end

function Monomer:onEnter()
	self:show_figure();
end

function Monomer:onExit()
	-- body
end

function Monomer:show_figure()

	if self.m_figure_ then
		return;
	end

	self.m_figure_ = Figure.new();
	self.m_figure_:set_texture_type_and_num(self.m_texture_type_, self.m_figure_id_);
	self.m_figure_:set_hair(self.m_hair_id_);
	self.m_figure_:set_weapon(self.m_weapon_num_);
	self.m_figure_:setPosition(GRID_SIZE.width, GRID_SIZE.height);
	self:addChild(self.m_figure_);

	self:setContentSize(self.m_figure_:getContentSize());
    self:setAnchorPoint(0, 0);
    local size = self:getContentSize();
    self.m_figure_:setDelegate(self);
end

function Monomer:get_my_figure()
	return self.m_figure_;
end

function Monomer:hide_and_clean_figure()

end

return Monomer;
