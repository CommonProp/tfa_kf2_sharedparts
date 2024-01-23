SWEP.Base = "tfa_kf2_base"
DEFINE_BASECLASS(SWEP.Base)

-- Function for determining AnimCycle based on clip count
local function determineAnimCycle(clip)
    -- Calculate the step in the firing sequence (each step consists of two bullets)
    local step = math.ceil((32 - clip) / 2) + 1
    
    -- Alternate between right and left, starting with right
    if step % 2 == 1 then
        return 0  -- Right side shot (for odd steps)
    else
        return 1  -- Left side shot (for even steps)
    end
end

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

    local IsAltAkimboSightEquipped = self.IsAltAkimboSightEquipped

    -- Akimbo weapon logic
    if self2.GetStatL(self, "IsAkimbo") then
        if self2.LuaShellEject and ifp then
            self:EventShell()
        end
        local animKey = ""
        local clip = self:Clip1()

        -- Determine the side (left or right) and iron sights status
        if self:GetAnimCycle() == 1 then
            if IsAltAkimboSightEquipped and self:GetIronSights() then
                animKey = "left_isog"
            else
                animKey = self:GetIronSights() and "left_is" or "left"
            end
        else
            if IsAltAkimboSightEquipped and self:GetIronSights() then
                animKey = "right_isog"
            else
                animKey = self:GetIronSights() and "right_is" or "right"
            end
        end

        local animData = self2.GetStatL(self, "AkimboShootAnimation." .. animKey)

        -- Validate animData
        if animData then
            local typev, tanim
            typev = animData.type

            -- Use empty animation for right hand when 2 or 1 bullets left, left hand when 1 or 0 bullets left
            if (self:GetAnimCycle() == 1 and clip <= 2) or (self:GetAnimCycle() == 0 and clip <= 4) then
                tanim = animData.value_empty
            else
                tanim = animData.value
            end

            return PlayChosenAnimation(self, typev, tanim)
        end
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
		elseif self:Clip1() <= self2.Primary_TFA.AmmoConsumption and self:GetActivityEnabled(ACT_VM_PRIMARYATTACK_EMPTY) and self2.Primary_TFA.ClipSize >= 2 and not self2.ForceEmptyFireOff then
			typev, tanim = self:ChooseAnimation("shoot1_last")
		elseif self:Ammo1() <= self2.Primary_TFA.AmmoConsumption and self:GetActivityEnabled(ACT_VM_PRIMARYATTACK_EMPTY) and self2.Primary_TFA.ClipSize < 2 and not self2.ForceEmptyFireOff then
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

function SWEP:ChooseReloadAnim()
    -- Get the current ammo count in the clip
    local clip = self:Clip1()
    -- Calculate the total ammo after a theoretical reload
    local totalAmmoAfterReload = math.min(clip + self:Ammo1(), self.Primary.ClipSize)

    -- Ensure totalAmmoAfterReload is even, add 1 if it's odd
    if totalAmmoAfterReload % 2 == 1 then
        totalAmmoAfterReload = totalAmmoAfterReload + 1
    end

    local typev, tanim  -- Variables to store the type and name of the animation
    local fac = 1

    -- Check if the tactical reload attachment is equipped
    local isTacticalReloadEquipped = self.IsTacticalReloadEquipped

    -- Determine the appropriate animation based on clip count and whether the tactical reload is equipped
    local animKey = (clip == 0 and "empty") or (clip <= 2 and "empty_half") or "half"
    local animData = self.ReloadAnimation[animKey]

    -- Check if the animation data exists and set the type and animation name
    if animData then
        typev = animData.type
        tanim = isTacticalReloadEquipped and animData.value_elite or animData.value
    else
        -- Fallback in case no animation data is found
        return false, 0
    end

    -- Use determineAnimCycle to decide the AnimCycle based on adjusted totalAmmoAfterReload
    local animCycle = determineAnimCycle(totalAmmoAfterReload)
    
    if animCycle ~= nil then
        self:SetAnimCycle(animCycle)
        self.AnimCycle = self:GetAnimCycle()
    end

    -- Play the chosen animation
    return self:PlayChosenAnimation(typev, tanim, fac, fac ~= 1)
end

function SWEP:ChooseInspectAnim()
	local self2 = self:GetTable()
	if not self:VMIV() then return end

	if self:GetActivityEnabled(ACT_VM_FIDGET_SILENCED) and self2.GetSilenced(self) then
		typev, tanim = self:ChooseAnimation("inspect_silenced")
	elseif self:GetActivityEnabled(ACT_VM_FIDGET_EMPTY) and self:Clip1() <= 2 then 
		typev, tanim = self:ChooseAnimation("inspect_empty")
	elseif self2.InspectionActions then
		tanim = self2.InspectionActions[self:SharedRandom(1, #self2.InspectionActions, "Inspect")]
	elseif self:GetActivityEnabled(ACT_VM_FIDGET) then
		typev, tanim = self:ChooseAnimation("inspect")
	else
		typev, tanim = self:ChooseAnimation("idle")
		success = false
	end

	return PlayChosenAnimation(self, typev, tanim)
end

function SWEP:Think2(...)
    if IsValid(self.OwnerViewModel) then
        local vm = self.OwnerViewModel
        local clip = self:Clip1()  -- Current ammo in the magazine

        -- Check if the clip is an odd number
        if clip % 2 == 1 then
            -- Set the ammo count to an even number by subtracting 1
            local newClip = clip + 1
            self:SetClip1(newClip)  -- Update the clip with the new even number
            print("[Debug] Adjusted clip from " .. clip .. " to " .. newClip)  -- Debug message
        end

        -- Update PM_EmptyRight and PM_EmptyLeft based on ammo count
        local pmEmptyRightValue = (clip <= 2) and 2 or 0
        local pmEmptyLeftValue = (clip == 0) and 2 or 0

        if vm:GetPoseParameter("PM_EmptyRight") then
            vm:SetPoseParameter("PM_EmptyRight", pmEmptyRightValue)
        end

        if vm:GetPoseParameter("PM_EmptyLeft") then
            vm:SetPoseParameter("PM_EmptyLeft", pmEmptyLeftValue)
        end
    end

    return BaseClass.Think2(self, ...)
end

function SWEP:ToggleAkimbo(arg1)
--nothing
end

function SWEP:Deploy()
    local clip = self:Clip1()  -- Current ammo in the magazine
    local animCycle = determineAnimCycle(clip)

    -- Update AnimCycle based on the calculated value
    if animCycle ~= nil then
        self:SetAnimCycle(animCycle)
        self.AnimCycle = self:GetAnimCycle()
    end

    return BaseClass.Deploy(self)  -- Call to base class at the end
end

function SWEP:PostPrimaryAttack(...)
    local clip = self:Clip1()  -- Current ammo in the magazine

    -- Delay the AnimCycle update to ensure proper shell ejection
    timer.Simple(.1, function()
        if IsValid(self) then  -- Check if the weapon is still valid
            local animCycle = determineAnimCycle(clip)
            if animCycle ~= nil then
                self:SetAnimCycle(animCycle)
            end
        end
    end)

    return BaseClass.PostPrimaryAttack(self, ...)
end	

local hudenabled_cvar = GetConVar("cl_tfa_hud_enabled")

local draw = draw
local cam = cam
local surface = surface
local render = render
local Vector = Vector
local Matrix = Matrix
local TFA = TFA
local math = math

local function ColorAlpha(color_in, new_alpha)
	if color_in.a == new_alpha then return color_in end
	return Color(color_in.r, color_in.g, color_in.b, new_alpha)
end

local targ, lactive = 0, -1
local targbool = false
local hudhangtime_cvar = GetConVar("cl_tfa_hud_hangtime")
local hudfade_cvar = GetConVar("cl_tfa_hud_ammodata_fadein")
local lfm, fm = 0, 0

function SWEP:DrawHUDAmmo()
	local self2 = self:GetTable()
	local stat = self2.GetStatus(self)

	local clipSize = self2.GetStatL(self, "Primary.ClipSize")  -- Get the clip size
	local totalAmmo = self:Clip1()  -- Total ammo in the clip

	-- Dynamically create the ammo pattern
	local basePattern = {}
	local halfClipSize = math.floor(clipSize / 2)
	for i = halfClipSize, 0, -2 do
	    table.insert(basePattern, i)
	    table.insert(basePattern, i)
	end

	-- Calculate the number of shots that have been fired
	local shotsFired = math.floor((clipSize - totalAmmo) / 2)  -- Divide by 2 because each shot fires two bullets

	-- Calculate the positions in the base pattern for right and left ammo
	local patternPosRight = (shotsFired % #basePattern) + 2 
	local patternPosLeft = (shotsFired % #basePattern) + 1

	-- Get the right-side and left-side ammo from the pattern
	local ammoRight = basePattern[patternPosRight]
	local ammoLeft = basePattern[patternPosLeft]

	-- Ensure ammoRight and ammoLeft don't go below 0
	ammoRight = math.max(0, ammoRight)
	ammoLeft = math.max(0, ammoLeft)

	if self2.GetStatL(self, "BoltAction") then
		if stat == TFA.Enum.STATUS_SHOOTING then
			if not self2.LastBoltShoot then
				self2.LastBoltShoot = l_CT()
			end
		elseif self2.LastBoltShoot then
			self2.LastBoltShoot = nil
		end
	end

	if not hudenabled_cvar:GetBool() or hook.Run("HUDShouldDraw", "TFA_HUDAmmo") == false then
		self:DrawFallbackHUD()
		return
	end

	fm = self:GetFireMode()
	targbool = (not TFA.Enum.HUDDisabledStatus[stat]) or fm ~= lfm
	targbool = targbool or (stat == TFA.Enum.STATUS_SHOOTING and self2.LastBoltShoot and l_CT() > self2.LastBoltShoot + self2.GetStatL(self, "BoltTimerOffset"))
	targbool = targbool or (self2.GetStatL(self, "PumpAction") and (stat == TFA.Enum.STATUS_PUMP or (stat == TFA.Enum.STATUS_SHOOTING and self:Clip1() == 0)))
	targbool = targbool or (stat == TFA.Enum.STATUS_FIDGET)

	targ = targbool and 1 or 0
	lfm = fm

	if targ == 1 then
		lactive = RealTime()
	elseif RealTime() < lactive + hudhangtime_cvar:GetFloat() then
		targ = 1
	elseif self:GetOwner():KeyDown(IN_RELOAD) then
		targ = 1
	end

	self2.CLAmmoProgress = math.Approach(self2.CLAmmoProgress, targ, (targ - self2.CLAmmoProgress) * RealFrameTime() * 2 / hudfade_cvar:GetFloat())

	local myalpha = 225 * self2.CLAmmoProgress
	if myalpha < 1 then return end
	local amn = self2.GetStatL(self, "Primary.Ammo")
	if not amn then return end
	if amn == "none" or amn == "" then return end
	local mzpos = self:GetMuzzlePos()

	if self2.GetStatL(self, "IsAkimbo") then
		self2.MuzzleAttachmentRaw = self2.MuzzleAttachmentRaw2 or 1
	end

	if self2.GetHidden(self) then return end

	local xx, yy

	if mzpos and mzpos.Pos then
		local pos = mzpos.Pos
		local textsize = self2.textsize and self2.textsize or 1
		local pl = IsValid(self:GetOwner()) and self:GetOwner() or LocalPlayer()
		local ang = pl:EyeAngles() --(angpos.Ang):Up():Angle()
		ang:RotateAroundAxis(ang:Right(), 90)
		ang:RotateAroundAxis(ang:Up(), -90)
		ang:RotateAroundAxis(ang:Forward(), 0)
		pos = pos + ang:Right() * (self2.textupoffset and self2.textupoffset or -2 * (textsize / 1))
		pos = pos + ang:Up() * (self2.textfwdoffset and self2.textfwdoffset or 0 * (textsize / 1))
		pos = pos + ang:Forward() * (self2.textrightoffset and self2.textrightoffset or -1 * (textsize / 1))
		cam.Start3D()
		local postoscreen = pos:ToScreen()
		cam.End3D()
		xx = postoscreen.x
		yy = postoscreen.y
	else -- fallback to pseudo-3d if no muzzle
		xx, yy = ScrW() * .65, ScrH() * .6
	end

	local v, newx, newy, newalpha = hook.Run("TFA_DrawHUDAmmo", self, xx, yy, myalpha)
	if v ~= nil then
		if v then
			xx = newx or xx
			yy = newy or yy
			myalpha = newalpha or myalpha
		else
			return
		end
	end

	if self:GetInspectingProgress() < 0.01 and self2.GetStatL(self, "Primary.Ammo") ~= "" and self2.GetStatL(self, "Primary.Ammo") ~= 0 then
		local str, clipstr

		if self2.GetStatL(self, "Primary.ClipSize") and self2.GetStatL(self, "Primary.ClipSize") ~= -1 then
			clipstr = language.GetPhrase("tfa.hud.ammo.clip1")

			if self2.GetStatL(self, "IsAkimbo") and self2.GetStatL(self, "EnableAkimboHUD") ~= false then
				str = clipstr:format(ammoRight)

				if (self:Clip1() > self2.GetStatL(self, "Primary.ClipSize")) then
					str = clipstr:format(math.floor(self:Clip1() / 2) - 1 .. " + " .. (math.floor(self:Clip1() / 2) - math.floor(self2.GetStatL(self, "Primary.ClipSize") / 2)))
				end
			else
				str = clipstr:format(self:Clip1())

				if (self:Clip1() > self2.GetStatL(self, "Primary.ClipSize")) then
					str = clipstr:format(self2.GetStatL(self, "Primary.ClipSize") .. " + " .. (self:Clip1() - self2.GetStatL(self, "Primary.ClipSize")))
				end
			end

			draw.DrawText(str, "TFASleek", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
			draw.DrawText(str, "TFASleek", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
			str = language.GetPhrase("tfa.hud.ammo.reserve1"):format(self2.Ammo1(self))
			yy = yy + TFA.Fonts.SleekHeight
			xx = xx - TFA.Fonts.SleekHeight / 3
			draw.DrawText(str, "TFASleekMedium", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
			draw.DrawText(str, "TFASleekMedium", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
			yy = yy + TFA.Fonts.SleekHeightMedium
			xx = xx - TFA.Fonts.SleekHeightMedium / 3
		else
			str = language.GetPhrase("tfa.hud.ammo1"):format(self2.Ammo1(self))
			draw.DrawText(str, "TFASleek", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
			draw.DrawText(str, "TFASleek", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
			yy = yy + TFA.Fonts.SleekHeightMedium
			xx = xx - TFA.Fonts.SleekHeightMedium / 3
		end

		str = string.upper(self:GetFireModeName() .. (#self2.GetStatL(self, "FireModes") > 2 and " | +" or ""))

		if self:IsJammed() then
			str = str .. "\n" .. language.GetPhrase("tfa.hud.jammed")
		end

		draw.DrawText(str, "TFASleekSmall", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
		draw.DrawText(str, "TFASleekSmall", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
		yy = yy + TFA.Fonts.SleekHeightSmall
		xx = xx - TFA.Fonts.SleekHeightSmall / 3

		if self2.GetStatL(self, "IsAkimbo") and self2.GetStatL(self, "EnableAkimboHUD") ~= false then
			local angpos2 = self:GetOwner():ShouldDrawLocalPlayer() and self:GetAttachment(2) or self2.OwnerViewModel:GetAttachment(2)

			if angpos2 then
				local pos2 = angpos2.Pos
				local ts2 = pos2:ToScreen()

				xx, yy = ts2.x, ts2.y
			else
				xx, yy = ScrW() * .35, ScrH() * .6
			end

			if self2.GetStatL(self, "Primary.ClipSize") and self2.GetStatL(self, "Primary.ClipSize") ~= -1 then
				clipstr = language.GetPhrase("tfa.hud.ammo.clip1")

				str = clipstr:format(ammoLeft)

				if (math.floor(self:Clip1() / 2) > math.floor(self2.GetStatL(self, "Primary.ClipSize") / 2)) then
					str = clipstr:format(math.floor(self:Clip1() / 2) - 1 .. " + " .. (math.floor(self:Clip1() / 2) - math.floor(self2.GetStatL(self, "Primary.ClipSize") / 2)))
				end

				draw.DrawText(str, "TFASleek", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleek", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
				str = language.GetPhrase("tfa.hud.ammo.reserve1"):format(self2.Ammo1(self))
				yy = yy + TFA.Fonts.SleekHeight
				xx = xx - TFA.Fonts.SleekHeight / 3
				draw.DrawText(str, "TFASleekMedium", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleekMedium", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
				yy = yy + TFA.Fonts.SleekHeightMedium
				xx = xx - TFA.Fonts.SleekHeightMedium / 3
			else
				str = language.GetPhrase("tfa.hud.ammo1"):format(self2.Ammo1(self))
				draw.DrawText(str, "TFASleek", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleek", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
				yy = yy + TFA.Fonts.SleekHeightMedium
				xx = xx - TFA.Fonts.SleekHeightMedium / 3
			end

			str = string.upper(self:GetFireModeName() .. (#self2.FireModes > 2 and " | +" or ""))
			draw.DrawText(str, "TFASleekSmall", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
			draw.DrawText(str, "TFASleekSmall", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
		end

		if self2.GetStatL(self, "Secondary.Ammo") and self2.GetStatL(self, "Secondary.Ammo") ~= "" and self2.GetStatL(self, "Secondary.Ammo") ~= "none" and self2.GetStatL(self, "Secondary.Ammo") ~= 0 and not self2.GetStatL(self, "IsAkimbo") then
			if self2.GetStatL(self, "Secondary.ClipSize") and self2.GetStatL(self, "Secondary.ClipSize") ~= -1 then
				clipstr = language.GetPhrase("tfa.hud.ammo.clip2")
				str = (self:Clip2() > self2.GetStatL(self, "Secondary.ClipSize")) and clipstr:format(self2.GetStatL(self, "Secondary.ClipSize") .. " + " .. (self:Clip2() - self2.GetStatL(self, "Primary.ClipSize"))) or clipstr:format(self:Clip2())
				draw.DrawText(str, "TFASleekSmall", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleekSmall", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
				str = language.GetPhrase("tfa.hud.ammo.reserve2"):format(self2.Ammo2(self))
				yy = yy + TFA.Fonts.SleekHeightSmall
				xx = xx - TFA.Fonts.SleekHeightSmall / 3
				draw.DrawText(str, "TFASleekSmall", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleekSmall", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
			else
				str = language.GetPhrase("tfa.hud.ammo2"):format(self2.Ammo2(self))
				draw.DrawText(str, "TFASleekSmall", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleekSmall", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
			end
		end
	end
end 

--shell shenanigans

SWEP.ShellEffectOverride = nil -- ???
SWEP.ShellEjectionQueue = 0

function SWEP:GetShellEjectPosition(ent, isVM, attid)
    -- Use the provided attid if it's given, otherwise get it from GetShellAttachmentID
    attid = attid or self:GetShellAttachmentID(ent, isVM)

    local angpos = ent:GetAttachment(attid)
    if angpos then
        return angpos.Pos, angpos.Ang, attid
    end
end

function SWEP:MakeShell(eject_now)
    if not self:IsValid() then return end
    if self.current_event_iftp == false then return end

    local retVal = hook.Run("TFA_MakeShell", self)
    if retVal ~= nil then
        return retVal
    end

    local shelltype
    if self:GetStatL("ShellEffectOverride") then
        shelltype = self:GetStatL("ShellEffectOverride")
    elseif TFA.GetLegacyShellsEnabled() then
        shelltype = "tfa_shell_legacy"
    else
        shelltype = "tfa_shell"
    end

    local ent = self:IsFirstPerson() and (self.OwnerViewModel or self) or self
    local isVM = ent == self.OwnerViewModel

    if not eject_now and CLIENT and self:IsFirstPerson() then
        self.ShellEjectionQueue = self.ShellEjectionQueue + 1
        return
    end

    self:EjectionSmoke(true)

    if not isstring(shelltype) or shelltype == "" then return end

    -- Create the first shell using attachment 2
    local pos, ang, attid = self:GetShellEjectPosition(ent, isVM, 2)
    if pos and IsValid(ent) then
        local fx = EffectData()
        fx:SetEntity(self)
        fx:SetAttachment(attid)
        fx:SetMagnitude(1)
        fx:SetScale(1)
        fx:SetOrigin(pos)
        fx:SetNormal(ang:Forward())
        TFA.Effects.Create(shelltype, fx)
    end

    -- Create the second shell using attachment 3
    local pos2, ang2, attid2 = self:GetShellEjectPosition(ent, isVM, 3)
    if pos2 and IsValid(ent) then
        local fx2 = EffectData()
        fx2:SetEntity(self)
        fx2:SetAttachment(attid2)
        fx2:SetMagnitude(1)
        fx2:SetScale(1)
        fx2:SetOrigin(pos2)
        fx2:SetNormal(ang2:Forward())
        TFA.Effects.Create(shelltype, fx2)
    end
end