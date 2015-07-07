-- MapFloorTile.lua
-- 地图板砖类
-- created by xianwx, 2015-07-03 15:45:16
local MapFloorTile = class("MapFloorTile", function ()
	return display.newNode();
end)

function MapFloorTile:ctor()
	self.m_sprite_ = nil;
	self.m_file_name_ = "";
	self.m_is_display = false;
end

function MapFloorTile:set_file_name(file_name)
	self.m_file_name_ = file_name;
end

function MapFloorTile:intelligent_to_display()
	-- body
end

return MapFloorTile;
