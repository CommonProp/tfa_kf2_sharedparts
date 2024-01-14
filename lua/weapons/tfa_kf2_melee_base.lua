SWEP.Base = "tfa_melee_base"

SWEP.Primary.MaxCombo = 4 --Max amount of times you'll attack by simply holding down the mouse; -1 to unlimit
SWEP.Secondary.MaxCombo = 1 --Max amount of times you'll attack by simply holding down the mouse; -1 to unlimit

SWEP.IdleInspectDelay = 20 -- delay between random inspects
SWEP.Idle_Blend                 = 0 -- Start an idle this far early into the end of a transition
SWEP.Idle_Smooth                = 0 -- Start an idle this far early into the end of another animation

SWEP.MoveSpeed = 1 

SWEP.Offset = {
	Pos = {
		Up = 1,
		Right = 1.5,
		Forward = -2
	},
	Ang = { 
		Up = -2,
		Right = -10,
		Forward = 180
	},
	Scale = 1
} --Procedural world model animation, defaulted for CS:S purposes.

SWEP.Sights_Mode = TFA.Enum.LOCOMOTION_HYBRID -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation
SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.Walk_Mode = TFA.Enum.LOCOMOTION_HYBRID
SWEP.Idle_Mode = TFA.Enum.IDLE_BOTH --TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA

SWEP.UseHands = true --Use gmod c_arms system.
SWEP.VMPos_Additive = false --Set to false for an easier time using VMPos. If true, VMPos will act as a constant delta ON TOP OF ironsights, run, whateverelse

SWEP.HolsterSound = Sound("TFA_KF2.Generic.ClothMedium")
SWEP.PickupSound = Sound("TFA_KF2.Generic.PickupWeapon")

SWEP.LuaShellEject = true --Enable shell ejection through lua?
SWEP.LuaShellEjectDelay = 0.002 --The delay to actually eject things
SWEP.ShellScale = 1
SWEP.Primary.Sound_DryFire = Sound("TFA_KF2.AK12.DryFire")

SWEP.Primary.EchoFire = nil -- Echo firing sound. Unlike looped firing sounds, this sound will play EACH TIME the gun is fired.

SWEP.Secondary.BashSound = ""
--SWEP.LowAmmoSound = ""
--SWEP.LastAmmoSound = ""

SWEP.SprintAnimation = {
	["in"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, -- Sequence or act
		["value"] = "Sprint_in", -- Number for act, String/Number for sequence
		["transition"] = true
	}, -- Inward transition
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, -- Sequence or act
		["value"] = "Sprint_Loop", -- Number for act, String/Number for sequence
		["is_idle"] = true
	}, -- looping animation
	["out"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, -- Sequence or act
		["value"] = "Sprint_Out", -- Number for act, String/Number for sequence
		["transition"] = true
	} -- Outward transition
}

SWEP.IronAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, -- Sequence or act
		["value"] = "Idle_Iron", -- Number for act, String/Number for sequence
		["value_empty"] = "Idle_Iron_Empty",
	}, -- Looping Animation
}

SWEP.Animations = {
	 ["bash"] = {
	 	["type"] = TFA.Enum.ANIMATION_ACT,
	 	["value"] = ACT_VM_HITCENTER
	 },
	 ["bash_empty"] = {
	 	["type"] = TFA.Enum.ANIMATION_ACT,
	 	["value"] = ACT_VM_MISSCENTER
	 },
}

SWEP.WalkAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, -- Sequence or act
		["value"] = "Walk", -- Number for act, String/Number for sequence
		["value_empty"] = "Walk_Empty",
		["is_idle"] = true
	} -- looping animation
}

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Initialize(...)
	self:SetNWFloat("LastIdleInspect", CurTime() + self.IdleInspectDelay)

	return BaseClass.Initialize(self, ...)
end

function SWEP:SetupDataTables(...)
	self:SetNWFloat("LastIdleInspect", CurTime() + self.IdleInspectDelay)

	return BaseClass.SetupDataTables(self, ...)
end

function SWEP:Deploy(...)
	self:SetNWFloat("LastIdleInspect", CurTime() + self.IdleInspectDelay)

	return BaseClass.Deploy(self, ...)
end

function SWEP:PostPrimaryAttack(...)
	self:SetNWFloat("LastIdleInspect", CurTime() + self.IdleInspectDelay)

	if self.Primary.EchoFire then
		self:EmitSoundNet(self.Primary.EchoFire)
	end

	return BaseClass.PostPrimaryAttack(self, ...)
end

function SWEP:PostReload(...)
	self:SetNWFloat("LastIdleInspect", CurTime() + self.IdleInspectDelay)

	return BaseClass.PostReload(self, ...)
end

function SWEP:CheckAmmo(...)
	self:SetNWFloat("LastIdleInspect", CurTime() + self.IdleInspectDelay)

	return BaseClass.CheckAmmo(self, ...)
end

local cv_dropmags = GetConVar("cl_tfa_kf2_magdrop") or CreateClientConVar("cl_tfa_kf2_magdrop", "1", true, true, "Drop magazine on weapon reload?")

function SWEP:KF2DropMag(handValue)  -- CALL ONLY IN PREDICTED HOOKS/FUNCTIONS LIKE EVENTTABLES!
    if not IsFirstTimePredicted() or not cv_dropmags:GetBool() then return end  

    local efdata = EffectData()

    efdata:SetEntity(self)
    efdata:SetOrigin(self:GetPos())
    efdata:SetAngles(self:GetAngles())
    efdata:SetScale(handValue)
            
    util.Effect("tfa_kf2_dropped_mag", efdata)
end

function SWEP:PreDrawViewModel(...)
	render.UpdateScreenEffectTexture()

	return BaseClass.PreDrawViewModel(self, ...)
end

local function Clamp(a, b, c)
	if a < b then return b end
	if a > c then return c end
	return a
end

local function GetClampedCVarFloat(cvar)
	return Clamp(cvar:GetFloat(), cvar:GetMin(), cvar:GetMax())
end

local rft, eyeAngles, viewPunch, oldEyeAngles, delta, motion, counterMotion, compensation, fac, positionCompensation, swayRate, wiggleFactor, flipFactor

local gunswaycvar = GetConVar("cl_tfa_gunbob_intensity")
local gunswayinvertcvar = GetConVar("cl_tfa_gunbob_invertsway")
local sv_tfa_weapon_weight = GetConVar("sv_tfa_weapon_weight")

function SWEP:Sway(pos, ang, ftv)
    local self2 = self:GetTable()
    if not self:OwnerIsValid() then return pos, ang end

    local gunswayIntensity = GetClampedCVarFloat(gunswaycvar)
    local ironSightsProgress = self2.IronSightsProgressUnpredicted or self:GetIronSightsProgress() or 0
    local fac = gunswayIntensity * 3 * ((1 - ironSightsProgress) * 0.85 + 0.15)
    local flipFactor = self2.ViewModelFlip and -1 or 1
    
    if gunswayinvertcvar:GetBool() then fac = -fac end

    delta = delta or Angle()
    motion = motion or Angle()
    counterMotion = counterMotion or Angle()
    compensation = compensation or Angle()

    if ftv then
        local eyeAngles = self:GetOwner():EyeAngles() - self:GetOwner():GetViewPunchAngles()
        oldEyeAngles = oldEyeAngles or eyeAngles
        local wiggleFactor = (1 - (sv_tfa_weapon_weight:GetBool() and self2.GetStatL(self, "RegularMoveSpeedMultiplier") or 1)) / 0.6 + 0.15
        local swayRate = math.pow(sv_tfa_weapon_weight:GetBool() and self2.GetStatL(self, "RegularMoveSpeedMultiplier") or 1, 1.5) * 10
        local rft = math.Clamp(ftv, 0.001, 1 / 20)
        
        local clampFac = 1.1 - math.min((math.abs(motion.p) + math.abs(motion.y) + math.abs(motion.r)) / 20, 1)
        delta.p = math.AngleDifference(eyeAngles.p, oldEyeAngles.p) / rft / 120 * clampFac
        delta.y = math.AngleDifference(eyeAngles.y, oldEyeAngles.y) / rft / 120 * clampFac
        delta.r = math.AngleDifference(eyeAngles.r, oldEyeAngles.r) / rft / 120 * clampFac
        oldEyeAngles = eyeAngles
        
        counterMotion = LerpAngle(rft * swayRate * (0.75 + math.max(0, 0.5 - wiggleFactor)), counterMotion, -motion)
        compensation.p = math.AngleDifference(motion.p, -counterMotion.p)
        compensation.y = math.AngleDifference(motion.y, -counterMotion.y)
        motion = LerpAngle(rft * swayRate, motion, delta + compensation)
    end

    local positionCompensation = 0.2 + 0.2 * ironSightsProgress
    local swayScale = 1 - ironSightsProgress - 0.1
    
    local modifiedPos = Vector(0, 0, 0)
    modifiedPos:Add(-motion.y * positionCompensation * 0.66 * fac * swayScale * ang:Right() * flipFactor)
    modifiedPos:Add(-motion.p * positionCompensation * fac * swayScale * ang:Up())
    
    ang:RotateAroundAxis(ang:Right(), motion.p * fac * swayScale)
    ang:RotateAroundAxis(ang:Up(), -motion.y * 0.66 * fac * swayScale * flipFactor)
    ang:RotateAroundAxis(ang:Forward(), counterMotion.r * 0.5 * fac * swayScale)
    
    return pos, ang
end

function SWEP:Holster(...)
	if not TFA.Enum.HolsterStatus[self:GetStatus()] then
		local holstersnd = self:GetStat("HolsterSound")

		if holstersnd and holstersnd ~= "" then
			self:EmitSound(holstersnd)
		end
	end

	return BaseClass.Holster(self, ...)
end

if SERVER then
	function SWEP:OwnerChanged(...)
		if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
			local pickupsnd = self:GetStat("PickupSound")

			if pickupsnd and pickupsnd ~= "" then
				self:EmitSound(pickupsnd)
			end
		end

		return BaseClass.OwnerChanged(self, ...)
	end

	function SWEP:EquipAmmo(ply, ...)
		local pickupsnd = self:GetStat("PickupSound")

		if pickupsnd and pickupsnd ~= "" then
			self:EmitSound(pickupsnd)
		end

		return BaseClass.EquipAmmo(self, ply, ...)
	end
end

-- you know the drill

function SWEP:Think2(...)
	if not self:VMIV() then return end

	if (not self:GetOwner():KeyDown(IN_ATTACK)) and (not self:GetOwner():KeyDown(IN_ATTACK2)) then
		self:SetComboCount(0)
	end

	if self:GetVP() and CurTime() > self:GetVPTime() then
		self:SetVP(false)
		self:SetVPTime(-1)
		self:GetOwner():ViewPunch(Angle(self:GetVPPitch(), self:GetVPYaw(), self:GetVPRoll()))
	end

	if self.CanBlock then
		local stat = self:GetStatus()

		if self:GetBashImpulse() and TFA.Enum.ReadyStatus[stat] and not self:GetOwner():KeyDown(IN_USE) then
			self:SetStatus(TFA.Enum.STATUS_BLOCKING, math.huge)

			if self.BlockAnimation["in"] then
				self:PlayAnimation(self.BlockAnimation["in"])
			elseif self.BlockAnimation["loop"] then
				self:PlayAnimation(self.BlockAnimation["loop"])
			end

			self.BlockStart = CurTime()
		elseif stat == TFA.Enum.STATUS_BLOCKING and not self:GetBashImpulse() then
			local _, tanim, ttype

			if self.BlockAnimation["out"] then
				_, tanim, ttype = self:PlayAnimation(self.BlockAnimation["out"])
			else
				_, tanim, ttype = self:ChooseIdleAnim()
			end

			self:ScheduleStatus(TFA.Enum.STATUS_IDLE, self.BlockFadeOut or (self:GetActivityLength(tanim, false, ttype) - self.BlockFadeOutEnd))
		elseif stat == TFA.Enum.STATUS_BLOCKING and CurTime() > self:GetNextIdleAnim() then
			self:ChooseIdleAnim()
		end
	end

	self:StrikeThink()
	BaseClass.Think2(self, ...)
end

local function PlayChosenAnimation(self, typev, tanim, ...)
	local fnName = typev == TFA.Enum.ANIMATION_SEQ and "SendViewModelSeq" or "SendViewModelAnim"
	local a, b = self[fnName](self, tanim, ...)
	return a, b, typev
end

SWEP.PlayChosenAnimation = PlayChosenAnimation

function SWEP:ChooseIdleAnim()
	local self2 = self:GetTable()
	if not self2.VMIV(self) then return false, 0 end
	--if self2.Idle_WithHeld then
	--  self2.Idle_WithHeld = nil
	--  return
	--end
	
    -- Define a list of animations to check
    local animationsToCheck = {"reload", "shoot", "bash", "equip", "put", "atk", "settle", "combo", "block"}

    -- Check if the current activity is in the defined list
    if IsValid(self) and IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
        local viewModel = self:GetOwner():GetViewModel()
        if IsValid(viewModel) then
            local sequenceIndex = viewModel:GetSequence()
            local sequenceName = string.lower(viewModel:GetSequenceName(sequenceIndex))

            -- Check for animations in the list
            for _, anim in ipairs(animationsToCheck) do
                if string.find(sequenceName, anim) then
                    -- Check if the animation is finished
                    local sequenceTime = viewModel:GetCycle()

                    if sequenceTime < 1.0 then
                        return -- Exit the function if the animation is still playing
                    end
                    -- Animation has finished, proceed to play idle animation next
                    break
                end
            end
        end
    end

    if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
        if self:GetIronSightsProgress() >= 0.01 then
            self:SetNWFloat("LastIdleInspect", CurTime() + self.IdleInspectDelay)
        end
        
        if self:GetNWFloat("LastIdleInspect", 0) <= CurTime() and not self:GetSprinting() then
            if self:GetActivityEnabled(ACT_VM_FIDGET) and self:GetStatus() == TFA.Enum.STATUS_IDLE then
                local _, tanim, ttype = self:ChooseInspectAnim()
                self:ScheduleStatus(TFA.Enum.STATUS_FIDGET, self:GetActivityLength(tanim, false, ttype))
            end

            self:SetNWFloat("LastIdleInspect", CurTime() + self.IdleInspectDelay)
			return
		end
    end

	if TFA.Enum.ShootLoopingStatus[self:GetShootStatus()] and self:ShouldPlayLoopShootAnim() then
		return self:ChooseLoopShootAnim()
	end

	local idleMode = self2.GetStatL(self, "Idle_Mode")

	if idleMode ~= TFA.Enum.IDLE_BOTH and idleMode ~= TFA.Enum.IDLE_ANI then return end

	--self:ResetEvents()
	if self:GetIronSights() then
		local sightsMode = self2.GetStatL(self, "Sights_Mode")

		if sightsMode == TFA.Enum.LOCOMOTION_LUA then
			return self:ChooseFlatAnim()
		else
			return self:ChooseADSAnim()
		end
	elseif self.CanBlock and self:GetStatus() == TFA.Enum.STATUS_BLOCKING and self.BlockAnimation["loop"] then
     	return self:PlayAnimation(self.BlockAnimation["loop"]) 
	elseif self:GetSprinting() and self2.GetStatL(self, "Sprint_Mode") ~= TFA.Enum.LOCOMOTION_LUA then
		return self:ChooseSprintAnim()
	elseif self:GetWalking() and self2.GetStatL(self, "Walk_Mode") ~= TFA.Enum.LOCOMOTION_LUA then
		return self:ChooseWalkAnim()
	elseif self:GetCustomizing() and self2.GetStatL(self, "Customize_Mode") ~= TFA.Enum.LOCOMOTION_LUA then
		return self:ChooseCustomizeAnim()
	end
	

	if self:GetActivityEnabled(ACT_VM_IDLE_SILENCED) and self2.GetSilenced(self) then
		typev, tanim = self:ChooseAnimation("idle_silenced")
	elseif self:IsEmpty1() then
		--self:GetActivityEnabled( ACT_VM_IDLE_EMPTY ) and (self:Clip1() == 0) then
		if self:GetActivityEnabled(ACT_VM_IDLE_EMPTY) then
			typev, tanim = self:ChooseAnimation("idle_empty")
		else --if not self:GetActivityEnabled( ACT_VM_PRIMARYATTACK_EMPTY ) then
			typev, tanim = self:ChooseAnimation("idle")
		end
	else
		typev, tanim = self:ChooseAnimation("idle")
	end

	--else
	--  return
	--end
	return PlayChosenAnimation(self, typev, tanim)
end

-- choose attack anim

local lvec = Vector(0, 0, 0)

function SWEP:ChooseAttack(tblName)
    local attacks = self:GetStatL(tblName .. ".Attacks")
    if not attacks or #attacks <= 0 then 
        print("ChooseAttack: No attacks found in " .. tblName)
        return -1 
    end

    local ply = self:GetOwner()
    if IsValid(ply) and ply:IsPlayer() then
        lvec.x, lvec.y = 0, 0

        if ply:KeyDown(IN_MOVERIGHT) then
            lvec.y = lvec.y - 1
        end

        if ply:KeyDown(IN_MOVELEFT) then
            lvec.y = lvec.y + 1
        end

        if ply:KeyDown(IN_FORWARD) then
            lvec.x = lvec.x + 1
        end

        if ply:KeyDown(IN_BACK) then
            lvec.x = lvec.x - 1
        end
    end

    local comboCount = self:GetComboCount() + 1

    -- If the player is stationary and it's the first attack of the combo
    if comboCount == 1 and lvec.x == 0 and lvec.y == 0 then
        if self.lastStationaryCombo == "L" then
            self.initialComboDirection = "R"
            self.lastStationaryCombo = "R"
        else
            self.initialComboDirection = "L"
            self.lastStationaryCombo = "L"
        end
    elseif comboCount == 1 then
        -- Determine the initial movement direction for non-stationary attacks
        if lvec.y > 0.3 then
            self.initialComboDirection = "L"
        elseif lvec.y < -0.3 then
            self.initialComboDirection = "R"
        elseif lvec.x > 0.5 then
            self.initialComboDirection = "F"
        elseif lvec.x < -0.1 then
            self.initialComboDirection = "B"
        else
            self.initialComboDirection = self.lastStationaryCombo -- Use the last stationary combo as a fallback
        end
    end

    -- Define the patterns
    local patterns = {
        R = {"L", "CR", "CFR", "CFL"},
        L = {"R", "CL", "CFL", "CFR"},
        F = {"F", "CFR", "CFL", "CFR"},
        B = {"B", "CBL", "CBR", "CBL"}
    }

    -- Select the pattern based on the initial movement
    local chosenPattern = patterns[self.initialComboDirection]

    -- Ensure comboCount cycles through the pattern
    local index = comboCount % #chosenPattern
    index = index == 0 and #chosenPattern or index
    local attackDirection = chosenPattern[index]

    print("ChooseAttack: Combo Count = " .. comboCount)
    print("ChooseAttack: Initial Combo Direction = " .. self.initialComboDirection)
    print("ChooseAttack: Target Attack = " .. attackDirection)

    local foundAttack = nil

    -- Find the attack matching the target pattern
    for k, v in pairs(attacks) do
        if v.direction == attackDirection then
            print("ChooseAttack: Found matching attack: " .. k)
            foundAttack = k
            break
        end
    end

    if not foundAttack then 
        print("ChooseAttack: No matching attacks found for target: " .. attackDirection)
        return 0 
    end

    print("ChooseAttack: Selected Attack = " .. foundAttack)
    return foundAttack, attacks[foundAttack]
end