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
local TurnPBC

function ENT:Draw()
	local _player = LocalPlayer()
	self:DrawModel()
	if LocalPlayer():EyePos( ):Distance(self.Entity:GetPos()) > 1000 then return end
	--Upgrade System
	local Upgrades = self:GetNWInt("Upgrade")
	if Upgrades == 1 then self:SetColor( Color( 218, 218, 218, 255 ) ) self:SetMaterial("models/shiny", false)
	elseif Upgrades == 2 then self:SetColor( Color( 255, 242, 0, 255 ) )
	elseif Upgrades == 3 then self:SetColor( Color( 255, 0, 0, 255 ) )
	elseif Upgrades == 4 then self:SetColor( Color( 29, 223, 0, 255 ) )
	elseif Upgrades == 5 then self:SetColor( Color( 0, 242, 242, 255 ) )
	end
	local FillBur = math.floor(self:GetNWInt("interval")*math.abs(self:GetNWFloat("ProgressBar")-1))
	local HotBur = nil
	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:Getowning_ent()
    owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	if self:GetNWBool("Cooler") == true then
		HotBur = Color(7,247,247)
	else 
		HotBur = Color(200,200,200)
	end
	--ON/OFF
	if self:GetNWBool("turn") then TurnPBC = Color( 255,255,255 )
	else TurnPBC = Color( 160,160,160 )
	end


	--[[ print(FillBur) --]]
	--Hot Color(7,247,247)
	--[[Куда смотрит игрок--]]
	local t = {}
	t.start = _player:GetShootPos()
	t.endpos = _player:GetAimVector() * 128 + t.start
	t.filter = _player
	local tr = util.TraceLine(t)
	local pos = self.Entity:WorldToLocal(tr.HitPos)

	Ang:RotateAroundAxis( self:GetAngles():Up(), 90 )

	--cooler = ClientsideModel ("models/props_phx/gears/bevel12.mdl", RENDERGROUP_OPAQUE )
	

	cam.Start3D2D(Pos *1.0 + Ang:Up() * 11.1, Ang, 0.1)
		--TestHitPos
		if (tr.Entity == self) and pos.x > 6.5 and pos.x < 14 and pos.y > 11 and pos.y < 14.5 then
			test = true
		else
			test = false
		end


		--draw.RoundedBox(0,-16*10,-16*10,33*10,31*10,Color(193,181,116,160))
		draw.RoundedBox(10,-14*10,-15*10,29*10,6*10,Color(0,0,0,120))
		draw.RoundedBox(10,-14*10,-8*10,29*10,6*10,Color(0,0,0,120))
		draw.RoundedBox(10,-14*10,-1*10,29*10,6*10,Color(0,0,0,120))
		--[[ Stats --]]
		draw.RoundedBox(10,-14*10,6*10,9*10,4*10,Color(0,0,0,120))
		draw.RoundedBox(10,-14*10,10.5*10,9*10,4*10,Color(0,0,0,120))
		--draw.RoundedBox(10,-40,6*10,19*10,8.5*10,Color(0,0,0,120))
		draw.RoundedBox(0,-13.5*10,6.5*10,8*10,3*10,Color(200,200,200))
		if self:GetNWInt("Hot") >= 80 then
			draw.RoundedBox(0,-13.5*10,6.5*10,80,3*10,Color(180,0,0,HotColor)) --HotDanger
			else
			draw.RoundedBox(0,-13.5*10,6.5*10,80,3*10,HotBur) --Hot
		end
		draw.RoundedBox(0,-13.5*10,11*10,8*10,3*10,Color(200,200,200)) --Upgrade
		draw.RoundedBox(0,-13.5*10,11*10,self:GetNWInt("Upgrade")*16,3*10,Color(255,120,0)) --Upgrade

		--Paper,Color
		draw.RoundedBox(10,-4*10,6*10,13.5*10,4*10,Color(0,0,0,120))
		draw.RoundedBox(10,-4*10,10.5*10,13.5*10,4*10,Color(0,0,0,120))

		draw.RoundedBox(0,-3.5*10,6.5*10,12.5*10,3*10,Color(200,200,200))
		draw.RoundedBox(0,-3.5*10,11*10,12.5*10,3*10,Color(200,200,200))

		draw.RoundedBox(0,-3.5*10,6.5*10,self:GetNWInt("paint")*6.25,3*10,Color(0,0,0))
		draw.RoundedBox(0,-3.5*10,11*10,self:GetNWInt("paper")*12.5,3*10,Color(255,255,255))

		--On/OFF
		draw.RoundedBox(10,10.5*10,6*10,4.5*10,8.5*10,Color(0,0,0,120))
		draw.RoundedBox(10,11*10,6.5*10,3.5*10,7.5*10,Color(200,200,200))
		if self:GetNWBool("turn") then draw.RoundedBox(10,11*10,6.5*10,3.5*10,3.75*10,Color(0,0,200))
		else draw.RoundedBox(10,11*10,10.25*10,3.5*10,3.75*10,Color(200,0,0)) end
		--[[ ProgressBar --]]
		--draw.RoundedBox(0,-13*10,-7*10,27*10,2*10,Color(255,120,120))
		--draw.RoundedBox(0,-13*10,-7*10, FillBur, 2*10,Color(0,200,0))
		draw.SimpleText( FillBur.." сек.", "MoneyFont2", 0, -50, TurnPBC, 1, 1 )

		draw.SimpleText( self:GetNWInt("Upgrade").."/5", "HotFont", -95, 125, Color( 255,255,255 ), 1, 1 )
		draw.SimpleText( self:GetNWInt("Hot").."°", "HotFont", -95, 80, Color( 255,255,255 ), 1, 1 )
		draw.SimpleText( owner, "MoneyFont", 0, -120, Color( 255, 120, 0 ), 1, 1 )
		draw.SimpleText( self:GetMoneyAmount().."$", "MoneyFont2", 0, 20, Color( 0, 200, 0 ), 1, 1 )
	cam.End3D2D()
	--And
	
	Ang:RotateAroundAxis( Ang:Forward(), 90 )

	cam.Start3D2D(Pos *1.0 + Ang:Up() * 17, Ang, 0.1)
		draw.RoundedBox(10,-14*10,-10*10,29*10,6*10,Color(0,0,0,120))
		draw.RoundedBox(0,-13.5*10,-9.5*10,28*10,5*10,Color(200,200,200))
		draw.RoundedBox(0,-13.5*10,-9.5*10,self:GetNWInt("Health")*2.8,5*10,Color(255,100,100))
	cam.End3D2D()
	--cooler:Remove()
end
--GM:VGUIMousePressed( Panel pnl, number mouseCode )
--[[hook.Add("VGUIMousePressed","VGUItriggerclick",function()

end)


hook.Add("HUDPaint","DrawMoney",function()
	local eye = LocalPlayer():GetEyeTrace()

	if eye.Entity:GetClass() == "modules_money_printer" and test then

		draw.SimpleText( owner, "MoneyFont", ScrW()/2, ScrH()/2, Color( 255, 0, 0 ), 1, 1 )

	end
end)--]]