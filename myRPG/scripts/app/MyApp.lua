
require("config")
require("framework.init")
require("app.base_class.const")

local MyApp = class("MyApp", cc.mvc.AppBase)

GameState = require("framework.api.GameState");
GameData = {};
function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/");

    GameState.init(function(param)
        local returnValue = nil
        if param.errorCode then
            CCLuaLog("error")
        else
            if param.name == "save" then
                local str = json.encode(param.values)
                str = crypto.encryptXXTEA(str, "xianwx")
                returnValue = { data = str }
            elseif param.name == "load" then
                local str = crypto.decryptXXTEA(param.values.data, "xianwx")
                returnValue = json.decode(str)
            end
        end
        return returnValue
    end, "xianwxRPGConfig", "xianwxRPG");

    GameData = GameState.load();

    dump(GameData, "GameData: ");

    if not GameData then
        self:init_user_data();
    end

    self:enterScene("MainScene");
end

function MyApp:init_user_data()
    GameData = {
            user_name = "test1",
            user_level = "1",
        };

    GameState.save(GameData);
end

return MyApp
