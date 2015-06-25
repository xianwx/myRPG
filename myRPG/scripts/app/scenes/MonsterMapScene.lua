local MonsterMapScene = class("MonsterMapScene", function()
	return display.newScene("MonsterMapScene");
end)

function MonsterMapScene:ctor()
	-- body
	print("MonsterMapScene ctor");

	local ttf = cc.LabelTTF:create("MonsterMapScene", "Arial", 20);
	ttf:setPosition(display.cx, display.cy);
	self:addChild(ttf);
end

function MonsterMapScene:onEnter()
	print("MonsterMapScene onEnter");
end

function MonsterMapScene:onExit()
	-- body
end

return MonsterMapScene;