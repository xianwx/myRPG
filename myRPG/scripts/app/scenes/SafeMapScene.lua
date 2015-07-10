-- SafeMapScene.lua
-- 城镇地图的类
-- created by xianwx, 2015-07-02 14:23:04

-- todo, 先创建建筑，道路，可移动，无NPC
-- todo, 加上A星寻路

local SimpleMapMgr = require("app.map.SimpleMapMgr");
local Figure = require("app.base_class.Figure");
local Player = require("app.base_class.Player");
local AStarPath = require("app.map.AStarPath");
local MapPoint = require("app.map.MapPoint");

local SafeMapScene = class("SafeMapScene", function ()
	return display.newScene("SafeMapScene");
end)

function SafeMapScene:ctor()

end

function SafeMapScene:onEnter()

	self.m_player_go_to_point_ = cc.p(0, 0);

	self.m_bg_map_ = SimpleMapMgr.new();
	self.m_bg_map_:create_map(200);

	self:addChild(self.m_bg_map_, -1);

	self.m_player_ = Player.new();
	self.m_player_:set_detail(GameData.figure, GameData.hair, GameData.weapon);
	self.m_player_:retain();
	self.m_player_:show_figure();

	self:addChild(self.m_player_, 1);

	if not g_player then
		g_player = self.m_player_;
	end

	g_cur_map = self;

	self.m_touch_layer_ = display.newLayer();
	self.m_touch_layer_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
		if event.name == "began" then
			return self:on_touch_began(event);
		elseif event.name == "moved" then
			self:on_touch_moved(event);
		elseif event.name == "ended" then
			self:on_touch_ended(event);
		elseif event.name == "cancel" then
			self:on_touch_cancel(event);
		end
	end)
	self.m_touch_layer_:setTouchEnabled(true);
	self:addChild(self.m_touch_layer_, -10000);

	self.m_player_is_on_moving_action_ = false;
end

-- 触摸开始
function SafeMapScene:on_touch_began(event)

	local point = cc.p(event.x, event.y);
    point = self.m_bg_map_:convertToNodeSpace(point);

    self.m_player_direction_ = self.m_bg_map_:convertToWorldSpace(point);
    self:start_player_move_action();
	return true;
end

-- 触摸移动
function SafeMapScene:on_touch_moved(event)

	-- moved发生的前提是，touch事件已经发生，也就是移动动画已经在播放中
	if not self.m_player_is_on_moving_action_ then
		return;
	end

	-- todo, 应该是不等于.run才对
	if self.m_player_:get_cur_state() ~= FigureState.STAND then
		return;
	end

	local point = cc.p(event.x, event.y);
	point = self.m_bg_map_:convertToNodeSpace(point);
	self.m_player_go_to_point_ = self.m_bg_map_:convertToWorldSpace(point);
	self:start_player_move_action();
end

-- 触摸结束
function SafeMapScene:on_touch_ended(event)
	self:stop_player_move_action();
end

-- 触摸取消
function SafeMapScene:on_touch_cancel(event)
	if self.m_player_is_on_moving_action_ then
		self:stop_player_move_action();
	end
end

function SafeMapScene:get_move_direction()
    local relust;

    local ptBegin = cc.p(self.m_player_:getPosition());
    local ptEnd = cc.p(self.m_bg_map_:convertToNodeSpace(self.m_player_direction_));

    local lenghtX = ptEnd.x - ptBegin.x;
    local lenghtY = ptEnd.y - ptBegin.y;
    local lenght = cc.PointDistance(ptBegin, ptEnd);
    local angle_X = math.acos(lenghtX / lenght) * 180 / math.pi;
    local angle_Y = math.acos(lenghtY / lenght) * 180 / math.pi;

    local angle = angle_X;
    if (angle_Y > 90) then
        angle = 360 - angle_X;
    end
    angle = angle * (math.pi / 180);
    local x = math.cos(angle);
    local y = math.sin(angle);
    local tan = math.abs(math.tan(angle));
    local tanMin = math.tan(22.5 * math.pi / 180);
    local tanMax = math.tan(67.5 * math.pi / 180);

    if (tanMin <= tan and tan < tanMax) then
        relust = MapPoint.new(x / math.abs(x), y / math.abs(y));
    elseif (tan < tanMin) then
        relust = MapPoint.new(x / math.abs(x), 0);
    else
        relust = MapPoint.new(0, y / math.abs(y));
    end

    relust = ToolUtil.mul(relust, 2);
    return relust;
end

-- 做人物的移动
function SafeMapScene:start_player_move_action()

	self.m_player_is_on_moving_action_ = true;

	-- todo, 如果在与NPC对话，则不响应

	self.m_player_:run_to_derection(self:get_move_direction());
end

-- 停止人物的移动
function SafeMapScene:stop_player_move_action()
	self.m_player_is_on_moving_action_ = false;
	self.m_player_go_to_point_ = cc.p(0, 0);
end

function SafeMapScene:onExit()

end

function SafeMapScene:get_path_next_run_grid(begin_point, end_point)

	local deque_map_point = AStarPath.get_path_by_use_a_star(self.m_bg_map_:get_map_grid(), self.m_bg_map_:get_map_row(), self.m_bg_map_:get_map_col(), begin_point, end_point);
	local result = {};
	table.insert(result, deque_map_point[1]);

	while #deque_map_point > 3 do
		table.remove(deque_map_point);
	end

	if #deque_map_point == 2 then
		local p = deque_map_point[2];
		table.insert(result, p);
	elseif #deque_map_point > 2 then
		local p1 = deque_map_point[2];
		local p2 = deque_map_point[3];

		if ToolUtil.equal_map_point(ToolUtil.sub(p2, deque_map_point[1]), ToolUtil.mul(ToolUtil.sub(p1, deque_map_point[1]), 2)) then
			table.insert(result, p2);
		else
			table.insert(result, p1);
		end
	end

    return result
end

function SafeMapScene:insert_map_point(map_point)
	-- body
end

return SafeMapScene;
