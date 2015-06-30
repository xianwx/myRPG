-- SelectRoleScene.lua
-- 用于管理用户初次进入游戏，选择职业和姓名的类
-- created by xianwx, 2015-06-29 11:26:04

-- 显示背景，以及可供选择的集中职业
-- 点击某个人物，播放一下特效
-- 可以输入昵称
-- 保存玩家数据
-- 连接进入游戏（不联网单机）

local SelectRoleScene = class("SelectRoleScene", function()
	return display.newScene("SelectRoleScene");
end)

function SelectRoleScene:ctor()
	-- Players can choose careers‘
	print("SelectRoleScene ctor");
	self.role_career_ = {};
	self.nick_name_ = "";
	self.nick_name_input_box_ = nil;

	-- 按钮先是不响应点击，等选择职业过后才响应点击。
	self.enter_game_btn = nil;
	self:init();
end

function SelectRoleScene:init()
	-- 创建几个职业的人物图片

	-- 创建个偏白色的背景
	local layer_color_bg = CCLayerColor:create(ccc4(140, 150, 180, 255), display.width, display.height);
	self:addChild(layer_color_bg, -1);

	-- 创建职业人物描述
	local description_label = cc.ui.UILabel.new({
								text = "傲来国",
								size = 35,
								fontName = "黑体",
								color = cc.c3b(0, 0, 0) }):pos(480, 576):addTo(self);
	description_label:setAnchorPoint(0.5, 0.5);

	description_label = cc.ui.UILabel.new({
								text = "耐打",
								size = 20,
								fontName = "黑体",
								color = cc.c3b(0, 0, 0) }):pos(192, 179):addTo(self);
	description_label:setAnchorPoint(0.5, 0.5);

	description_label = cc.ui.UILabel.new({
								text = "召唤",
								size = 20,
								fontName = "黑体",
								color = cc.c3b(0, 0, 0) }):pos(480, 179):addTo(self);
	description_label:setAnchorPoint(0.5, 0.5);

	description_label = cc.ui.UILabel.new({
								text = "强力",
								size = 20,
								fontName = "黑体",
								color = cc.c3b(0, 0, 0) }):pos(768, 179):addTo(self);
	description_label:setAnchorPoint(0.5, 0.5);

	-- 名称输入框
	local edit_box = ui.newEditBox({
		size = cc.size(200, 50),
        x = 480,
        y = 96,
        listener = function(event, edit_box)
        	if event == "began" then
        		self:on_edit_box_began(edit_box);
        	elseif event == "changed" then
        		self:on_edit_box_changed(edit_box);
        	elseif event == "ended" then
        		self:on_edit_box_ended(edit_box);
        	elseif event == "returnDone" then
        		self:on_edit_box_ended(edit_box);
        	else
        		print("edit_event in SelectRoleScene is :", event);
    		end
     	end
	});

	edit_box:setFontSize(20);
	edit_box:setFontName("黑体");
	edit_box:setColor(cc.c3b(0, 0, 0));
	edit_box:setPlaceHolder("请输入你的名字");
	edit_box:setPlaceholderFontColor(cc.c3b(0, 0, 0));
	edit_box:setInputMode(kEditBoxInputModeAny);
    edit_box:setReturnType(kKeyboardReturnTypeDone);
    self:addChild(edit_box);
    self.nick_name_input_box_ = edit_box;

	-- 进入游戏按钮
	local ENTER_GAME_BTN_IMAGES = {
		normal = "common/button_green_216x64.png",
        pressed = "common/button_grey_216x64.png",
        disabled = "common/button_grey_216x64.png",
	};

	local enter_game_btn = cc.ui.UIPushButton.new(ENTER_GAME_BTN_IMAGES, { scale9 = true });
	enter_game_btn:setButtonLabel("normal", cc.ui.UILabel.new({text = "进入游戏", size = 25, fontName = "黑体"}));
	enter_game_btn:setButtonSize(150, 80);
	enter_game_btn:setAnchorPoint(0.5, 0.5);
	enter_game_btn:setPosition(500, 380);
	enter_game_btn:setColor(ccc3(127, 127, 127));
    enter_game_btn:setTouchEnabled(true);
    enter_game_btn:onButtonClicked(handler(self, self.enter_btn_clicked));
    self:addChild(enter_game_btn);
    self.enter_game_btn = enter_game_btn;
end

function SelectRoleScene:enter_btn_clicked()
	-- print("enter_btn_clicked");

	if self.nick_name_ and self.nick_name_ ~= "" then
		-- todo
	else
		-- 提示未输入名字，将随机一个，让玩家确认
		local messagelayer = require("app.game_ui.MessageBoxLayer").new({
					confirm_callback = handler(self, self.enter_game_with_random_name),
					confirm_callback_param = nil,
					cancel_callback = nil,
					cancel_callback_param = nil,
					contents_text = "未输入名字，将随机生成一个，确定吗？",
					title_text = "提示"
					}):addTo(self);
	end
end

function SelectRoleScene:enter_game_with_random_name()
	-- 随机一个名字，然后进入游戏
	self.nick_name_ = self:random_nick_name();

	self:enter_game(self.nick_name_);
end

function SelectRoleScene:enter_game(param)
	-- param参数有姓名，所选职业等

	-- 先保存一下数据
	GameData.nick_name = self.nick_name_;
	self.nick_name_input_box_:setText(self.nick_name_);
	GameState.save(GameData);

	-- todo 进入游戏
end

function SelectRoleScene:on_edit_box_began(edit_box)
	print("In func box_began, edit_box_text: ", edit_box:getText());
end

function SelectRoleScene:on_edit_box_ended(edit_box)
	self.nick_name_ = edit_box:getText();
	print("In func box_ended, edit_box_text: ", edit_box:getText());
end

function SelectRoleScene:on_edit_box_changed(edit_box)
	print("In func box_changed, edit_box_text: ", edit_box:getText());
end

function SelectRoleScene:random_nick_name()
	-- 随机一个名字并返回，这里直接返回了……
	return "默苍离";
end

function SelectRoleScene:onEnter()
	-- body
end

function SelectRoleScene:onExit()
	-- body
end

return SelectRoleScene;
