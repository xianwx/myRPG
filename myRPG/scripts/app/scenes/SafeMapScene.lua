-- SafeMapScene.lua
-- 城镇地图的类
-- created by xianwx, 2015-07-02 14:23:04

-- todo, 先创建建筑，道路，可移动，无NPC
-- todo, 加上A星寻路

local SimpleMapMgr = require("app.base_class.SimpleMapMgr");
local Figure = require("app.base_class.Figure");

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

	local figure = Figure.new();
	figure:set_texture_type_and_num(Texture_type_path.FIGURE, GameData.figure);
	figure:set_hair(GameData.hair);
	figure:set_weapon(GameData.weapon);
	figure:setPosition(display.cx, display.cy);
	figure:set_direction_and_state(FigureState.STAND, FigureDirection.RIGHTANDUP);

	self:addChild(figure);
end

function SafeMapScene:onExit()

end

return SafeMapScene;
