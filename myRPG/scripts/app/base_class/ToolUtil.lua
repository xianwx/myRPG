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

function ToolUtil.get_z_order_zero(map_size)
	return (-map_size.height / 10.0);
end

-- 赋值
function ToolUtil.set(left, right)
    left.x = right.x
    left.z = right.z
    return left
end

-- 相加
function ToolUtil.add(left, right)
    return ToolUtil.new(left.x + right.x, left.z + right.z)
end

-- 相减
function ToolUtil.sub(left, right)
    return ToolUtil.new(left.x - right.x, left.z - right.z)
end

-- 负号
function ToolUtil.minus(self)
    return ToolUtil.new(-self.x, -self.z)
end

-- 乘以一个数
function ToolUtil.mul(self, a)
    return ToolUtil.new(self.x * a, self.z * a)
end

-- 除以一个数
function ToolUtil.div(self, a)
    error(a, "CCPoint division by 0.");
    return ToolUtil.new(self.x / a, self.z / a)
end

-- 小于
function ToolUtil.less(left, right)
    local a = left.x * 65536 + left.z
    local b = right.x * 65536 + right.z
    return (a < b)
end

-- 相等
function ToolUtil.equals(left, right)
    local a = left.x * 65536 + left.z
    local b = right.x * 65536 + right.z
    return (a == b)
end

-- 对象值相等
function ToolUtil.equals_obj(left, right)
    return (left.x == right.x and left.z == right.z)
end
