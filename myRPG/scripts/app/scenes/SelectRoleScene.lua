local SelectRoleScene = class("SelectRoleScene", function()
	return display.newScene("SelectRoleScene");
end)

local testNodeEvt = require("app.game_ui.testNodeEvt");

function SelectRoleScene:ctor()
	-- Players can choose careers‘
	print("SelectRoleScene ctor");
	self.role_career = {};
	self:init();
end

function SelectRoleScene:init()
	local bg_layer_color = CCLayerColor:create(ccc4(140, 150, 180, 255), display.width, display.height);
	self:addChild(bg_layer_color, -1);
	self:setNodeEventEnabled(true);
	local edit_box = ui.newEditBox({
			x = display.cx,
			y = display.cy,
			size = cc.size(250, 80),
			listener = function(event, edit_box)
				if event == "began" then
					self:on_edit_box_began(edit_box);
				elseif event == "ended" then
					self:on_edit_box_ended(edit_box);
				elseif event == "changed" then
					self:on_edit_box_changed(edit_box);
				elseif event == "returnDone" then
					self:on_edit_box_return(edit_box);
				else
					print("edit_event_is: ", tostring(event));
				end
			end});

	self:setNodeEventEnabled(true);
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, self.node_touch_handler);

	edit_box:setFontSize(14);
	edit_box:setFontName("Arial");
	edit_box:setPlaceHolder("默认以及没有输入时显示的字");
	edit_box:setPlaceholderFontColor(cc.c3b(0, 0, 0));
	edit_box:setInputMode(kEditBoxInputModeAny);
	edit_box:setMaxLength(14);
	edit_box:setInputFlag(0)
	edit_box:setReturnType(kKeyboardReturnTypeDone);
	self:addChild(edit_box);

	-- btn 图片
	local PUSH_BUTTON_IMAGES = {
        normal = "common/button_green_216x64.png",
        pressed = "common/button_grey_216x64.png",
        disabled = "common/button_grey_216x64.png",
    }

    local btn = cc.ui.UIPushButton.new(PUSH_BUTTON_IMAGES, {scale9 = true, text = "test btn"});
    btn:setAnchorPoint(0.5, 0.5);
    btn:setPosition(display.cx + 105, display.cy + 100);
    btn:onButtonClicked(handler(self, self.button_clicked));

    local btn_label = ui.newTTFLabel({text = "btn label", size = 14, align = ui.TEXT_ALIGN_CENTER});

    btn:setButtonLabel("normal", btn_label);

    self:addChild(btn);

    local node = testNodeEvt.new();
    node:setPosition(100, 100);

    self:addChild(node);
end

function SelectRoleScene:node_touch_handler( param )
	print("node_touch_handler");
end

function SelectRoleScene:button_clicked()
	print("btn_clicked");
	self:removeEventListener(self);
end

function SelectRoleScene:on_edit_box_began(edit_box)
	print("In func box_began, edit_box_text: ", edit_box:getText());
end

function SelectRoleScene:on_edit_box_ended( edit_box )
	print("In func box_ended, edit_box_text: ", edit_box:getText());
end

function SelectRoleScene:on_edit_box_changed( edit_box )
	print("In func box_changed, edit_box_text: ", edit_box:getText());
end

function SelectRoleScene:on_edit_box_return(edit_box)
	print("In func box_return, edit_box_text: ", edit_box:getText());
end

function SelectRoleScene:onEnter()
	-- body
end

function SelectRoleScene:onExit()
	-- body
end

return SelectRoleScene;
