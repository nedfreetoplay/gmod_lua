include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	self:SetMaterial("models/shiny", false)
	self:SetColor( Color( 0, 242, 242, 255 ) )
end