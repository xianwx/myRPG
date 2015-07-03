-- SelectRoleScene.lua
-- 用于管理用户初次进入游戏，选择职业和姓名的类
-- created by xianwx, 2015-06-29 11:26:04

-- 显示背景，以及可供选择的集中职业
-- 点击某个人物，播放一下特效
-- 可以输入昵称
-- 保存玩家数据
-- 连接进入游戏（不联网单机）

local figure_id = {11001, 11002, 12001, 12002, 13001, 13002, 14001, 14002, 15001, 15002, 16001, 16002};
local hair_id = {1000, 1000, 1100, 1100, 1200, 1200};
local weapon_id = {1000, 1100, 1200, 1300, 1400, 1500};

local SelectRoleScene = class("SelectRoleScene", function()
	return display.newScene("SelectRoleScene");
end)

local Figure = require("app.base_class.Figure");

function SelectRoleScene:ctor()
	-- Players can choose careers‘
	print("SelectRoleScene ctor");
	self.role_career_ = {};
	self.nick_name_ = "";
	self.nick_name_input_box_ = nil;

	-- 按钮先是不响应点击，等选择职业过后才响应点击。
	self.enter_game_btn = nil;

	-- 目前选中的职业
	self.m_select_role_ = nil;
	self:init();
end

function SelectRoleScene:init()
	-- 创建几个职业的人物图片

	-- 创建背景图片
	local bg_img = display.newSprite("map/loading.jpg", display.cx, display.cy);
	self:addChild(bg_img);

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
		normal = "ui/role_create/GUI/button.png",
        pressed = nil,
        disabled = nil,
	};

	local enter_game_btn = cc.ui.UIPushButton.new(ENTER_GAME_BTN_IMAGES, { scale9 = true });
	enter_game_btn:setButtonLabel("normal", cc.ui.UILabel.new({text = "进入游戏", size = 25, fontName = "黑体"}));
	enter_game_btn:setButtonSize(120, 60);
	enter_game_btn:setAnchorPoint(0.5, 0.5);
	enter_game_btn:setPosition(910, 80);
	enter_game_btn:setColor(ccc3(127, 127, 127));
    enter_game_btn:setTouchEnabled(false);
    enter_game_btn:onButtonClicked(handler(self, self.enter_btn_clicked));
    self:addChild(enter_game_btn);
    self.enter_game_btn = enter_game_btn;

    local size_btn = cc.size(120, 200);

    local pt = {
        cc.p(115, 320),
        cc.p(268, 320),
        cc.p(403, 320),
        cc.p(556, 320),
        cc.p(691, 320),
        cc.p(844, 320)
    };

    for i = 1, 6 do
        local btn = cc.ui.UIPushButton.new({ normal = nil, pressed = nil, disabled = nil, }, {scale9 = true});
        btn:setAnchorPoint(0.5, 0.5);
        btn:setButtonSize(size_btn.width, size_btn.height);
        btn:setPosition(cc.PointAdd(cc.p(0, 0), pt[i]));
        btn:setTag(figure_id[i]);
        btn:onButtonClicked(handler(self, self.play_selected_action));
        self:addChild(btn);

        local monomer = Figure.new();
        monomer:set_texture_type_and_num(Texture_type_path.FIGURE, figure_id[i]);
        monomer:set_hair(hair_id[i]);
        monomer:set_weapon(weapon_id[i]);
        monomer:setColor(ccc3(127, 127, 127));
        btn:addChild(monomer);
        table.insert(self.role_career_, monomer);
    end
end

function SelectRoleScene:play_selected_action(event)

	local btn = event.target;

	if btn then

		local scale_to;

		if self.m_select_role_ then
			self.m_select_role_:stop_all_actions();
			self.m_select_role_:setColor(ccc3(127, 127, 127));
			scale_to = cc.ScaleTo:create(1.2, 1);
			self.m_select_role_:runAction(scale_to);
		end

		local button;
		for i = 1, #self.role_career_ do
			button = self.role_career_[i]:getParent();

			if button == btn then
				self.m_select_role_ = self.role_career_[i];
				break;
			end
		end

		self.m_select_role_:setColor(ccc3(255, 255, 255));
		scale_to = cc.ScaleTo:create(1, 1.2);
		self.m_select_role_:runAction(scale_to);

		if self.enter_game_btn then
			self.enter_game_btn:setColor(ccc3(255, 255, 255));
			self.enter_game_btn:setTouchEnabled(true);
		end
	end
end

function SelectRoleScene:enter_btn_clicked()
	if self.nick_name_ and self.nick_name_ ~= "" then
		self:enter_game();
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

	self:enter_game();
end

function SelectRoleScene:enter_game()
	-- 先保存一下数据
	GameData.nick_name = self.nick_name_;
	GameData.level = 1;
	GameData.hair = self.m_select_role_:get_hair();
	GameData.weapon = self.m_select_role_:get_weapon();
	GameData.figure = self.m_select_role_:get_figure_num();
	self.nick_name_input_box_:setText(self.nick_name_);
	GameState.save(GameData);

	-- 进入游戏
	app:enterScene("SafeMapScene");
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
