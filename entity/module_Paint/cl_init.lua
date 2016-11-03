include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
    local Ang = self:GetAngles()
    local Cfg = ImpCfg
    Ang:RotateAroundAxis( Ang:Right(), 90 )
    Ang:RotateAroundAxis( Ang:Forward(), 180 )

    cam.Start3D2D(Pos + Ang:Up() * 5, Ang, 0.08)
        draw.RoundedBox(10,-60,-20,120,50,Cfg.BGModulePaint)
        draw.SimpleText( "Paint", "MoneyFont", 0,5, Cfg.TextModulePaint, 1, 1 )
    cam.End3D2D()
end