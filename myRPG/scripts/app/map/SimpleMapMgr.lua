-- SimpleMapMgr.lua
-- 地图类
-- created by xianwx, 2015-07-02 14:47:59
local SimpleMapMgr = class("SimpleMapMgr", function ()
	return display.newNode();
end);

local MapFloorTile = require("app.map.MapFloorTile");

function SimpleMapMgr:ctor()

	-- 地图id，点合集，图合集等
	self.m_map_id_ = 0;
	self.m_map_grid_ = {};
	self.m_map_floor_tile_arr_ = {};   -- 地砖数组
	self.m_map_passageway_arr_  = {};  -- 通道数组

	-- 地图大小
	self.m_grid_row_ = 0;
	self.m_grid_col_ = 0;
	self.m_images_row_ = 0;
	self.m_images_col_ = 0;
	self.m_images_size_ = cc.size(0, 0);
	self.m_grid_size_ = cc.size(0, 0);
	self.m_map_size_ = cc.size(0, 0);
end

-- 创建地图
function SimpleMapMgr:create_map(map_id)

	if self.m_map_id_ ~= 0 then
		self:release_cur_map();
	end

	self.m_map_id_ = map_id;

	self:load_grid_data();

	self:init_map_sprite();
	self:load_floor_tile_data();
	self:load_passageway_data();
end

-- 创建地图的sprite
function SimpleMapMgr:init_map_sprite()

	local path = string.format("map/s%d/min_s%d.jpg", self.m_map_id_, self.m_map_id_);
	self.m_map_sprite_ = display.newSprite(path);
	self.m_map_sprite_:setAnchorPoint(0, 0);
	self.m_map_sprite_:setContentSize(3600, 2400);

	self:addChild(self.m_map_sprite_);
end

-- 创建地图的grid
function SimpleMapMgr:init_map_grid_data(grid_arr)
	for i = 0, self.m_grid_row_ - 1 do
		self.m_map_grid_[i] = {};
	end

	for i = 0, #grid_arr - 1 do
		self.m_map_grid_[math.floor(i / self.m_grid_col_)][i % self.m_grid_col_] = grid_arr[i + 1];
	end
end

-- 装载地图格子数据
function SimpleMapMgr:load_grid_data()
	local path = string.format("map/s%d/data_gird_%d.json", self.m_map_id_, self.m_map_id_);
	local json_str = CCString:createWithContentsOfFile(path);
	local json_value = json.decode(json_str:getCString());

	self.m_grid_row_ = math.ceil(json_value.mapH / json_value.mapGridH);
	self.m_grid_col_ = math.ceil(json_value.mapW / json_value.mapGridW);

	self.m_grid_size_ = cc.p(json_value.mapGridW, json_value.mapGridH);

    -- 切图宽高
    self.m_images_size_ = cc.size(json_value.divideBlockW, json_value.divideBlockH);
    self.m_images_row_ = math.ceil(json_value.mapH / json_value.divideBlockH);
    self.m_images_col_ = math.ceil(json_value.mapW / json_value.divideBlockW);

    self:init_map_grid_data(json_value.mapFlagArr);
end

-- 加载地砖数据
function SimpleMapMgr:load_floor_tile_data()
	ToolUtil.get_z_order_zero(self.m_map_size_);

	local floor_tile;
	local path;

	for i = 0, self.m_images_row_ - 1 do
		for j = 0, self.m_images_col_ do
			floor_tile = MapFloorTile.new();
			floor_tile:set_file_name(string.format("map/s%d/s%d_%d_%d.jpg", self.m_map_id_, self.m_map_id_, i, j));
			floor_tile:setPosition(self.m_images_size_.width * j, self.m_images_size_.height * i);
			self:addChild(floor_tile, ToolUtil.get_z_order_zero(self.m_map_size_));
			table.insert(self.m_map_floor_tile_arr_, floor_tile);
		end
	end
end

-- 加载超时空通道数据
function SimpleMapMgr:load_passageway_data()
	-- body
end

-- 销毁当前地图
function SimpleMapMgr:release_cur_map()
	-- todo, 删除当前地图
end

function SimpleMapMgr:get_map_sprite()
	return self.m_map_sprite_;
end

return SimpleMapMgr;
