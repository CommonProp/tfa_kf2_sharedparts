function EFFECT:Init( data )
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()

	if IsValid(self.WeaponEnt) and self.WeaponEnt.GetMuzzleAttachment then
		self.Attachment = self.WeaponEnt:GetMuzzleAttachment()
	end

	self.StartPos = self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment)
	self.EndPos = data:GetOrigin()
	self:SetRenderBoundsWS(self.StartPos, self.EndPos, Vector(1000,1000,1000))
end

function EFFECT:Think()
end

function EFFECT:Render()
end