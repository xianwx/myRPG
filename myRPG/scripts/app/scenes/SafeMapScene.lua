-- SafeMapScene.lua
-- 城镇地图的类
-- created by xianwx, 2015-07-02 14:23:04

-- todo, 先创建建筑，道路，可移动，无NPC
-- todo, 加上A星寻路

local SimpleMapMgr = require("app.base_class.SimpleMapMgr");

local SafeMapScene = class("SafeMapScene", function ()
	return display.newScene("SafeMapScene");
end)

function SafeMapScene:ctor()
	self.bg_map_ = nil;
end

function SafeMapScene:onEnter()

	self.bg_map_ = SimpleMapMgr.new();
	self.bg_map_:create_map(200);

	self:addChild(self.bg_map_);
end

function SafeMapScene:onExit()

end

return SafeMapScene;
