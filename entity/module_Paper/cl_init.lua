include("shared.lua")

function ENT:Draw()
	self:DrawModel()

    local Ang = self:GetAngles()
    local Pos = self:GetPos()
    local Cfg = ImpCfg
    cam.Start3D2D(Pos + Ang:Up() * 9.5, Ang, 0.08)
        draw.RoundedBox(10,-80,-20,160,50,Cfg.BGModulePaper)
        draw.SimpleText( "Paper", "MoneyFont", 0,5, Cfg.TextModulePaper, 1, 1 )
    cam.End3D2D()
end