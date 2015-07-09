-- AStarPath.lua
-- 有关A*的一些路径获取的类
-- created by xianwx, 2015-07-07 16:51:11

local AStarSearch = class("AStarSearch");
local AStarPoint = class("AStarPoint");
local MapSearchNode = class("MapSearchNode");

function AStarPoint:ctor(x, y)
	self.x = x;
	self.y = y;
end

function MapSearchNode:ctor(x, y)
	if (x and y) then
		self.x = x;
		self.y = y;
	else
		self.x = 0;
		self.y = 0;
	end
end

function MapSearchNode:is_same_point(x, y)
	return (self.x == x and self.y == y);
end

-- 目标距离估计
function MapSearchNode:goal_distance_estimate(node)
	local x_distance = math.abs(self.x - node.x);
	local y_distance = math.abs(self.y - node.y);

	return x_distance + y_distance;
end

-- 判断是否已经是目标点
function MapSearchNode:is_goal(node)
	return self:is_same_point(node.x, node.y);
end

-- 计算到达费用
function MapSearchNode:get_cost()
	return AStarPath.get_map(self.x, self.y);
end

-- 获取接班人
function MapSearchNode:get_successors(a_star_search, parent_node)
	local parent_x = -1;
	local parent_y = -1;

	if parent_node then
		parent_x = parent_node.x;
		parent_y = parent_node.y;
	end

	local new_node;

	-- 检查该点的八个方向的点
	-- 左边
	if AStarPath.get_map(self.x - 1, self.y) ~= DISORDER and not (parent_x == self.x - 1 and parent_y == self.y) then
		new_node = MapSearchNode.new(self.x - 1, self.y);
		--todo
	end

	-- 左下
	if AStarPath.get_map(self.x - 1, self.y - 1) ~= DISORDER and not (parent_x == self.x - 1 and parent_y == self.y - 1) then
		new_node = MapSearchNode.new(self.x - 1, self.y - 1);
		--todo
	end

	-- 下边
	if AStarPath.get_map(self.x, self.y - 1) ~= DISORDER and not (parent_x == self.x and parent_y == self.y - 1) then
		new_node = MapSearchNode.new(self.x, self.y - 1);
		--todo
	end

	-- 右下
	if AStarPath.get_map(self.x + 1, self.y + 1) ~= DISORDER and not (parent_x == self.x + 1 and parent_y == self.y + 1) then
		new_node = MapSearchNode.new(self.x + 1, self.y + 1);
		--todo
	end

	-- 右边
	if AStarPath.get_map(self.x + 1, self.y) ~= DISORDER and not (parent_x == self.x + 1 and parent_y == self.y) then
		new_node = MapSearchNode.new(self.x + 1, self.y);
		--todo
	end

	-- 右上
	if AStarPath.get_map(self.x + 1, self.y + 1) ~= DISORDER and not (parent_x == self.x + 1 and parent_y == self.y + 1) then
		new_node = MapSearchNode.new(self.x + 1, self.y + 1);
		--todo
	end
end

function AStarPath:ctor()

end

function AStarPath.get_map(x, y)
    -- todo 做啥的
    -- if (g_mainScene:getMapPoint(MapPoint.new(x * 65536 + y))) then
    --     return 1
    -- end

    -- 界外
    if x < 0 or x >= AStarPath.m_row_ or y < 0 or y >= AStarPath.m_col_ then
    	return 1;
    end

    -- 障碍物
    if AStarPath.m_map_[x][y] == 1 then
    	return 1;
    end

    return 0
end

-- 开始寻路
function AStarPath.get_path_by_use_a_star(map, row, col, begin_point, end_point)
	AStarPath:set_data(row, col, map);
	local deque_map_point_table = {};
	local deque_a_star_point_table = AStarPath.get_a_star_point(begin_point, end_point);

	-- 可能有数据，但是不连续，并不能移动
	if #deque_a_star_point_table <= 1 then
		return deque_map_point_table;
	end

	for k, v in pairs(deque_a_star_point_table) do
		table.insert(deque_map_point_table, MapPoint.new(v.x, v.y));
	end

	return deque_map_point_table;
end

-- 获得AStar的点
function AStarPath.get_a_star_point(begin_point, end_point)
	local point_table;

	local a_star_search = AStarSearch.new();
	local search_state = 1;
	local search_step = 0;
	local search_count = 0;

	local start_node = MapSearchNode.new(begin_point.x, begin_point.y);
	local end_node = MapSearchNode.new(end_point.x, end_point.y);

	while search_count < 1 do
		search_count = search_count + 1;
		a_star_search:start_and_goal_states(start_node, end_node);

		-- 寻路一直到不寻路为止（成功或者失败或者溢出等
		repeat
			search_state = a_star_search:search_and_return_state();
			search_step = search_step + 1;
		until (search_state ~= SEARCH_STATE_SEARCHING);

		if search_state == SEARCH_STATE_SUCCEEDED then

			-- todo 获取解集点还是状态还是点
			local node = a_star_search:get_solution_start();

			while true do
				table.insert(point_table, AStarPoint.new(node.x, node.y));
	            node = a_star_search:get_solution_next();

	            if (not node) then
	                break
	            end
			end
		end
	end

	return point_table;
end

function AStarPath:set_data(row, col, map)
	self.m_row_ = row;
	self.m_col_ = col;
	self.m_map_ = map;
end

function AStarPath:get_legal_end_point(begin_point, end_point)
	local result_end = end_point;

	if AStarPath.get_map(end_point.x, end_point.y) ~= DISORDER then
		return result_end;
	end

	local count = begin_point:get_distance(end_point) + 10;
	local temp_map_point;

	-- 从周围的点中找可以到达的点
	for i = 1, count do
		local arr_point = end_point:get_map_point_vector_for_distance(i);
		local lenght = 0xffff;

		-- 找到一个可以到达的点
		for k, v in pairs(arr_point) do
			temp_map_point = v;

			if not (AStarPath.get_map(temp_map_point.x, temp_map_point.y) == DISORDER or
				temp_map_point:get_distance(begin_point) >= lenght or
				ToolUtil.equal_map_point(begin_point, temp_map_point)) then
				result = temp_map_point;
			end
		end

		if (not ToolUtil.equal_map_point(result, end_point)) then
            break;
        end
	end
	return result_end;
end

return AStarPath;
