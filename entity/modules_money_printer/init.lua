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

	self:SetNWBool( "power", true )
	self:SetNWInt( "interval", MLevel[1][2] )
	self:SetNWInt( "Upgrade", 0 )
	self:SetNWInt( "paper", 5 )
	self:SetNWInt( "paint", 10 )
	self:SetNWInt( "Health", 100 )
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	local Ang = ply:GetAngles()
	Ang:RotateAroundAxis( Ang:Forward(), 180 )
	Ang:RotateAroundAxis( Ang:Right(), 180 )
	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:SetAngles( Ang )
	ent:Setowning_ent( ply )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:OnTakeDamage( Dmg )
	self:SetNWInt( "Health", self:GetNWInt( "Health" ) - Dmg:GetDamage())
	if self:GetNWInt( "Health" ) < 0 then
		self:Destruct()
	end
end

function ENT:Destruct()
	if self:GetNWInt( "Health" ) <= 0 then
		local vPoint = self:GetPos()
		local effectdata = EffectData()
			effectdata:SetStart( vPoint )
			effectdata:SetOrigin( vPoint )
			effectdata:SetScale( 1 )
		util.Effect( "Explosion", effectdata )
		self:Remove()
	end
end

function ENT:Extract()
	if self:GetNWBool( "Cooler" ) == false then return end
	self:SetNWInt( "Cooler", false )
	local x, y, z = self:GetPos() + self:GetAngles():Forward() * 33
	local SpawnPos = Vector( x, y, z )
	local ent = ents.Create( "module_cooler" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
end

function ENT:Try()
	if self:GetNWInt( "paper" ) > 0 and self:GetNWInt( "paint" ) > 0 and 
		self:GetMoneyAmount() ~= self.maxMoney then
		self:SetNWInt( "paper", self:GetNWInt( "paper" ) - 1 )
		self:SetNWInt( "paint", self:GetNWInt( "paint" ) - 1 )
		self:SetMoneyAmount( self:GetMoneyAmount() + self.giveMoney )
	end

	if self:GetNWInt( "Hot" ) < 100 and self:GetNWBool( "Cooler" ) == false then
		self:SetNWInt( "Hot", self:GetNWInt( "Hot" ) + 10 )
	else self:SetNWInt( "ignite", 1 ) end

	if self:GetNWBool( "Cooler" ) == true and self:GetNWInt( "Hot" ) > 0 then
		self:SetNWInt( "Hot", self:GetNWInt( "Hot" ) - HotDecr )
		if self:GetNWInt( "Hot" ) < 0 then self:SetNWInt( "Hot", 0 ) end
	end
end

function ENT:Think()
	if self.CoolDownOnUse > 0 then self.CoolDownOnUse = self.CoolDownOnUse - 1 end
	if self:GetNWInt( "Hot" ) >= 100 and self:GetNWBool( "power" ) == false then
		self:SetNWInt( "Health", self:GetNWInt( "Health" ) - 1 )
		if self:GetNWInt( "Health" ) <= 0 then self:Destruct() end
	end
	--ProgressBar
	if ( CurTime() - self.timer ) / self:GetNWInt( "interval" ) > 1 then
		self:SetNWFloat( "ProgressBar", 1 )
	else
		if self:GetNWBool( "power" ) then
			LocalTime = CurTime() - self.timer
			self:SetNWFloat( "ProgressBar", LocalTime / self:GetNWInt( "interval" ) )
		else self.timer = CurTime() - LocalTime end
	end

	if CurTime() >= self.timer + self:GetNWInt( "interval" ) then
		self.timer = CurTime()
		if self:GetMoneyAmount() < self.maxMoney then
			self:Try()
		end
	end
	if self:GetMoneyAmount() > self.maxMoney then
		self:SetMoneyAmount( self.maxMoney )
	end
end

function ENT:Use( act, call )
	if not call == call:IsPlayer() then return end

	local Ang = self:GetAngles()
	
	local tr = util.GetPlayerTrace( act, ang )
	local tr = util.TraceLine( tr )

	local t = {}
		t.start = act:GetShootPos()
		t.endpos = act:GetAimVector() * 128 + t.start
		t.filter = act
		
	local tr = util.TraceLine( t )

	local pos = self.Entity:WorldToLocal( tr.HitPos )
	local money = self:GetMoneyAmount()

	if tr.Entity == self and pos.y > 12.3 and pos.y < 15 and pos.z > 4.4 and 
		pos.z < 9.6 and self.CoolDownOnUse == 0 then
		if self:GetNWBool( "power" ) == true then
			self:SetNWBool( "power", false )
		else
			self:SetNWBool( "power", true )
		end
		self.CoolDownOnUse = 5
	elseif tr.Entity == self and pos.y > -13.5 and pos.y < 11 and pos.z > 4.4 and 
		pos.z < 9.55 and self.CoolDownOnUse == 0 then
		self:Extract()
		self.CoolDownOnUse = 5
	elseif money > 0 and self.CoolDownOnUse == 0 then
		DarkRP.notify( call, 0, 4, "You take "..money.."$ from Money Printer!" )
		self:SetMoneyAmount(0)
		act:addMoney( money )
		self.CoolDownOnUse = 5
	end
end

function ENT:module_upgrade( entity )
	entity:Remove()
	self:SetNWInt( "Upgrade", self:GetNWInt( "Upgrade" ) + 1 )
	self.giveMoney = MLevel[self:GetNWInt( "Upgrade" ) + 1][1]
	self:SetNWInt( "interval", MLevel[self:GetNWInt( "Upgrade" ) + 1][2])
	self.maxMoney = MLevel[self:GetNWInt( "Upgrade" ) + 1][1] * MaxFactor
end

function  ENT:StartTouch( entity )
	if entity:GetClass() == "module_cooler" and 
		self:GetNWBool( "Cooler" ) == false then
		entity:Remove()
		self:SetNWBool( "Cooler", true )
	elseif entity:GetClass() == "module_paper" and 
		self:GetNWInt( "paper" ) <= 5 then
		entity:Remove()
		self:SetNWInt( "paper", self:GetNWInt( "paper" ) + 5 )
	elseif entity:GetClass() == "module_paint" and 
		self:GetNWInt( "paint" ) <= 10 then
		entity:Remove()
		self:SetNWInt( "paint", self:GetNWInt( "paint" ) + 10 ) end
	for i=1,5 do
		if entity:GetClass() == "module_upgrade_lv"..i and 
			self:GetNWInt( "Upgrade" ) == i - 1	then
		self:module_upgrade( entity ) end
	end
end