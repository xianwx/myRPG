-- MapPoint.lua
-- 地图点的基类
-- created by xianwx, 2015-07-06 15:10:55
local MapPoint = class("MapPoint");

function MapPoint:ctor(x, y)
	if (x and y) then
		self.x = math.floor(x);
		self.y = math.floor(y);
	elseif x then
		if type(x) == "number" then
			-- todo, 为什么是65536
            self.x = math.floor(x / 65536);
            self.y = math.floor(x % 65536);
        else
            self.x = math.floor(x.x / GRID_SIZE.width);
            self.y = math.floor(x.y / GRID_SIZE.height);
        end
	else
		self.x = 0;
		self.y = 0;
	end
end

function MapPoint:get_value()
	return self.x * 65536 + self.y;
end

-- 获取ccSize的值
function MapPoint:get_cc_size_value()
	return cc.size(self.x * GRID_SIZE.width, self.y * GRID_SIZE.height);
end

-- 获取ccPoint的值
function MapPoint:get_cc_point_value()
	local point = cc.p(self.x * GRID_SIZE.width, self.y * GRID_SIZE.height);
	return cc.PointAdd(point, cc.p(GRID_SIZE.width / 2, GRID_SIZE.height / 2));
end

function MapPoint:get_map_point_vector_for_distance(lenght)
    local arrMPoint = {};
    local x = -lenght;
    local y = -lenght;
    while (true) do
        if (#arrMPoint == 8 * lenght) then
            break;
        end

        table.insert(arrMPoint, MapPoint.add(self, MapPoint.new(x, y)));

        if (#arrMPoint <= 2 * lenght) then
            x = x + 1;
        elseif (2 * lenght < #arrMPoint and #arrMPoint <= 4 * lenght) then
            y = y + 1;
        elseif (4 * lenght < #arrMPoint and #arrMPoint <= 6 * lenght) then
            x = x - 1;
        elseif (6 * lenght < #arrMPoint and #arrMPoint < 8 * lenght) then
            y = y - 1;
        end
    end

    return arrMPoint;
end

function MapPoint.set_grid_size(size)
    GRID_SIZE = size;
end

function MapPoint:get_length()
    return math.floor(math.max(math.abs(self.x), math.abs(self.y)));
end

function MapPoint:get_distance(aims_point)
    return math.floor(math.max(math.abs(aims_point.x - self.x), math.abs(aims_point.y - self.y)));
end
return MapPoint;
