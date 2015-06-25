local LoadingScene = require("app.scenes.LoadingScene");

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	
	local label = cc.ui.UILabel.new({UILaberType = 2, text = "I am MainScene.", size = 14})
					:addTo(self)
					:align(display.CENTER, display.cx, display.cy);
end

function MainScene:onEnter()
	print("MainScene onEnter");

    LoadingScene.start_loading("MonsterMapScene");
end

function MainScene:onExit()
end

return MainScene
