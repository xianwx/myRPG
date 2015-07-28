-- Monomer.lua
-- 单体类，人物，动物之类的基类
-- created by xianwx, 2015-07-06 09:24:48
local Figure = require("app.base_class.Figure");
local MapPoint = require("app.map.MapPoint");
local scheduler = require("framework.scheduler");

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

	self.m_update_vertex_y_ = 0;
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

-- 是否在移动
function Monomer:get_is_moving()
	local pos = cc.p(self:getPosition());
	local map_pos = MapPoint.new(pos);
	-- return cc.PointDistance(map_pos:get_cc_point_value(), pos) >= 5.0;
	return false;
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

    local map_point = MapPoint.new(pos.x, pos.y);

    local deque_map_point = g_cur_map:get_path_next_run_grid(map_point, ToolUtil.add(map_point, move_direction));

    print("#deque_map_point: ", #deque_map_point);

    if (#deque_map_point <= 1) then
        self:stand();
        result.is_can_not_find_the_way = true;
        return result;
    end

    local array = self:actions_with_move_to(deque_map_point);

    local callback_func_begin = cc.CallFunc:create(handler(self, self.move_by_begin));
    local callback_func_end = cc.CallFunc:create(handler(self, self.move_by_end));

    array:insertObject(callback_func_begin, 0);
    array:addObject(callback_func_end);

    local sequence = cc.Sequence:create(array);
    sequence:setTag(TAG_MOVET);
    self:runAction(sequence);

    result.float_time = sequence:getDuration();
    result.map_point = deque_map_point[#deque_map_point];

	return result;
end

function Monomer:stand()
	-- body
end

function Monomer:actions_with_move_to(deque_map_point)
	local array = CCArray:createWithCapacity(8);

    if (#deque_map_point <= 1) then
        return array;
    end

    local callfunc_start = cc.CallFunc:create(handler(self, self.start_timer_to_update_vertex_z));
    local callfunc_kill = cc.CallFunc:create(handler(self, self.kill_timer_to_update_vertex_z));

    array:addObject(callfunc_start);

    for i = 2, #deque_map_point do
        local startMPoint = deque_map_point[i - 1];
        local endMPoint = deque_map_point[i];
        array:addObjectsFromArray(self:actions_with_point(startMPoint, endMPoint));
    end

    array:addObject(callfunc_kill);

    return array;
end

function Monomer:actions_with_point(start_point, end_point)
    local callFunc = nil;

    local array = CCArray:create();

    if ToolUtil.equal_map_point(start_point, end_point) then
        return array;
    end

    local lenghtX = end_point.x - start_point.x;
    local lenghtY = end_point.y - start_point.y;
    local lenght = math.sqrt(lenghtX * lenghtX + lenghtY * lenghtY);

    local gridNumber = start_point:get_distance(end_point);
    dump(self.m_direction_, "self.m_direction_: ");
    local fTime = 0.6 * start_point:get_distance(end_point) / self.run_speed / gridNumber;

    local pointX = lenghtX / lenght;
    local pointY = lenghtY / lenght;

    local angle_X = math.acos(pointX) * 180 / math.pi;
    local angle_Y = math.acos(pointY) * 180 / math.pi;

    local angle = angle_X;
    if (angle_Y > 90) then
        angle = 360 - angle_X;
    end

    local nType = math.floor(((angle + 22.5) % 360 ) / 45.0);

    if (lenght < 2) then
        if (nType == 0) then
            callFunc = cc.CallFunc:create(handler(self, self.walk_right));
        elseif (nType == 1) then
            callFunc = cc.CallFunc:create(handler(self, self.walk_right_up));
        elseif (nType == 2) then
            callFunc = cc.CallFunc:create(handler(self, self.walk_up));
        elseif (nType == 3) then
            callFunc = cc.CallFunc:create(handler(self, self.walk_left_up));
        elseif (nType == 4) then
            callFunc = cc.CallFunc:create(handler(self, self.walk_left));
        elseif (nType == 5) then
            callFunc = cc.CallFunc:create(handler(self, self.walk_left_down));
        elseif (nType == 6) then
            callFunc = cc.CallFunc:create(handler(self, self.walk_down));
        elseif (nType == 7) then
            callFunc = cc.CallFunc:create(handler(self, self.walk_right_down));
        end
    else
        if (nType == 0) then
            callFunc = cc.CallFunc:create(handler(self, self.run_right));
        elseif (nType == 1) then
            callFunc = cc.CallFunc:create(handler(self, self.run_right_up));
        elseif (nType == 2) then
            callFunc = cc.CallFunc:create(handler(self, self.run_up));
        elseif (nType == 3) then
            callFunc = cc.CallFunc:create(handler(self, self.run_left_up));
        elseif (nType == 4) then
            callFunc = cc.CallFunc:create(handler(self, self.run_left));
        elseif (nType == 5) then
            callFunc = cc.CallFunc:create(handler(self, self.run_left_down));
        elseif (nType == 6) then
            callFunc = cc.CallFunc:create(handler(self, self.run_down));
        elseif (nType == 7) then
            callFunc = cc.CallFunc:create(handler(self, self.run_right_down));
        end
    end

    array:addObject(callFunc);

    local moveTo = cc.MoveTo:create(fTime, end_point:get_cc_point_value());
    array:addObject(moveTo);

    return array;
end

-- 走到右边
function Monomer:walk_right()
    self:set_figure_state(FigureState.WALK, FigureDirection.RIGHT);
end

-- 跑到右边
function Monomer:run_right()
    self:set_figure_state(FigureState.RUN, FigureDirection.RIGHT);
end

-- 走到右上
function Monomer:walk_right_up()
    self:set_figure_state(FigureState.WALK, FigureDirection.RIGHTANDUP);
end

-- 跑到右上
function Monomer:run_right_up()
    self:set_figure_state(FigureState.RUN, FigureDirection.RIGHTANDUP);
end

-- 走到上边
function Monomer:walk_up()
    self:set_figure_state(FigureState.WALK, FigureDirection.UP);
end

-- 跑到上边
function Monomer:run_up()
    self:set_figure_state(FigureState.RUN, FigureDirection.UP);
end

-- 走到左上
function Monomer:walk_left_up()
   self:set_figure_state(FigureState.WALK, FigureDirection.LEFTANDUP);
end

-- 跑到左上
function Monomer:run_left_up()
    self:set_figure_state(FigureState.RUN, FigureDirection.LEFTANDUP);
end

-- 走到左边
function Monomer:walk_left()
    self:set_figure_state(FigureState.WALK, FigureDirection.LEFT);
end

-- 跑到左边
function Monomer:run_left()
    self:set_figure_state(FigureState.RUN, FigureDirection.LEFT);
end

-- 走到左下
function Monomer:walk_left_down()
    self:set_figure_state(FigureState.WALK, FigureDirection.LEFTANDDOWN);
end

-- 跑到左下
function Monomer:run_left_down()
    self:set_figure_state(FigureState.RUN, FigureDirection.LEFTANDDOWN);
end

-- 走到下边
function Monomer:walk_down()
    self:set_figure_state(FigureState.WALK, FigureDirection.DOWN);
end

-- 跑到下边
function Monomer:run_down()
    self:set_figure_state(FigureState.RUN, FigureDirection.DOWN);
end

-- 走到右下
function Monomer:walk_right_down()
    self:set_figure_state(FigureState.WALK, FigureDirection.RIGHTANDDOWN);
end

-- 跑到右下
function Monomer:run_right_down()
    self:set_figure_state(FigureState.RUN, FigureDirection.RIGHTANDDOWN);
end

-- 设置人物状态
function Monomer:set_figure_state(state, direction)
    if (self.m_state_ == FigureState.DEATH) then
        return;
    end

    if (state ~= FigureState.NONE) then
        self.m_state_ = state;
    end

    if (direction ~= FigureDirection.NONE) then
        self.m_direction_ = direction;
    end

    if (self.m_figure_) then
        self.m_figure_:set_direction_and_state(state, direction);
    end
end

-- 启动更新y轴计时器
function Monomer:start_timer_to_update_vertex_z()
    self:kill_timer_to_update_vertex_z();
    self.m_update_vertex_y_ = scheduler.scheduleGlobal(handler(self, self.update_vertex_z), 0.1);
end

-- 关闭更新y轴计时器
function Monomer:kill_timer_to_update_vertex_z()
    if (self.m_update_vertex_z_) then
        scheduler.unscheduleGlobal(self.m_update_vertex_z_);
        self.m_update_vertex_z_ = nil;
    end
end

-- 更新y轴计时器回调函数
function Monomer:update_vertex_z(delay)
    local point = cc.p(self:getPosition());
    local value = ToolUtil.get_z_order(point); -- z轴

    print("value: ", value);

    self:setZOrder(value);

    -- if (not self.m_nMonomer) then
    --     return
    -- end

    -- if (g_mainScene:getCurrBgMap():getCurrentGridValue(MapPoint.new(point)) == 2) then
    --     if (self.m_nMonomer:getOpacity() == 128) then
    --         return
    --     end

    --     self.m_nMonomer:setOpacityEx(128)
    --     self.m_nMonomer:setColor(ccc3(166,166,166))
    -- else
    --     if (self.m_nMonomer:getOpacity() == 255) then
    --         return
    --     end

    --     self.m_nMonomer:setOpacityEx(255)
    --     self.m_nMonomer:setColor(ccc3(255,255,255))
    -- end
end

-- 以走动的形式移动
function Monomer:walk_to_derection(move_direction)
	-- body
end

-- 直接走到某个点
function Monomer:go_to_point(aims_point)
	-- body
end

function Monomer:move_by_begin()
	-- body
end

function Monomer:move_by_end()
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

function Monomer:get_cur_state()
	return self.m_state_;
end

return Monomer;
