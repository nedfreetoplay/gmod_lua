AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

util.AddNetworkString("receiveMessage")

include("shared.lua")
	local LocalTime = nil
	local Cfg = ImpCfg

function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end

	self.timer = CurTime()
	self.giveMoney = Cfg.StatUpgrade[1][1]
	self.maxMoney = Cfg.StatUpgrade[1][1] * Cfg.MaxVolume
	self.CoolDownOnUse = 10

	self:SetNWBool( "power", Cfg.Power )
	self:SetNWInt( "interval", Cfg.StatUpgrade[2][1] )
	self:SetNWInt( "Upgrade", Cfg.PrimaryUpgrade )
	self:SetNWInt( "paper", Cfg.SpawnPaper )
	self:SetNWInt( "paint", Cfg.SpawnPaint )
	self:SetNWInt( "Health", Cfg.healthPrinter )
	self:SetNWBool( "Unc", false)

	if not Cfg.Power then
		LocalTime = CurTime()
	end
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
	if self:GetNWBool( "Cooler" ) == false or 
		Cfg.ExtractionCooler == false then return end
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
		self:SetNWInt( "Hot", self:GetNWInt( "Hot" ) - Cfg.HotDecrease )
		if self:GetNWInt( "Hot" ) < 0 then self:SetNWInt( "Hot", 0 ) end
	end
end

function ENT:Think()
	if self.CoolDownOnUse > 0 then
		self.CoolDownOnUse = self.CoolDownOnUse - 1 end
	if self:GetNWInt( "Hot" ) >= 100 and 
		self:GetNWBool( "power" ) and
		self:GetNWBool( "Cooler" ) == false then
		self:SetNWInt( "Health", self:GetNWInt( "Health" ) - 1 )
		if self:GetNWInt( "Health" ) <= 0 then self:Destruct() end
	end
	--ProgressBar
	local Time = Lerp( (CurTime() - self.timer)/self:GetNWInt( "interval" ), 0 , 360 )
	
	if Time > 360 then
		self:SetNWFloat( "ProgressBar", 360 )
	else
		if self:GetNWBool( "power" ) then
			LocalTime = CurTime() - self.timer
			self:SetNWFloat( "ProgressBar", Time )
		else self.timer = CurTime() - LocalTime end
	end
	--print(self:GetNWFloat( "ProgressBar" ))

	if CurTime() >= self.timer + self:GetNWInt( "interval" ) then
		self.timer = CurTime()
		if self:GetMoneyAmount() < self.maxMoney and 
			self:GetNWBool("power") then
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
	
	if tr.Entity == self and pos.y > 11.8 and pos.y < 15 and pos.x > 14.8 and 
		pos.x < 15.9 and self.CoolDownOnUse == 0 then
		if self:GetNWBool( "power" ) == true then
			self:SetNWBool( "power", false )
		else self:SetNWBool( "power", true ) end
		self.CoolDownOnUse = 5
	elseif tr.Entity == self and pos.y > -14.6 and pos.y < -11.6 and pos.x > 14.8 and 
		pos.x < 16 and self.CoolDownOnUse == 0 then
		self:Extract()
		self.CoolDownOnUse = 5
	elseif money > 0 and self.CoolDownOnUse == 0 then
		DarkRP.notify( call, 0, 4, Cfg.PaymentText1..money..Cfg.PaymentText2 )
		self:SetMoneyAmount(0)
		act:addMoney( money )
		self.CoolDownOnUse = 5
	end
end

function ENT:module_upgrade( entity )
	entity:Remove()
	self:SetNWInt( "Upgrade", self:GetNWInt( "Upgrade" ) + 1 )
	self.giveMoney = Cfg.StatUpgrade[1][self:GetNWInt( "Upgrade" ) + 1]
	self:SetNWInt( "interval", Cfg.StatUpgrade[2][self:GetNWInt( "Upgrade" ) + 1])
	self.maxMoney = Cfg.StatUpgrade[1][self:GetNWInt( "Upgrade" ) + 1] * Cfg.MaxVolume
end

function  ENT:StartTouch( entity )
	if entity:GetClass() == "module_cooler" and 
		self:GetNWBool( "Cooler" ) == false then
		entity:Remove()
		self:SetNWBool( "Cooler", true )
	elseif entity:GetClass() == "module_paper" and 
		self:GetNWInt( "paper" ) <= Cfg.MaxPaper-Cfg.ReFillPaper then
		entity:Remove()
		self:SetNWInt( "paper", self:GetNWInt( "paper" ) + Cfg.ReFillPaper )
	elseif entity:GetClass() == "module_paint" and 
		self:GetNWInt( "paint" ) <= Cfg.MaxPaint-Cfg.ReFillPaint then
		entity:Remove()
		self:SetNWInt( "paint", self:GetNWInt( "paint" ) + Cfg.ReFillPaint ) end
	for i=1,Cfg.MaxUpgrade do
		if entity:GetClass() == "module_upgrade_lv"..i and 
			self:GetNWInt( "Upgrade" ) == i - 1	then
		self:module_upgrade( entity ) end
	end
end