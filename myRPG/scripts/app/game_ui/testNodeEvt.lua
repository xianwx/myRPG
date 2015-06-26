
local testNodeEvt = class("testNodeEvt", function()
	return display.newSprite();
end)

function testNodeEvt:ctor()
	self:setNodeEventEnabled(true);
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(evnet)
			dump(evnet, "node_touch_handle's evnet in local fun.");
		end);

	local bg_sprite = display.newSprite("common/bar_back_174x24.png");
	self:addChild(bg_sprite);
end

function testNodeEvt:node_touch_handle(param)
	dump(param, "node_touch_handle's param");
end

return testNodeEvt;
