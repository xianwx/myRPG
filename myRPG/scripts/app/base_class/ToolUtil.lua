-- ToolUtil.lua
-- 提供一些全局方法，作为公用处理类
-- created by xianwx, 2015-06-29 15:39:24

-- 创建个全局变量，就不需要requie文件
ToolUtil = {};

local MapPoint = require("app.map.MapPoint");

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
    left.x = right.x;
    left.y = right.y;
    return left;
end

-- 相加
function ToolUtil.add(left, right)
    return MapPoint.new(left.x + right.x, left.y + right.y);
end

-- 相减
function ToolUtil.sub(left, right)
    return MapPoint.new(left.x - right.x, left.y - right.y);
end

-- 负号
function ToolUtil.minus(m_point)
    return MapPoint.new(-m_point.x, -m_point.y);
end

-- 乘以一个数
function ToolUtil.mul(m_point, a)
    return MapPoint.new(m_point.x * a, m_point.y * a);
end

-- 除以一个数
function ToolUtil.div(m_point, a)
    if a == 0 then
        error(a, "CCPoint division by 0.");
    end
    return MapPoint.new(m_point.x / a, m_point.y / a);
end

-- 小于
function ToolUtil.less(left, right)
    local a = left.x * 65536 + left.y;
    local b = right.x * 65536 + right.y;
    return (a < b);
end

-- 相等
function ToolUtil.equals(left, right)
    local a = left.x * 65536 + left.y;
    local b = right.x * 65536 + right.y;
    return (a == b);
end

-- 对象值相等
function ToolUtil.equal_map_point(left, right)
    return (left.x == right.x and left.y == right.y);
end

-- 寻路状态未在定义中
function ToolUtil.a_star_search_state_no_define(state)
    if type(state) ~= "number" then
        return false;
    end

    return (state < SEARCH_STATE_NOT_INITIALISED) or (state > SEARCH_STATE_FAILED);
end

-- 堆栈的操作
-- 往堆栈里加入元素
function ToolUtil.push_heap(array, first, last)
    ToolUtil.make_heap(array, first, last);
end

-- 往堆栈里弹出元素
function ToolUtil.pop_heap(array, first, last)
    array[first], array[last] = array[last], array[first];
    ToolUtil.make_heap(array, first, last - 1);
end

-- 对A星寻路的堆栈进行筛选
function ToolUtil.sift_heap(array, first, last)
    local i = first;             -- 被筛选结点索引
    local j = 2 * i;             -- 被筛选结点的左孩子索引
    local temp = array[i];       -- 保存被筛选结点

    while (j <= last) do
        if (j < last and array[j].f > array[j + 1].f) then
            j = j + 1 ;          -- 若右孩子较小，把j指向右孩子
        end

        if (temp.f > array[j].f) then
            array[i] = array[j]; -- 将array[j]调整到双亲结点位置上
            i = j;               -- 修改i和j值，指向下一个被筛选结点和被筛选结点的左孩子
            j = 2 * i;
        else
            break;               -- 已是小根堆，筛选结束
        end
    end

    array[i] = temp;             -- 被筛选结点的值放入最终位置
end

-- 创造一个堆栈元素
function ToolUtil.make_heap(array, first, last)
    local n = last - first + 1;
    for i = math.floor(n / 2), 1, -1 do
        ToolUtil.sift_heap(array, i, n);
    end
end
