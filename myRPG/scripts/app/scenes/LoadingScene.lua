--  这个loading并没有什么卵用，只是故意加载了个loading界面而已，需要研究确实需要loading的时候，该怎么加载loading界面

local scheduler = require("framework.scheduler");

local LoadingScene = class("LoadingScene", function ()	
	return display.newScene("LoadingScene");
end)

function LoadingScene:ctor()
	
	local ttf = cc.LabelTTF:create("loading...", "Arial", 14);
	ttf:setPosition(display.cx, display.cy);
	self:addChild(ttf);
end

function LoadingScene.start_loading(to_scene)
	
	LoadingScene.to_scene_ = to_scene;
	app:enterScene("LoadingScene");
end

function LoadingScene:onEnter()
	print("LoadingScene onEnter");

	-- delay to call fun.
	self.hInitGameScene = scheduler.performWithDelayGlobal(handler(self, self.initGameScene), 5)
end

function LoadingScene:initGameScene()
	app:enterScene(self.to_scene_, nil, "fade", 1);
end

function LoadingScene:onExit()

	-- clean all loaded textures.
end

return LoadingScene;