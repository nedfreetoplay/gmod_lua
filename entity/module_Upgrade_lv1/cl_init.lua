include("shared.lua")

function ENT:Draw()
	local Cfg = ImpCfg
	self:DrawModel()
	self:SetMaterial( "models/shiny", false )
	self:SetColor( Cfg.UpgradeColor1 )
end