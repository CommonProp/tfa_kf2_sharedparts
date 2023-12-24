
-- Copyright (c) 2018-2020 TFA Base Devs

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local blankvec = Vector(0, 0, 0)

local vector_origin = Vector()

-- EDITABLE PARAMS --
EFFECT.Life = 0.075 -- duration of dlight
EFFECT.FlashSize = 0.8 -- size of dlight
EFFECT.Color = Color(255, 225, 128) -- color of dlight

EFFECT.ParticleEffect = "" -- pcf particle system name

function EFFECT:Init(data)
    self.Position = blankvec
    self.WeaponEnt = data:GetEntity()
    self.WeaponEntOG = self.WeaponEnt
    self.Attachment = data:GetAttachment()
    self.Dir = data:GetNormal()
    local owent

    if IsValid(self.WeaponEnt) then
        owent = self.WeaponEnt:GetOwner()
    end

    if not IsValid(owent) then
        owent = self.WeaponEnt:GetParent()
    end

    if IsValid(owent) and owent:IsPlayer() then
        if owent ~= LocalPlayer() or owent:ShouldDrawLocalPlayer() then
            self.WeaponEnt = owent:GetActiveWeapon()
            if not IsValid(self.WeaponEnt) then return end
        else
            local theirweapon = self.WeaponEnt
            self.WeaponEnt = self.WeaponEnt.OwnerViewModel

            if IsValid(theirweapon) and theirweapon.ViewModelFlip or theirweapon.ViewModelFlipped then
                self.Flipped = true
            end

            if not IsValid(self.WeaponEnt) then return end
        end
    end

    if IsValid(self.WeaponEntOG) and self.WeaponEntOG.MuzzleAttachment then
        self.Attachment = self.WeaponEnt:LookupAttachment(self.WeaponEntOG.MuzzleAttachment)

        if not self.Attachment or self.Attachment <= 0 then
            self.Attachment = 1
        end

        if self.WeaponEntOG:GetStatL("IsAkimbo") then
            self.Attachment = 2 - self.WeaponEntOG:GetAnimCycle()
        end
    end

    local angpos = self.WeaponEnt:GetAttachment(self.Attachment)

    if not angpos or not angpos.Pos then
        angpos = {
            Pos = vector_origin,
            Ang = angle_zero
        }
    end

    if self.Flipped then
        local tmpang = (self.Dir or angpos.Ang:Forward()):Angle()
        local localang = self.WeaponEnt:WorldToLocalAngles(tmpang)
        localang.y = localang.y + 180
        localang = self.WeaponEnt:LocalToWorldAngles(localang)
        --localang:RotateAroundAxis(localang:Up(),180)
        --tmpang:RotateAroundAxis(tmpang:Up(),180)
        self.Dir = localang:Forward()
    end

    -- Keep the start and end Pos - we're going to interpolate between them
    self.Position = self:GetTracerShootPos(angpos.Pos, self.WeaponEnt, self.Attachment)
    self.Norm = self.Dir
    self.vOffset = self.Position
    local dir = self.Norm
    local dlight

    if IsValid(self.WeaponEnt) then
        dlight = DynamicLight(self.WeaponEnt:EntIndex())
    else
        dlight = DynamicLight(0)
    end

    local fadeouttime = 0.2

    if (dlight) then
        dlight.Pos = self.Position + dir * 1 - dir:Angle():Right() * 5
        dlight.r = self.Color.r
        dlight.g = self.Color.g
        dlight.b = self.Color.b
        dlight.brightness = 4.5
        dlight.decay = 200 / self.Life
        dlight.size = self.FlashSize * 96
        dlight.dietime = CurTime() + self.Life
    end

    if self.FollowMuzzle then
        ParticleEffectAttach(self.ParticleEffect, PATTACH_POINT_FOLLOW, self.WeaponEnt, data:GetAttachment())
    else
        ParticleEffectAttach(self.ParticleEffect, PATTACH_POINT, self.WeaponEnt, data:GetAttachment())
    end
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end