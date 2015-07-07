-- AStarPath.lua
-- 有关A*的一些路径获取的类
-- created by xianwx, 2015-07-07 16:51:11
local AStartPath = class("AStartPath");
local AStartPoint = class("AStartPoint");
local MapSearchNode = class("MapSearchNode");

function AStartPoint:ctor(x, y)
	self.x = x;
	self.y = y;
end

function AStartPath:ctor()

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

-- 获取接班人
function MapSearchNode:get_successors(a_star_search, parent_node)

end

return AStartPath;
