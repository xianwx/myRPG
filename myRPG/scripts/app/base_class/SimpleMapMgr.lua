-- SimpleMapMgr.lua
-- 地图类
-- created by xianwx, 2015-07-02 14:47:59
local SimpleMapMgr = class("SimpleMapMgr", function ()
	return display.newNode();
end);

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

	self.layer = display.newLayer();
    self.layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            return self:onTouchBegan(event);
        elseif event.name == "moved" then
            self:onTouchMoved(event);
        elseif event.name == "ended" then
            self:onTouchEnded(event);
        elseif event.name == "cancel" then
            self:onTouchCancelled(event);
        end
    end)
    self:addChild(self.layer, -10000);

    self.layer:setTouchEnabled(true);

	local path = string.format("map/s%d/min_s%d.jpg", map_id, map_id);
	self.m_map_sprite_ = display.newSprite(path);
	self.m_map_sprite_:setAnchorPoint(0, 0);

	self:addChild(self.m_map_sprite_);

	self:load_floor_tile_data();
	self:load_passageway_data();
end

-- 销毁当前地图
function SimpleMapMgr:release_cur_map()
	-- todo, 删除当前地图
end

-- 加载地砖数据
function SimpleMapMgr:load_floor_tile_data()
	-- body
end

-- 加载通道数据
function SimpleMapMgr:load_passageway_data()
	-- body
end

function SimpleMapMgr:onTouchBegan(event)
	dump(event, "event in began");
	return true;
end

function SimpleMapMgr:onTouchMoved(event)

end

function SimpleMapMgr:onTouchEnded(event)
	dump(event, "event in end");
	self.m_map_sprite_:setAnchorPoint(event.x, event.y);
end

function SimpleMapMgr:onTouchCancelled(event)
	-- body
end

return SimpleMapMgr;
