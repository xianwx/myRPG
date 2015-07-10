local LoadingScene = require("app.scenes.LoadingScene");
local TextureController = require("app.base_class.TextureController")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()

	local label = cc.ui.UILabel.new({UILaberType = 2, text = "I am MainScene.", size = 14})
					:addTo(self)
					:align(display.CENTER, display.cx, display.cy);
end

function MainScene:onEnter()
	if GameData ~= nil then
		LoadingScene.start_loading("SafeMapScene");
	else
		LoadingScene.start_loading("SelectRoleScene");
	end
end

function MainScene:onExit()
end

return MainScene
