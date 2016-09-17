AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

util.AddNetworkString("receiveMessage")

include("shared.lua")

--Изменяемые переменные
	local MaxFactor = 10
	local HotDecr = 10
	local LocalTime = nil
	--{Money,Interval}
	local MLevel = {
	{10,60},
	{15,60},
	{25,50},
	{35,50},
	{50,40},
	{60,20},
}

function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end

	self.timer = CurTime()
	self.giveMoney = MLevel[1][1]
	self.maxMoney = MLevel[1][1] * MaxFactor
	self.maxUpgrade = 5
	self.CoolDownOnUse = 0

	self:SetOwner( self.Owner )
	self:SetNWBool( "turn", true )
	self:SetNWInt("interval", MLevel[1][2])
	self:SetNWInt("Upgrade", 0)
end

function ENT:Think()
	if self.CoolDownOnUse > 0 then self.CoolDownOnUse = self.CoolDownOnUse - 1 end
	--ProgressBar
	if (CurTime() - self.timer)/self:GetNWInt("interval") > 1 then
		self:SetNWFloat("ProgressBar", 1)
	else
		if self:GetNWBool("turn") then
			LocalTime = CurTime() - self.timer
			self:SetNWFloat("ProgressBar", LocalTime/self:GetNWInt("interval"))
		else self.timer = CurTime() - LocalTime end
	end

	if CurTime() >= self.timer + self:GetNWInt("interval") then
		self.timer = CurTime()
		if self:GetMoneyAmount() < self.maxMoney then
			self:SetMoneyAmount(self:GetMoneyAmount() + self.giveMoney)
			--Temp
			if self:GetNWInt("Hot") < 100 and self:GetNWBool("Cooler") == false then
				self:SetNWInt("Hot",self:GetNWInt("Hot") + 10)
			else
				self:SetNWInt("ignite",1)
			end

			if self:GetNWBool("Cooler") == true and self:GetNWInt("Hot") > 0 then
				self:SetNWInt("Hot", self:GetNWInt("Hot") - HotDecr)
				if self:GetNWInt("Hot") < 0 then self:SetNWInt("Hot", 0) end
			end
		end
	end
	if self:GetMoneyAmount() > self.maxMoney then
		self:SetMoneyAmount(self.maxMoney)
	end
end

function ENT:Use( act, call )
	if not call == call:IsPlayer() then return end

	local Ang = self:GetAngles()
	local Ply = act
	
	local tr = util.GetPlayerTrace( Ply, ang )
	local tr = util.TraceLine(tr)

	local t = {}
		t.start = Ply:GetShootPos()
		t.endpos = Ply:GetAimVector() * 128 + t.start
		t.filter = Ply
		
	local tr = util.TraceLine(t)

	local pos = self.Entity:WorldToLocal(tr.HitPos)
	local money = self:GetMoneyAmount()

	if tr.Entity == self and pos.x > 6.5 and pos.x < 14 and pos.y > 11 and pos.y < 14.5 and self.CoolDownOnUse == 0 then
		if self:GetNWBool("turn") == true then
			self:SetNWBool( "turn", false )
		else
			self:SetNWBool( "turn", true )
		end
		self.CoolDownOnUse = 5
	elseif money > 0 then
		self:SetMoneyAmount(0)
		Ply:addMoney(money)
	end
end

function module_upgrade( entity, self )
	entity:Remove()
	self:SetNWInt("Upgrade", self:GetNWInt("Upgrade") + 1)
	self:SetNWInt("PBarUpgrade", (self:GetNWInt("Upgrade") / 5)*80)
	self.giveMoney = MLevel[self:GetNWInt("Upgrade") + 1][1]
	self:SetNWInt("interval", MLevel[self:GetNWInt("Upgrade") + 1][2])
	self.maxMoney = MLevel[self:GetNWInt("Upgrade") + 1][1] * MaxFactor
end

function  ENT:StartTouch( entity )
	if entity:GetClass() == "module_cooler" then
		if self:GetNWBool("Cooler") == false then
			entity:Remove()
			self:SetNWBool("Cooler",true)
		end
	elseif entity:GetClass() == "module_upgrade_lv1" and self:GetNWInt("Upgrade") == 0 then module_upgrade(entity, self)
	elseif entity:GetClass() == "module_upgrade_lv2" and self:GetNWInt("Upgrade") == 1 then module_upgrade(entity, self)
	elseif entity:GetClass() == "module_upgrade_lv3" and self:GetNWInt("Upgrade") == 2 then module_upgrade(entity, self)
	elseif entity:GetClass() == "module_upgrade_lv4" and self:GetNWInt("Upgrade") == 3 then module_upgrade(entity, self)
	elseif entity:GetClass() == "module_upgrade_lv5" and self:GetNWInt("Upgrade") == 4 then module_upgrade(entity, self)
	end
	--[[self : EmitSound( "ambient/explosions/explode_"..math.random( 1, 9 )..".wav" )
	print(entity:GetName())--]]
end