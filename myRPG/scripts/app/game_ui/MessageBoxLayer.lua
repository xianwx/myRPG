-- MessageBoxLayer.lua
-- 创建提示窗口的类
-- created by xianwx, 2015-06-29 16:05:31

local MessageBoxLayer = class("MessageBoxLayer", function()
	return display.newLayer();
end)

MessageBoxLayer.images = {

	background = "ui/map/background.png",
	buttonblack = "common/button_grey_169x74.png",
	button_yellow = "common/button_yellow_169x74.png",
    button_green = "common/button_green_169x74.png",

    comfont = "common/fontimage/com_yellow.png",
    canfont = "common/fontimage/can_green.png",
}

function MessageBoxLayer:ctor(param)

	self.param_ = param;
	self:setNodeEventEnabled(true);
	self:setTouchEnabled(true);

	self:create_message_layer();
end

function MessageBoxLayer:create_message_layer()
	-- 如果有音效，可以先播放一下移入音效。

	-- 创建背景（背景图片以及底色等）
	local layer_color_bg = display.newColorLayer(cc.c4b(0, 0, 0, 0)):addTo(self);
	local image_bg = display.newSprite(MessageBoxLayer.images.background, display.cx, display.cy):addTo(self);

	if DISPLAY_X_SCALE < DISPLAY_Y_SCALE then
		image_bg:setScale(DISPLAY_X_SCALE);
	else
		image_bg:setScale(DISPLAY_Y_SCALE);
	end

	image_bg.width = image_bg:getContentSize().width;
	image_bg.height = image_bg:getContentSize().height;
	image_bg:setPosition(display.cx, display.height * 1.5);
	-- image_bg:align(display.CENTER, display.cx, display.cy);

	-- transition 是sprite用于播放动画的一个封装好的接口
	-- execute是执行一次

	transition.execute(image_bg, cc.MoveTo:create(0.3, ccp(display.cx, display.cy)), { easing = "backout" });
	transition.execute(layer_color_bg, CCFadeTo:create(0.2, 100), {});

	-- 创建相关文字（标题，内容等）

	local title = ui.newTTFLabelWithOutline({ text = self.param_.title_text, size = 40, font = "Arial", align = ui.TEXT_ALIGN_CENTER, x = image_bg:getContentSize().width / 2, y = image_bg:getContentSize().height * 0.85 }):addTo(image_bg);

	local contents_text = ui.newTTFLabelWithOutline({ text = self.param_.contents_text, size = 30, font = "Arial", align = ui.TEXT_ALIGN_CENTER, x = image_bg:getContentSize().width / 2, y = image_bg:getContentSize().height * 0.55 }):addTo(image_bg);

	-- 创建相关按钮
	-- 确定按钮
	local confim_btn = ui.newImageMenuItem({image = MessageBoxLayer.images.button_yellow,
 		imageSelected = MessageBoxLayer.images.buttonblack,});
	confim_btn:setPositionX(image_bg.width * -0.2);
	local confim_label_sprite = display.newSprite(MessageBoxLayer.images.comfont):addTo(confim_btn, 1);
	confim_label_sprite:setScale(confim_btn:getContentSize().height / confim_label_sprite:getContentSize().height * 0.6);
	confim_label_sprite:setPosition(ccp(confim_btn:getContentSize().width / 2, confim_btn:getContentSize().height * 0.55));

	-- 取消按钮

	local cancel_btn = ui.newImageMenuItem({image = MessageBoxLayer.images.button_green,
 		imageSelected = MessageBoxLayer.images.buttonblack,});

	cancel_btn:setPositionX(image_bg.width * 0.2);
	local cancel_label_sprite = display.newSprite(MessageBoxLayer.images.canfont):addTo(cancel_btn, 1);
	cancel_label_sprite:setScale(cancel_btn:getContentSize().height / cancel_label_sprite:getContentSize().height * 0.6);
	cancel_label_sprite:setPosition(ccp(cancel_btn:getContentSize().width / 2, cancel_btn:getContentSize().height * 0.55));

	-- 按钮menu
	local button_menu = ui.newMenu({ confim_btn, cancel_btn }):addTo(image_bg);
	button_menu:setPositionX(image_bg.width / 2);
	button_menu:setPositionY(image_bg.height * 0.25);

	--确认事件
	confim_btn:addNodeEventListener(cc.MENU_ITEM_CLICKED_EVENT, function ()
		-- 如果有音效，播放移除音效

		-- 把窗口移回去
		transition.execute(layer_color_bg, CCFadeTo:create(0.3, 0), {});
		transition.execute(image_bg, CCMoveTo:create(0.3, ccp(display.cx, display.height * 1.5)), {
				easing = "backin",
				onComplete = function ()
					self:removeSelf();
				end
			});

		if self.param_.confirm_callback then

			-- 调用回调函数
			self.param_.confirm_callback(self.param_.confirm_callback_param);
		end
	end)

	-- 取消事件
	cancel_btn:addNodeEventListener(cc.MENU_ITEM_CLICKED_EVENT, function ()
		-- 如果有音效，播放移除音效

		-- 把窗口移回去
		transition.execute(layer_color_bg, CCFadeTo:create(0.3, 0), {});
		transition.execute(image_bg, CCMoveTo:create(0.3, ccp(display.cx, display.height * 1.5)), {
				easing = "backin",
				onComplete = function ()
					self:removeSelf();
				end
			});

		if self.param_.cancel_callback then
			self.param_.cancel_callback(self.param_.cancel_callback_param);
		end
	end)

	-- 如果只有一个确认按钮（只是提示信息的框），设置一下按钮的位置。
	if self.param_.only_confirm then
		cancel_btn:setVisible(false);
		confim_btn:setPosition(ccp(0, 0));
	end
end

return MessageBoxLayer;
