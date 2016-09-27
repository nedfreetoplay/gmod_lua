include("shared.lua")

surface.CreateFont( "MoneyFont", {
	font = "Arial", size = 50, weight = 500, antialias = true,} 
)
surface.CreateFont( "MoneyFont2", {
	font = "Arial", size = 75, weight = 500, antialias = true,} 
)
surface.CreateFont( "HotFont", {
	font = "Arial", size = 35, weight = 500, antialias = true,} 
)

local test = false
local HotColor = 0
local powerPBC
local Color1 = Color( 0, 0, 0, 200 )
local Color2 = Color( 70, 70, 70 )
local Color3 = Color( 200, 200, 200 )

function draw.Circle( x, y, radius, seg, pi )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -pi )
		table.insert( cir, { x = x - math.sin( a ) * radius, y = y - math.cos( a ) * radius, 
			u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
		--PrintTable(cir)
	end

	surface.DrawPoly( cir )
end


function ENT:Draw()
	local _player = LocalPlayer()
	self:DrawModel()
	_self = self
	if _player:EyePos():Distance( self.Entity:GetPos() ) > 1000 then return end
	--Upgrade System
	local Upgrades = self:GetNWInt( "Upgrade" )
	if Upgrades == 1 then self:SetColor( Color( 218, 218, 218 ) ) self:SetMaterial( "models/shiny", false )
	elseif Upgrades == 2 then self:SetColor( Color( 255, 242, 0 ) )
	elseif Upgrades == 3 then self:SetColor( Color( 255, 0, 0 ) )
	elseif Upgrades == 4 then self:SetColor( Color( 29, 223, 0 ) )
	elseif Upgrades == 5 then self:SetColor( Color( 0, 242, 242 ) )
	end
	local FillBur = math.abs( self:GetNWFloat( "ProgressBar" ) -1 )
	local HotBur = nil
	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:Getowning_ent()
    owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	if self:GetNWBool( "Cooler" ) == true then
		HotBur = Color( 7, 247, 247 )
	else 
		HotBur = Color2
	end

	Ang:RotateAroundAxis( self:GetAngles():Up(), 90 )

	--cooler = ClientsideModel ("models/props_phx/gears/bevel12.mdl", RENDERGROUP_OPAQUE )

	cam.Start3D2D( Pos *1.0 + Ang:Up() * 11.1, Ang, 0.1 )
		--[[-----------------------------------------
			Upgrade
		--]]-----------------------------------------
		draw.RoundedBox( 10, -152.5, -150, 100, 100, Color1 )
		draw.RoundedBox( 0, -147.5, -145, 90, 90, Color3 )
		draw.RoundedBox( 0, -147.5, -55, 90, 
			-self:GetNWInt( "Upgrade" )*18, Color( 255, 120, 0 ) )
		draw.SimpleText( self:GetNWInt( "Upgrade" ).."/5", "HotFont", -120, -130, 
			Color( 2, 142, 155 ), 1, 1 )

		--[[-----------------------------------------
			Hot
		--]]-----------------------------------------
		draw.RoundedBox( 10, -152.5, 50, 100, 100, Color1 )
		draw.RoundedBox( 0, -147.5, 55, 90, 90, Color3 )
		draw.RoundedBox( 0, -147.5, 55, 90, 
			self:GetNWInt( "Hot" )*0.9, HotBur )
		draw.SimpleText( self:GetNWInt( "Hot" ).."°", "HotFont", -120, 130, 
			Color( 255, 119, 7 ), 1, 1 )

		--[[-----------------------------------------
			Paint
		--]]-----------------------------------------
		draw.RoundedBox( 10, 52.5, -150, 100, 100, Color1 )
		draw.RoundedBox( 0, 57.5, -145, 90, 90, Color3 )
		draw.RoundedBox( 0, 57.5, -55, 90, 
			-self:GetNWInt( "paint" )*4.5, Color( 0, 0, 0 ) )
		draw.SimpleText( self:GetNWInt( "paint" ), "HotFont", 130, -130, 
			Color( 255, 255, 255 ), 1, 1 )

		--[[-----------------------------------------
			Paper
		--]]-----------------------------------------
		draw.RoundedBox( 10, 52.5, 50, 100, 100, Color1 )
		draw.RoundedBox( 0, 57.5, 55, 90, 90, Color3 )
		draw.RoundedBox( 0, 57.5, 55, 90, 
			self:GetNWInt( "paper" )*9, Color( 255, 255, 255 ) )
		draw.SimpleText( self:GetNWInt( "paper" ), "HotFont", 130, 130, 
			Color( 0, 0, 0 ), 1, 1 )

		draw.NoTexture()
		surface.SetDrawColor( 200,150,255 )
		draw.Circle( 2.5, 0, 150, 32, 360 )
		surface.SetDrawColor( 150,255,150 )
		draw.Circle( 2.5, 0, 140, 32, 360 )
		surface.SetDrawColor( 180,140,140 )
		draw.Circle( 2.5, 0, 140, 32, FillBur*360 )
		if not self:GetNWBool("power") then
		surface.SetDrawColor( 65, 220, 140 )
		draw.Circle( 2.5, 0, 140, 32, 360 )
		end
		surface.SetDrawColor( 65, 200, 220 )
		draw.Circle( 2.5, 0, 110, 32, 360 )

		--[[-----------------------------------------
			Money
		--]]-----------------------------------------
		draw.SimpleText( self:GetMoneyAmount().."$", "MoneyFont2", 2.5, 0, 
		Color( 0, 100, 0 ), 1, 1 )
	cam.End3D2D()
	
	Ang:RotateAroundAxis( Ang:Forward(), 90 )
	cam.Start3D2D( Pos *1.0 + Ang:Up() * 17, Ang, 0.1 )
		--[[-----------------------------------------
		Health
	    --]]-----------------------------------------
		draw.RoundedBox( 10, -140, -100, 255, 60, Color2 )
		draw.RoundedBox( 0, -135, -95, 245, 50, Color3 )
		draw.RoundedBox( 0, -135, -95, self:GetNWInt( "Health" )*2.45, 50, 
		Color( 255, 100, 100 ) )

		--[[-----------------------------------------
			Power
		--]]-----------------------------------------
		draw.RoundedBox( 0, 120, -100, 34, 60, Color2 )
		draw.RoundedBox( 0, 124, -96, 26, 52, Color3 )
		if self:GetNWBool( "power" ) then
			draw.RoundedBox( 0, 124, -96, 26, 26, Color( 0, 0, 200 ) )
		else 
			draw.RoundedBox( 0, 124, -70, 26, 26, Color( 200, 0, 0 ) )
		end
	cam.End3D2D()

	--[[-----------------------------------------
		Player Name
	--]]-----------------------------------------
	Smooth = 80
	Ang:RotateAroundAxis( Ang:Forward(), -45 )
	cam.Start3D2D( Pos *1.0 + Ang:Up() * -4, Ang, 0.1 )
		local tr = util.GetPlayerTrace( _player, ang )
		local tr = util.TraceLine(tr)

		local Cord
		local t = {}
			t.start = _player:GetShootPos()
			t.endpos = _player:GetAimVector() * 128 + t.start
			t.filter = _player
		
		local tr = util.TraceLine(t)

		if tr.Entity == self then 
			Cord = 80
		else
			Cord = 0
		end

		draw.RoundedBox( 0, -145, -180-Cord, 300, 70, Color(100,100,100) )
		draw.RoundedBox( 0, -140, -175-Cord, 290, 60, Color(200,200,200) )
		draw.SimpleText( owner, "MoneyFont", 0, -145-Cord, Color( 255, 120, 0 ), 1, 1 )
	cam.End3D2D()
end