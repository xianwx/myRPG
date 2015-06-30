--  这个loading并没有什么卵用，只是故意加载了个loading界面而已，需要研究确实需要loading的时候，该怎么加载loading界面
local scheduler = require("framework.scheduler");

local LoadingScene = class("LoadingScene", function ()
	return display.newScene("LoadingScene");
end)

function LoadingScene:ctor()

	local bg_img = display.newSprite("map/loading.jpg", display.cx, display.cy);
	self:addChild(bg_img, -1);

	local ttf = cc.LabelTTF:create("loading...", "Arial", 30);
	ttf:setPosition(display.cx, 20);
	self:addChild(ttf);
end

function LoadingScene.start_loading(to_scene)

	LoadingScene.to_scene_ = to_scene;
	app:enterScene("LoadingScene");
end

function LoadingScene:onEnter()
	print("LoadingScene onEnter");

	-- delay to call fun.
	scheduler.performWithDelayGlobal(handler(self, self.initGameScene), 2);
end

function LoadingScene:initGameScene()
	app:enterScene(self.to_scene_, nil, "fade", 1);
end

function LoadingScene:onExit()

	-- clean all loaded textures.
	-- in quick final 3.3, use "cc.Director:getInstance():getTextureCache():removeAllTextures();" to delete.
	CCTextureCache:sharedTextureCache():removeAllTextures();
end

return LoadingScene;
