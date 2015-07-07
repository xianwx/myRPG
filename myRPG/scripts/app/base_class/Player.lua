-- Player.lua
-- 玩家类
-- created by xianwx, 2015-07-06 09:30:55
local Monomer = require("app.base_class.Monomer");
local Player = class("Player", Monomer);

function Player:ctor()
	-- body
end

function Player:set_detail(figure_id, hair_id, weapon_id)
	-- 既然调用这个函数，就要清除之前的信息
	if figure_id then
		self:set_figure_num_and_texture_type(figure_id, Texture_type_path.FIGURE);
	end

	if hair_id then
		self:set_hair(hair_id);
	end

	if weapon_id then
		self:set_weapon(weapon_id);
	end
end

function Player:onEnter()
	Player.super().onEnter(self);
end

function Player:runBy(mpoint)
    local relust = Player.super.runBy(self, mpoint)

    if (relust.fTime ~= 0) then
        g_mainScene:insterMapPoint(self, relust.mpoint)
    end

    if (relust.fTime == 0 and relust.bIsCanNotFineTheWay == false) then
        self.m_willGoPoint = mpoint
        self:stopActionByTag(TAG_MOVETWAIT)
        self:delayCallBack(1 / 60.0, handler(self, self.waitRunBy)):setTag(TAG_MOVETWAIT)
        return relust
    end

    if (self.m_isMoveActions == false) then
--        g_mainScene:getCurrBgMap():setTimer_UpdateMap()
--        self:setTimer_DetectionReplaceBgMap()
        self.m_isMoveActions = true
    end

    return relust
end

function Player:waitRunBy()
    self:runBy(self.m_willGoPoint)
end

-- 跑向某个方向
function Player:run_to_derection(direction)
	local result = Player.super.run_to_derection(self, direction);

	if not self.m_is_move_actions then
		self.m_is_move_actions = true;
	end
end

-- 走向某个方向
function Player:walk_to_derection(direction)
	-- body
end

-- 跑到某个点
function Player:go_to_point(point)

end

return Player;
