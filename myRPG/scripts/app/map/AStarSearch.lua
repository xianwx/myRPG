-- AStarSearch.lua
-- A*寻路算法
-- created by xianwx, 2015-07-07 16:53:15
local AStarSearch = class("AStarSearch");
local AStarNode = class("AStarNode");

function AStarNode:ctor()
	self.parent = nil;
	self.child = nil;
	self.h = 0;
	self.g = 0;
	self.f = 0;

	self.node_state = nil;
end

function AStarSearch:ctor()

	-- A星寻路需要用到的两个数组
	self.m_open_list_ = {};
	self.m_close_list_ = {};

	self.m_state_ = SEARCH_STATE_NOT_INITIALISED;
	self.m_successors_ = {};

	self.m_cancel_search_ = false;

	self.m_cur_solution_node_ = nil;

	-- 目前的起点
	self.m_start_ = nil;
	self.m_end_ = nil;
end

-- 初始化寻路
function AStarSearch:start_and_goal_states(start_node, end_node)

	self.m_state_ = SEARCH_STATE_SEARCHING;
	self.m_start_ = AStarNode.new();
	self.m_end_ = AStarNode.new();

	self.m_start_.node_state = start_node;
	self.m_end_.node_state = end_node;

	self.m_start_.g = 0;
	self.m_start_.h = start_node:goal_distance_estimate(end_node);
	self.m_start_.f = self.m_start_.g + self.m_start_.h;
	self.m_start_.parent = nil;

	table.insert(self.m_open_list_, self.m_start_);
	ToolUtil.push_heap(self.m_open_list_, 1, #self.m_open_list_);

	self.m_steps_ = 0;
end

-- 寻路并返回当前状态
function AStarSearch:search_and_return_state()

	-- 寻路状态未在定义中
	if ToolUtil.a_star_search_state_no_define(self.m_state_) then
		return self.m_state_;
	end

	-- 已经寻路完毕，成功或失败
	if self.m_state_ == SEARCH_STATE_SUCCESSED or self.m_state_ == SEARCH_STATE_FAILED then
		return self.m_state_;
	end

	-- 找不到地方，或者玩家自己取消了寻路
	if #self.m_open_list_ < 0 or self.m_cancel_search_ then
		self:free_all_node();
		self.m_state_ = SEARCH_STATE_FAILED;
		return self.m_state_;
	end

	self.m_steps_ = self.m_steps_ + 1;

	local node = self.m_open_list_[1];
	pop_heap(self.m_open_list_, 1, #self.m_open_list_);
	table.remove(self.m_open_list_);

	-- 已经找到了目标点
	if node.node_state:is_goal(self.m_end_.node_state) then
		self.m_end_.parent = node.parent;
		if not (node.node_state:is_same_point(self.m_start_.node_state.x, self.m_start_.node_state.y)) then
			node = nil;

			local node_child = self.m_end_;
			local node_parent = self.m_end_.parent;

			repeat
				node_parent.child = node_child;
				node_child = node_parent;
				node_parent = node_parent.parent;
			until node_child == self.m_start_

			self:free_all_unSearch_node();
			self.m_state_ = SEARCH_STATE_SUCCEEDED;
			return self.m_state_;
		end
	else

		self.m_successors_ = {};
		local ret = node.node_state:get_successors(self, (node.parent and node.parant.node_state or nil));
		if not ret then

			-- 清空所有successors，并清空缓存的node
			self.m_successors_ = {};
			self:free_all_node();
			self.m_state_ = SEARCH_STATE_OUT_OF_MEMORY;
			return self.m_state_;
		end

		local successor = nil;

		for i = 1, #self.m_successors_ do

			successor = self.m_successors_[i];

			local new_g = node.g + node.node_state:get_cost();
			local open_list_result = nil;
			local open_list_index = 1;
			local close_list_result = nil;
			local close_list_index = 1;

			for j = 1, #self.m_open_list_ do
				if self.m_open_list_[j].node_state:is_same_point(successor.node_state.x, successor.node_state.y) then
					open_list_result = self.m_open_list_[j];
					open_list_index = j;
					break;
				end
			end

			if open_list_result and open_list_result.g <= new_g then
				-- 这个点是在close列表里
				successor = nil;
			else
				close_list_result = nil;
				close_list_index = 1;
				for j = 1, #self.m_close_list_ do
					if self.m_close_list_[j].node_state:is_same_point(successor.node_state.x, successor.node_state.y) then
						close_list_result = self.m_close_list_[j];
						close_list_index = j;
						break;
					end
				end

				if close_list_result and close_list_result.g <= new_g then
					successor = nil;
				else
					successor.parent = node;
					successor.g = new_g;
					successor.h = successor.node_state:goal_distance_estimate(self.end_node.node_state);
					successor.f = successor.g + successor.h;

					if close_list_result then
						table.remove(self.m_close_list_, close_list_index);
						close_list_result = nil;
					end

					if open_list_result then
						table.remove(self.m_open_list_, open_list_index);
						open_list_result = nil;

						make_heap(self.m_open_list_, 1, #self.m_open_list_);
					end

					table.insert(self.m_open_list_, successor);

					push_heap(self.m_open_list_, 1, #self.m_open_list_);
				end
			end
		end

		table.insert(self.m_close_list_);
	end
end

function AStarSearch:add_successor(state)

	local node = AStarNode.new();

    if (node) then
        node.node_state = state;
        table.insert(self.m_successors_, node);
        return true;
    end

    return false;
end

-- 清空所有node
function AStarSearch:free_all_node()
	self.m_open_list_ = nil;
	self.m_close_list_ = nil;

	self.m_open_list_ = {};
	self.m_close_list_ = {};
end

-- 清空所有没有搜寻的node
function AStarSearch:free_all_unSearch_node()
	self:free_all_node();
end

-- 获取解集起始点
function AStarSearch:get_solution_start()
	self.m_cur_solution_node_ = self.m_start_;
	return self.m_cur_solution_node_;
end

-- 获取下一步的解
function AStarSearch:get_solution_next()

	if self.m_cur_solution_node_ then
		if self.m_cur_solution_node_.child then
			local child = self.m_cur_solution_node_.child;
			self.m_cur_solution_node_ = self.m_cur_solution_node_.child;
			return child.node_state;
		end
	end

    return nil;
end

-- 获取解集终点
function AStarSearch:get_solution_end()

	self.m_cur_solution_node_ = self.m_end_;
	if self.m_end_ then
		return self.m_end_.node_state;
	else
		return nil;
	end
end

-- 取消寻路
function AStarSearch:cancel_search()
	self.m_cancel_search_ = true;
end

return AStarSearch;
