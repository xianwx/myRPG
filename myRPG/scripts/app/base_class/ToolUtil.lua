-- ToolUtil.lua
-- 提供一些全局方法，作为公用处理类
-- created by xianwx, 2015-06-29 15:39:24

-- 创建个全局变量，就不需要requie文件
ToolUtil = {};

function ToolUtil.message_box_animation(param)

	-- 先获取初始位置和需要移动到的位置
	local start_pos = param.start_pos;
	local end_pos = param.end_pos;

	-- 获取确认以及取消函数
	local confim_handler = param.confim_handler;
	local cancel_handler = param.cancel_handler;

	-- 缩放指数
	local scale = param.scale or 1;


end
