include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
    local Ang = self:GetAngles()
    local Cfg = ImpCfg
    cam.Start3D2D(Pos + Ang:Up() * 3.8, Ang, 0.08)
    	draw.RoundedBox(10,-60,-20,120,50,Cfg.BGModuleCooler)
        draw.SimpleText( "Cooler", "MoneyFont", 0,5, Cfg.TextModuleCooler, 1, 1 )
    cam.End3D2D()
end