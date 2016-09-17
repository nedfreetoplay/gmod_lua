include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	self:SetMaterial("models/shiny", false)
	self:SetColor( Color( 255, 242, 0, 255 ) )
end