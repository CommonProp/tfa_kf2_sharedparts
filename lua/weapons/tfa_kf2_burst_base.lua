SWEP.Base = "tfa_kf2_base"
DEFINE_BASECLASS(SWEP.Base)

function SWEP:PlayAnimation(data, fade, rate, targ)
    local self2 = self:GetTable()
    
    if not self:VMIV() then return end
    if not data then return false, -1 end
   
    local ttype, tval = self:ChooseAnimation(data)
    
    if ttype == TFA.Enum.ANIMATION_SEQ then
        local success, activityID = self:SendViewModelSeq(tval, rate or 1, targ, fade or (data.transition and self2.Idle_Blend or self2.Idle_Smooth))
        return success, activityID, TFA.Enum.ANIMATION_SEQ
    end

    local success, activityID = self:SendViewModelAnim(tval, rate or 1, targ, fade or (data.transition and self2.Idle_Blend or self2.Idle_Smooth))
    return success, activityID, TFA.Enum.ANIMATION_ACT
end


local function PlayChosenAnimation(self, typev, tanim, ...)
	local fnName = typev == TFA.Enum.ANIMATION_SEQ and "SendViewModelSeq" or "SendViewModelAnim"
	local a, b = self[fnName](self, tanim, ...)
	return a, b, typev
end

SWEP.PlayChosenAnimation = PlayChosenAnimation
local shouldAnim, shouldBlowback
function SWEP:ChooseShootAnim(ifp)
	local self2 = self:GetTable()
	if ifp == nil then ifp = IsFirstTimePredicted() end
	if not self:VMIV() then return end

	if self2.GetStatL(self, "ShootAnimation.loop") and self2.ShouldPlayLoopShootAnim(self) then
		if self2.LuaShellEject and ifp then
			self:EventShell()
		end

		if TFA.Enum.ShootReadyStatus[self:GetShootStatus()] then
			self:SetShootStatus(TFA.Enum.SHOOT_START)

			local inan = self2.GetStatL(self, "ShootAnimation.in")

			if not inan then
				inan = self2.GetStatL(self, "ShootAnimation.loop")
			end

			return self:PlayAnimation(inan)
		end

		return
	end
		
	local fm = self:GetFireMode()
	local fmn = string.lower(self:GetStatL("FireModes")[fm])
	
	if fmn == "3burst" then
 	   if self2.LuaShellEject and ifp then
 	       self:EventShell()
 	   end
	
 	   if self:GetBurstCount() == 1 then
 	       local animData
 	       local clip = self:Clip1()
	
 	       if clip >= 3 then
 	           animData = self2.GetStatL(self, "BurstShootAnimation.three")
 	       elseif clip == 2 then
 	           animData = self2.GetStatL(self, "BurstShootAnimation.two")
 	       elseif clip == 1 then
 	           animData = self2.GetStatL(self, "BurstShootAnimation.one")
 	       end
	
 	       if animData then
 	           self:PlayAnimation(animData)
 	           return
 	       end
    	end
    	return
	end

	local sightsMode = self2.GetStatL(self, "Sights_Mode")

	if self:GetIronSights() and (sightsMode == TFA.Enum.LOCOMOTION_ANI or sightsMode == TFA.Enum.LOCOMOTION_HYBRID) and self2.GetStatL(self, "IronAnimation.shoot") then
		if self2.LuaShellEject and ifp then
			self:EventShell()
		end

		return self:PlayAnimation(self2.GetStatL(self, "IronAnimation.shoot"))
	end

	shouldBlowback = self2.GetStatL(self, "BlowbackEnabled") and (not self2.GetStatL(self, "Blowback_Only_Iron") or self:GetIronSights())
	shouldAnim = not shouldBlowback or self2.GetStatL(self, "BlowbackAllowAnimation")

	if shouldBlowback then
		if sp and SERVER then
			self:CallOnClient("BlowbackFull", "")
		end

		if ifp then
			self:BlowbackFull(ifp)
		end

		if self2.GetStatL(self, "Blowback_Shell_Enabled") and (ifp or sp) then
			self:EventShell()
		end
	end

	if shouldAnim then
		success = true

		if self2.LuaShellEject and (ifp or sp) then
			self:EventShell()
		end

		if self:GetActivityEnabled(ACT_VM_PRIMARYATTACK_SILENCED) and self2.GetSilenced(self) then
			typev, tanim = self:ChooseAnimation("shoot1_silenced")
		elseif self:Clip1() <= self2.Primary_TFA.AmmoConsumption and self:GetActivityEnabled(ACT_VM_PRIMARYATTACK_EMPTY) and self2.Primary_TFA.ClipSize >= 1 and not self2.ForceEmptyFireOff then
			typev, tanim = self:ChooseAnimation("shoot1_last")
		elseif self:Ammo1() <= self2.Primary_TFA.AmmoConsumption and self:GetActivityEnabled(ACT_VM_PRIMARYATTACK_EMPTY) and self2.Primary_TFA.ClipSize < 1 and not self2.ForceEmptyFireOff then
			typev, tanim = self:ChooseAnimation("shoot1_last")
		elseif self:Clip1() == 0 and self:GetActivityEnabled(ACT_VM_DRYFIRE) and not self2.ForceDryFireOff then
			typev, tanim = self:ChooseAnimation("shoot1_empty")
		elseif self2.GetStatL(self, "IsAkimbo") and self:GetActivityEnabled(ACT_VM_SECONDARYATTACK) and ((self:GetAnimCycle() == 0 and not self2.Akimbo_Inverted) or (self:GetAnimCycle() == 1 and self2.Akimbo_Inverted)) then
			typev, tanim = self:ChooseAnimation((self:GetIronSights() and self:GetActivityEnabled(ACT_VM_ISHOOT_M203)) and "shoot2_is" or "shoot2")
		elseif self:GetIronSights() and self:GetActivityEnabled(ACT_VM_PRIMARYATTACK_1) then
			typev, tanim = self:ChooseAnimation("shoot1_is")
		else
			typev, tanim = self:ChooseAnimation("shoot1")
		end

		return PlayChosenAnimation(self, typev, tanim)
	end

	self:SendViewModelAnim(ACT_VM_BLOWBACK)

	return true, ACT_VM_IDLE
end

SWEP.BlowbackRandomAngle = Angle(0, 0, 0) -- not cached, overwritten with each shot

SWEP.BlowbackRandomAngleMin = Angle(.1, -.5, -1)
SWEP.BlowbackRandomAngleMax = Angle(.2, .5, 1)

local minang, maxang

function SWEP:BlowbackFull()
	local self2 = self:GetTable()

	if IsValid(self) then
		self2.BlowbackCurrent = 1
		self2.BlowbackCurrentRoot = 1

		if CLIENT then
			minang, maxang = self2.GetStatL(self, "BlowbackRandomAngleMin"), self2.GetStatL(self, "BlowbackRandomAngleMax")

			self2.BlowbackRandomAngle = Angle(math.Rand(minang.p, maxang.p), math.Rand(minang.y, maxang.y), math.Rand(minang.r, maxang.r))
		end
	end
end

function SWEP:EmitGunfireSound(soundscript)
    local fm = self:GetFireMode()
    local fmn = string.lower(self:GetStatL("FireModes")[fm])

    if fmn == "3burst" then
        if self:GetBurstCount() == 1 then
            local soundToPlay
            local clip = self:Clip1()

            if clip >= 3 then
                soundToPlay = "TFA_KF2.UMP.Fire3Burst"
            elseif clip == 2 then
                soundToPlay = "TFA_KF2.UMP.Fire2Burst"
            elseif clip == 1 then
                soundToPlay = "TFA_KF2.UMP.Fire"
            end

            if soundToPlay then
                self:EmitSoundNet(soundToPlay)
            end
        end
    else
        BaseClass.EmitGunfireSound(self, soundscript)
    end
end