include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	self:SetMaterial("models/shiny", false)
	self:SetColor( Color( 218, 218, 218, 255 ) )
end