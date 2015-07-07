-- const.lua
-- 定义常量的类，在程序初始化时加载
-- created by xianwx, 2015-06-29 16:33:03

DISPLAY_X_SCALE = display.width / 960;
DISPLAY_Y_SCALE = display.height / 640;

-- 默认的人物和人物数值
DEFAULT_FIGURE_TYPE = 1;
DEFAULT_FIGURE_NUM = 11001;

-- 进入城镇初始点
-- 后期可能每个城镇都会有个
DEFAULT_SAFE_MAP_RESURRECTION_POINT = cc.p(20, 20);

-- 人物的状态
FigureState = {
	DEATH     = 7,  -- 死亡
    HURT      = 6,  -- 伤害
    CASTING   = 5,  -- 投掷
    ATTACK    = 4,  -- 攻击
    RUN       = 3,  -- 跑
    WALK      = 2,  -- 走
    STAND     = 1,  -- 站立
    NONE      = -1
};

-- 人物的朝向
FigureDirection = {
	UP              = 8,    -- 上
    LEFTANDUP       = 7,    -- 左上
    LEFT            = 6,    -- 左
    LEFTANDDOWN     = 5,    -- 左下
    DOWN            = 4,    -- 下
    RIGHTANDDOWN    = 3,    -- 右下
    RIGHT           = 2,    -- 右
    RIGHTANDUP      = 1,    -- 右上
    NONE            = 0
}

-- 纹理类型
Texture_type_path = {
	FIGURE = 1,
    MONSTER = 2,
    HAIR = 3,
    WEAPON = 4,
    SKILLCASTER = 5,
    SKILLLOCUS = 6,
    SKILLEXPLOSION = 7,
    NONE = 0
};

-- MapPoint 格子大小
GRID_SIZE = cc.size(60, 32);

-- 动画的tag
TAG_MOVET = 0xfffff1;
TAG_FOLLOWATTACK = 0xfffff2;
TAG_COOLINGTIMEATTACK = 0xfffff3;
TAG_MOVETWAIT = 0xfffff4;
TAG_ANIMATE = 0xfffff5;

