include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

--[[
hook.Add("HUDPaint","DrawMoney",function()
	local eye = LocalPlayer():GetEyeTrace()

	if eye.Entity:GetClass() == "modules_money_printer" then

		draw.SimpleText( eye.Entity:GetMoneyAmount(), "MoneyFont", ScrW()/2, ScrH()/2, Color( 255, 0, 0 ), 1, 1 )

	end
end)
--]]