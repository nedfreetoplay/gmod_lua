include("shared.lua")

surface.CreateFont( "MoneyFont", {
	font = "Comic Sans MS", size = 35, weight = 500, antialias = true,} 
)
surface.CreateFont( "MoneyFont2", {
	font = "Comic Sans MS", size = 50, weight = 500, antialias = true,} 
)
surface.CreateFont( "HotFont", {
	font = "Comic Sans MS", size = 35, weight = 500, antialias = true,} 
)

function draw.Circle( x, y, radius, seg, pi )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( (( i / seg ) * -pi)-(360-pi) )

		table.insert( cir, { x = x - math.sin( a ) * radius, y = y - math.cos( a ) * radius, 
			u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	surface.DrawPoly( cir )
end

function ENT:Draw()
	if not self:GetNWBool( "Unc" ) then self.Smooth = 360 self:SetNWBool( "Unc" , true ) end
	local Cfg = ImpCfg
	local _player = LocalPlayer()
	self:DrawModel()
	if _player:EyePos():Distance( self.Entity:GetPos() ) > 1000 then return end
	--Upgrade System
	local Upgrades = self:GetNWInt( "Upgrade" )
	if Upgrades == 1 then self:SetColor( Cfg.UpgradeColor1 ) self:SetMaterial( "models/shiny", false )
	elseif Upgrades == 2 then self:SetColor( Cfg.UpgradeColor2 )
	elseif Upgrades == 3 then self:SetColor( Cfg.UpgradeColor3 )
	elseif Upgrades == 4 then self:SetColor( Cfg.UpgradeColor4 )
	elseif Upgrades == 5 then self:SetColor( Cfg.UpgradeColor5 )
	end
	local FillBur = self:GetNWFloat( "ProgressBar" )
	if FillBur >= 355 then self.Smooth = 360 end
	self.Smooth = Lerp(FrameTime()*10, self.Smooth, FillBur)
	local HotBur = nil
	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:Getowning_ent()
    owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	if self:GetNWBool( "Cooler" ) then
		HotBur = Cfg.InstCooler else 
		HotBur = Cfg.TempColor
	end

	Ang:RotateAroundAxis( self:GetAngles():Up(), 90 )

	--cooler = ClientsideModel ("models/props_phx/gears/bevel12.mdl", RENDERGROUP_OPAQUE )

	cam.Start3D2D( Pos *1.0 + Ang:Up() * 11.1, Ang, 0.1 )
		--[[-----------------------------------------
			Core
		--]]-----------------------------------------	
		draw.RoundedBox( 10, -152.5, -150, 305, 315, Cfg.BGColor )


		--[[-----------------------------------------
			Upgrade
		--]]-----------------------------------------
		draw.RoundedBox( 0, -147.5, -145, 90, 90, Cfg.BGPrColor )
		draw.RoundedBox( 0, -147.5, -55, 90, 
			-self:GetNWInt( "Upgrade" )*18, Cfg.UpgradesColor )
		draw.SimpleText( self:GetNWInt( "Upgrade" ).."/"..Cfg.MaxUpgrade, "HotFont", -145, -130, 
			Cfg.UpgTextColor, 0, 1 )

		--[[-----------------------------------------
			Hot
		--]]-----------------------------------------
		draw.RoundedBox( 0, -147.5, 55, 90, 90, Cfg.BGPrColor )
		draw.RoundedBox( 0, -147.5, 55, 90, 
			self:GetNWInt( "Hot" )*0.9, Cfg.TempColor )
		draw.SimpleText( self:GetNWInt( "Hot" ).."°", "HotFont", -145, 130, 
			Cfg.TempTextColor, 0, 1 )

		--[[-----------------------------------------
			Paint
		--]]-----------------------------------------
		draw.RoundedBox( 0, 57.5, -145, 90, 90, Cfg.BGPrColor )
		draw.RoundedBox( 0, 57.5, -55, 90, 
			-self:GetNWInt( "paint" )*4.5, Color( 0, 0, 0 ) )
		draw.SimpleText( self:GetNWInt( "paint" ), "HotFont", 145, -130, 
			Cfg.PaintTextColor, 2, 1 )

		--[[-----------------------------------------
			Paper
		--]]-----------------------------------------
		draw.RoundedBox( 0, 57.5, 55, 90, 90, Cfg.BGPrColor )
		draw.RoundedBox( 0, 57.5, 55, 90, 
			self:GetNWInt( "paper" )*9, Color( 0, 0, 0 ) )
		draw.SimpleText( self:GetNWInt( "paper" ), "HotFont", 145, 130, 
			Cfg.PaperTextColor, 2, 1 )

		draw.NoTexture()
		--surface.SetDrawColor( 110,100,100,200 )
		--draw.Circle( 2.5, 0, 150, 32, 360 )
		surface.SetDrawColor( Cfg.SurcleBar[1][1],
			Cfg.SurcleBar[1][2],Cfg.SurcleBar[1][3] )
		draw.Circle( 2.5, 0, 140, 90, 360 )
		surface.SetDrawColor( Cfg.SurcleBar[2][1],
			Cfg.SurcleBar[2][2],Cfg.SurcleBar[2][3] )
		draw.Circle( 2.5, 0, 140, 120, self.Smooth )
		if not self:GetNWBool("power") then
		surface.SetDrawColor( Cfg.SurcleBar[3][1],
			Cfg.SurcleBar[3][2],Cfg.SurcleBar[3][3] )
		draw.Circle( 2.5, 0, 141, 50, 360 )
		end
		surface.SetDrawColor( Cfg.SurcleBar[4][1],
			Cfg.SurcleBar[4][2],Cfg.SurcleBar[4][3] )
		draw.Circle( 2.5, 0, 110, 90, 360 )

		--[[-----------------------------------------
			Money
		--]]-----------------------------------------
		draw.SimpleText( self:GetMoneyAmount().."$", "MoneyFont2", 2.5, 0, 
		Cfg.Money, 1, 1 )
		--[[-----------------------------------------
		Health
	    --]]-----------------------------------------
	    draw.RoundedBox( 0, -115, 154, 231, 6, Cfg.BGHealthBar )
		draw.RoundedBox( 0, -115, 154, self:GetNWInt( "Health" )*2.31, 6, Cfg.HealthBar )
		--[[-----------------------------------------
			Power
		--]]-----------------------------------------
		draw.RoundedBox( 0, 118, 148, 30, 12, Cfg.BGPower )
		if self:GetNWBool( "power" ) then
			draw.RoundedBox( 0, 118, 148, 15, 12, Cfg.PowerOn )
		else
			draw.RoundedBox( 0, 133, 148, 15, 12, Cfg.PowerOff )
		end
		--[[-----------------------------------------
			Extract
		--]]-----------------------------------------
		draw.RoundedBox( 0, -147, 148, 30, 12, Cfg.ButtonExtCooler )
	cam.End3D2D()
	
	Ang:RotateAroundAxis( Ang:Forward(), 90 )


	--[[-----------------------------------------
		Player Name
	--]]-----------------------------------------
	Ang:RotateAroundAxis( Ang:Forward(), -45 )
	cam.Start3D2D( Pos *1.0 + Ang:Up() * -4, Ang, 0.1 )
		local tr = util.GetPlayerTrace( _player, ang )
		local tr = util.TraceLine(tr)

		local t = {}
			t.start = _player:GetShootPos()
			t.endpos = _player:GetAimVector() * 128 + t.start
			t.filter = _player
		local Cord
		if self.Cords == nil then 
			self.Cords = 0
		end
		local tr = util.TraceLine(t)
		local pos = self.Entity:WorldToLocal( tr.HitPos )
		if tr.Entity == self then 
			self.Cord = 80
		else
			self.Cord = 0
		end

		self.Cords = Lerp(FrameTime()*10,self.Cords,self.Cord)
		draw.RoundedBox( 0, -147.5, -160-self.Cords, 300, 50, Cfg.BGPlayerName )
		draw.RoundedBox( 0, -142.5, -155-self.Cords, 290, 40, Cfg.FGPlayerName )
		draw.SimpleText( string.sub(owner,1,12), "MoneyFont", -2.5, -135-self.Cords, Cfg.ColorPlayerName, 1, 1 )
	cam.End3D2D()
end