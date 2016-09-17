include("shared.lua")
surface.CreateFont( "MoneyFont", {
	font = "Arial", extended = false, size = 50, weight = 500, blursize = 0, scanlines = 0, antialias = true,} 
)
function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
    local Ang = self:GetAngles()

    Ang:RotateAroundAxis( Ang:Right(), 90 )
    Ang:RotateAroundAxis( Ang:Forward(), 90 )

    cam.Start3D2D(Pos + Ang:Up() * 11.5, Ang, 0.1)
        draw.RoundedBox(10,-60,-20,120,50,Color(0,0,0,180))
        draw.SimpleText( "Paint", "MoneyFont", 0,5, Color( 255,255,255 ), 1, 1 )
    cam.End3D2D()
end