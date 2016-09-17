--[[-------------------------------------
	Weapon blocker v4 for DarkRP.
	By nedfreetoplay
	Contact: 
	youtube.com/user/zablik23
	steamcommunity.com/id/nedfreetoplay/
	vk.com/merykova
---------------------------------------]]
	local Debug = false
	local DenyMessage1,DenyMessage2 = "Вы не можете взять "," в руку!"
	local SizeAW = 2 --[[Количество работ в AllowWeapon--]]
	local AllowWeapon = {
	[1] = {
		"weapon_physgun",
		"gmod_tool",
		"weapon_357",
		"keys",
		"gmod_camera",
		"pocket",
		"weapon_physcannon"
	},
	[6] = {
		"weapon_physgun",
		"gmod_tool",
		"weapon_357",
		"keys",
		"gmod_camera",
		"pocket",
		"weapon_physcannon",
		"weapon_medkit"
	}
}

hook.Add("PlayerCanPickupWeapon", "TriggerPickUpWeapon", function( ply, wep )
	if wep == nil or ply == nil then return false end
	local job = ply:getJobTable()["team"]
	--Debug
	if Debug then
		print(wep:GetClass())
		print(job)
	end
	--Check walid job
	local i = 0
	for k,v in pairs(AllowWeapon) do
		i = i+1
		if k == job then break else
			if i == SizeAW then
				return true
			end
		end
	end
	--Weapon Checker
	for k,v in pairs(AllowWeapon[job]) do
		if wep:GetClass() == v then
			return true
		end
	end
	--Message
	ply:PrintMessage(HUD_PRINTCENTER,DenyMessage1..wep:GetClass()..DenyMessage2)
	return false
end)