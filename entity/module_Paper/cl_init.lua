include("shared.lua")
surface.CreateFont( "MoneyFont", {
	font = "Arial", extended = false, size = 50, weight = 500, blursize = 0, scanlines = 0, antialias = true,} 
)
function ENT:Draw()
	self:DrawModel()

    local Ang = self:GetAngles()
    local Pos = self:GetPos()

    cam.Start3D2D(Pos + Ang:Up() * 9.5, Ang, 0.08)
        draw.RoundedBox(10,-80,-20,160,50,Color(0,0,0,180))
        draw.SimpleText( "Paper", "MoneyFont", 0,5, Color( 255,255,255 ), 1, 1 )
    cam.End3D2D()
end