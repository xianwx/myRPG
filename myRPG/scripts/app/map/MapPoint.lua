-- MapPoint.lua
-- 地图点的基类
-- created by xianwx, 2015-07-06 15:10:55
local MapPoint = class("MapPoint");

function MapPoint:ctor(x, z)
	if (x and z) then
		self.x = math.floor(x);
		self.z = math.floor(z);
	elseif x then
		if type(x) == "number" then
			-- 为什么是65536
            self.x = math.floor(x / 65536);
            self.z = math.floor(x % 65536);
        else
            self.x = math.floor(x.x / GRID_SIZE.width);
            self.z = math.floor(x.y / GRID_SIZE.height);
        end
	else
		self.x = 0;
		self.z = 0;
	end
end

function MapPoint:get_value()
	return self.x * 65536 + self.z;
end

-- 获取ccSize的值
function MapPoint:get_cc_size_value()
	return cc.size(self.x * GRID_SIZE.width, self.z * GRID_SIZE.height);
end

-- 获取ccPoint的值
function MapPoint:get_cc_point_value()
	local point = cc.p(self.x * GRID_SIZE.width, self.z * GRID_SIZE.height);
	return cc.PointAdd(point, cc.p(GRID_SIZE.width / 2, GRID_SIZE / 2));
end

function MapPoint:get_map_point_vector_for_distance(lenght)
    local arrMPoint = {}
    local x = -lenght
    local z = -lenght
    while (true) do
        if (#arrMPoint == 8*lenght) then
            break
        end

        table.insert(arrMPoint, MapPoint.add(self, MapPoint.new(x, z)))

        if (#arrMPoint <= 2*lenght) then
            x = x + 1
        elseif (2*lenght < #arrMPoint and #arrMPoint <= 4*lenght) then
            z = z + 1
        elseif (4*lenght < #arrMPoint and #arrMPoint <= 6*lenght) then
            x = x - 1
        elseif (6*lenght < #arrMPoint and #arrMPoint < 8*lenght) then
            z = z - 1
        end
    end

    return arrMPoint
end

function MapPoint.setGridSize(size)
    GRID_SIZE = size
end

function MapPoint:getLength()
    return math.floor(math.max(math.abs(self.x), math.abs(self.z)))
end

function MapPoint:getDistance(mpoint)
    return math.floor(math.max(math.abs(mpoint.x - self.x), math.abs(mpoint.z - self.z)))
end

return MapPoint;
