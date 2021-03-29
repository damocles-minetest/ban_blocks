local has_xban_mod = minetest.get_modpath("xban2")

minetest.register_node("ban_blocks:ban", {
	description = "Ban block",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drawtype = "glasslike",
	drowning = 1,
	post_effect_color = {a = 20, r = 250, g = 20, b = 20},
	tiles = {"instaban_texture.png^[colorize:#F0505033"},
	alpha = 0.1,
	groups = {},
	paramtype = "light",
	drop = {},
	sunlight_propagates = true
})

minetest.register_node("ban_blocks:kick", {
	description = "Kick block",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drawtype = "glasslike",
	drowning = 1,
	post_effect_color = {a = 20, r = 20, g = 250, b = 20},
	tiles = {"instaban_texture.png^[colorize:#50F05033"},
	alpha = 0.1,
	groups = {},
	paramtype = "light",
	drop = {},
	sunlight_propagates = true
})

local function check_player(player)
	local has_noclip = minetest.check_player_privs(player, "noclip")
	if has_noclip then
		-- player with noclip priv, skip check
		return
	end

	local playername = player:get_player_name()
	local node = minetest.get_node(player:get_pos())
	if node.name == "ban_blocks:kick" then
		minetest.log("action", "player " .. playername .. " entered a kick-block")
		minetest.kick_player(playername)

	elseif node.name == "ban_blocks:ban" and has_xban_mod then
		minetest.log("action", "player " .. playername .. " entered a ban-block")
		xban.ban_player(playername, "ban_blocks", nil, "ban_blocks:ban")

	end
end

-- check for player-block positions every second
local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 1 then
		return
	end
	timer = 0

	for _, player in pairs(minetest.get_connected_players()) do
		check_player(player)
	end
end)
