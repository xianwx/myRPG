-- TextureController.lua
-- 纹理控制器
-- created by xianwx, 2015-07-01 09:21:19

-- 定义一些路径
local FIGURE_PATH = "char_"                  -- 人物图片
local MONSTER_PATH = "monster_"              -- 怪物图片
local HAIR_PATH = "hair_" 					 -- 头发图片
local WEAPON_PATH = "weapon_"				 -- 武器图片
local SKILL_CASTER_PATH = "caster_"			 -- 一种投掷技能的图片
local SKILL_LOCUS_PATH = "locus_"			 -- 轨迹图片
local SKILL_EXPLOSION_PATH = "explosion_" 	 -- 爆炸技能图片

local FIGURE_ROUTE = "texture_figure/"		 -- 人物图片文件夹路径
local MONSTER_ROUTE = "texture_monster/"	 -- 怪物图片文件夹路径
local HAIR_ROUTE = "texture_figure/"		 -- 头发图片文件夹路径
local WEAPON_ROUTE = "texture_weapon/"		 -- 武器图片文件夹路径
local SKILL_ROUTE = "texture_skill/"		 -- 技能图片文件夹路径
local OTHER_ROUTE = "texture_set/"			 -- 大概是NPC图片文件夹路径

local textureSuffix = ".plist"				 -- 描述文件后缀名
local texturePngSuffix = ".png"				 -- 图片格式

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

local TextureController = class("TextureController");

function TextureController:ctor()

end

-- 返回纹理的文件路径
function TextureController.get_texture_path(texture_type, num)
	local path = "";

	if texture_type == Texture_type_path.NONE then
		return path;
	end

	if (texture_type == Texture_type_path.FIGURE) then
        path = FIGURE_PATH;
    elseif (texture_type == Texture_type_path.MONSTER) then
        path = MONSTER_PATH;
    elseif (texture_type == Texture_type_path.HAIR) then
        path = HAIR_PATH;
    elseif (texture_type == Texture_type_path.WEAPON) then
        path = WEAPON_PATH;
    elseif (texture_type == Texture_type_path.SKILLCASTER) then
        path = SKILL_CASTER_PATH;
    elseif (texture_type == Texture_type_path.SKILLLOCUS) then
        path = SKILL_LOCUS_PATH;
    elseif (texture_type == Texture_type_path.SKILLEXPLOSION) then
        path = SKILL_EXPLOSION_PATH;
    else
        path = "";
    end

    if (path ~= "") then
        path = path .. num;
    end

	return path;
end

-- 返回包括文件夹的路径
function TextureController.get_texture_route(texture_type, num)
	local path = "";

	if texture_type == Texture_type_path.NONE then
		return path;
	end

	if (texture_type == Texture_type_path.FIGURE) then
        path = FIGURE_ROUTE .. FIGURE_PATH;
    elseif (texture_type == Texture_type_path.MONSTER) then
        path = MONSTER_ROUTE .. MONSTER_PATH;
    elseif (texture_type == Texture_type_path.HAIR) then
        path = HAIR_ROUTE .. HAIR_PATH;
    elseif (texture_type == Texture_type_path.WEAPON) then
        path = WEAPON_ROUTE .. WEAPON_PATH;
    elseif (texture_type == Texture_type_path.SKILLCASTER) then
        path = SKILL_ROUTE .. SKILL_CASTER_PATH;
    elseif (texture_type == Texture_type_path.SKILLLOCUS) then
        path = SKILL_ROUTE .. SKILL_LOCUS_PATH;
    elseif (texture_type == Texture_type_path.SKILLEXPLOSION) then
        path = SKILL_ROUTE .. SKILL_EXPLOSION_PATH;
    else
        path = "";
    end

    if (path ~= "") then
        path = path .. num;
    end

	return path;
end

function TextureController.add_sprite_frame(sprite_type, num, callback)

	if num == 0 then
        return;
    end

    local path = TextureController.get_texture_route(sprite_type, num);
    if path == "" then
        return;
    end

    local pngFileName = path .. texturePngSuffix;
    local plistFileName = path .. textureSuffix;

    display.addSpriteFramesWithFile(plistFileName, pngFileName);

    if num == 0 then
    	return;
    end

	if callback then
		callback();
	end
end

function TextureController.sub_sprite_frame(sprite_type, num, callback)

	if num == 0 then
		return;
	end

	CCTextureCache:sharedTextureCache():removeUnusedTextures();

	if callback then
		callback();
	end
end

function TextureController:remove_all_sprite_frame()
	CCTextureCache:sharedTextureCache():removeUnusedTextures();
end

return TextureController;
