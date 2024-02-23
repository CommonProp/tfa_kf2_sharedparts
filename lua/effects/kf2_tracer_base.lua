function EFFECT:Init(data)
    self.Position = data:GetStart()
    self.WeaponEnt = data:GetEntity()
    self.Attachment = data:GetAttachment()

    if IsValid(self.WeaponEnt) then
        -- Check if the weapon is the specific akimbo weapon and has an AnimCycle
        if self.WeaponEnt.Akimbo and self.WeaponEnt.GetAnimCycle and self.WeaponEnt.Base == "tfa_kf2_akimbo_af2011_base" then
            local animCycle = self.WeaponEnt:GetAnimCycle()
            -- Determine the attachment based on AnimCycle
            if animCycle == 0 then
                self.Attachment = math.random(1, 2) -- Randomly choose between 1 and 2 for AnimCycle 0
            else
                self.Attachment = math.random(3, 4) -- Randomly choose between 3 and 4 for AnimCycle 1
            end
        elseif self.WeaponEnt.GetMuzzleAttachment then
            -- Use the weapon's method to get the attachment if not the specific akimbo weapon or no AnimCycle
            self.Attachment = self.WeaponEnt:GetMuzzleAttachment()
        end
    end

    self.StartPos = self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment)
    self.EndPos = data:GetOrigin()
    self:SetRenderBoundsWS(self.StartPos, self.EndPos, Vector(1000, 1000, 1000))
end

function EFFECT:Think()
end

function EFFECT:Render()
end