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

-- 跑向某个方向
function Player:run_to_derection(direction)
	local result = Player.super.run_to_derection(self, direction);

	if not self.m_is_move_actions then
		self.m_is_move_actions = true;
	end

	if result.float_time ~= 0 then
		g_cur_map:insert_map_point(self, result.map_point);
	end

	if result.float_time == 0 and result.is_can_not_find_the_way == false then
		self.m_will_go_point_ = direction;
		self:stopActionByTag(TAB_MOVETWAIT);
		self:delayCallBack(1 / 60.0, handler(self, self.wait_run_by)):setTag(TAB_MOVETWAIT);
		return result;
	end

	return result;
end

function Player:wait_run_by()
	self:run_to_derection(self.m_will_go_point_);
end

-- 走向某个方向
function Player:walk_to_derection(direction)
	-- body
end

-- 跑到某个点
function Player:go_to_point(point)

end

return Player;
