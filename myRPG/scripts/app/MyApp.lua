
require("config")
require("framework.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

GameState = require("framework.api.GameState");
GameData = {};
function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/");
    self:enterScene("MainScene");

    -- GameData = cc.utils.State:load();

    dump(cc, "cc.utils");

    -- if io.exists(GameState.getGameStatePath()) then
    --     GameData = GameState.load();
    --     dump(GameData, "GameData");
    -- else
    -- 	self:getInitGameData()
    -- end
end

function MyApp:getInitGameData()
	local default_data = {
		user_name = "test1",
		user_level = "1",
	};

	GameData = default_data;
	GameState:save(GameData);
end

function MyApp:init_user_data()
	-- todo

end

return MyApp
