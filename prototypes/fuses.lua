local red_tint = {r=1, g=0.6, b=0.6}

local pole_names = { "small-electric", "medium-electric", "big-electric", "huge-electric" }
local name_prefix = "po-"
local name_suffix = "-fuse"

for _, pole_name in pairs(pole_names) do
  local name = name_prefix .. pole_name .. name_suffix
  local prototype_name = pole_name .. "-pole"
  if pole_name == "huge-electric" then  -- Already contains "po-" suffix
    prototype_name = "po-huge-electric-pole"
  end

  local fuse = table.deepcopy(data.raw["electric-pole"][prototype_name])
  fuse.name = name
  fuse.minable.result = name
  fuse.icons = {{
    icon = fuse.icon,
    icon_size = fuse.icon_size,
    icon_mipmaps = fuse.icon_mipmaps,
    tint = red_tint,
  }}
  if fuse.pictures.layers then
    fuse.pictures.layers[1].tint = red_tint
    if fuse.pictures.layers[1].hr_version then
      fuse.pictures.layers[1].hr_version.tint = red_tint
    end
  else
    fuse.pictures.tint = red_tint
    if fuse.pictures.hr_version then
      fuse.pictures.hr_version.tint = red_tint
    end
  end
  fuse.localised_description = {"entity-description.po-electric-fuse"}

  local item = table.deepcopy(data.raw.item[prototype_name])
  item.name = name
  item.place_result = name
  item.order = "a[energy]-f[fuse]-" .. item.order
  item.icons = {{
    icon = item.icon,
    icon_size = item.icon_size,
    icon_mipmaps = item.icon_mipmaps,
    tint = red_tint,
  }}

  local recipe = table.deepcopy(data.raw.recipe[prototype_name])
  recipe.name = name
  recipe.result = name
  if pole_name == "small-electric" then
    recipe.enabled = true
  end

  local ingredient_multiplier = 20 / (recipe.result_count or 1)
  local new_ingredients = {}
  for _, ingredient in pairs(recipe.ingredients) do
    table.insert(new_ingredients, {ingredient[1], ingredient[2] * ingredient_multiplier})
  end
  recipe.ingredients = new_ingredients
  recipe.result_count = 1

  data:extend({fuse, item, recipe})
end