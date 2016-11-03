ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Printer"
ENT.Author = "nedfreetoplay"
ENT.Category = "Improvable Money Printer"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "MoneyAmount" )
	self:NetworkVar("Entity", 0, "owning_ent")
end