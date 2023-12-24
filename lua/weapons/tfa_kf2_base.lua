SWEP.Base = "tfa_bash_base"
DEFINE_BASECLASS(SWEP.Base)

SWEP.MuzzleAttachment			= "muzzle" 		-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellAttachment			= "shell" 		-- Should be "2" for CSS models or "shell" for hl2 models

SWEP.IronRecoilMultiplier = 0.6 --Multiply recoil by this factor when we're in ironsights.  This is proportional, not inversely.
SWEP.CrouchAccuracyMultiplier = 0.8 --Less is more.  Accuracy * 0.5 = Twice as accurate, Accuracy * 0.1 = Ten times as accurate

SWEP.Primary.BurstDelay = 0.1 -- Delay between bursts, leave nil to autocalculate
SWEP.Primary.HullSize = 1 --Big bullets, increase this value.  They increase the hull size of the hitscan bullet.
SWEP.Primary.Knockback = 0 --Autodetected if nil; this is the velocity kickback

SWEP.TracerCount 		= 1 	--0 disables, otherwise, 1 in X chance
SWEP.TracerName 		= "kf2_tracer"

SWEP.BlowbackVector         = Vector(0, -50, 0)

SWEP.WalkBobMult_Iron = 0.75

SWEP.DisableChambering = true --Disable round-in-the-chamber

SWEP.IdleInspectDelay = 20 -- delay between random inspects
SWEP.Idle_Blend                 = 0 -- Start an idle this far early into the end of a transition
SWEP.Idle_Smooth                = 0 -- Start an idle this far early into the end of another animation

SWEP.MoveSpeed = 1 
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 0.4

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
SWEP.IronInSound = nil --Sound to play when ironsighting in?  nil for default
SWEP.IronOutSound = nil --Sound to play when ironsighting out?  nil for default
SWEP.PickupSound = Sound("TFA_KF2.Generic.PickupWeapon")

SWEP.LuaShellEject = true --Enable shell ejection through lua?
SWEP.LuaShellEjectDelay = 0.002 --The delay to actually eject things
SWEP.Primary.Sound_DryFire = Sound("TFA_KF2.AK12.DryFire")

SWEP.Primary.EchoFire = nil -- Echo firing sound. Unlike looped firing sounds, this sound will play EACH TIME the gun is fired.

SWEP.Secondary.BashSound = ""
--SWEP.LowAmmoSound = ""
--SWEP.LastAmmoSound = ""

SWEP.SprintAnimation = {
	["in"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, -- Sequence or act
		["value"] = "Sprint_in", -- Number for act, String/Number for sequence
		["value_empty"] = "Sprint_In_Empty",
		["transition"] = true
	}, -- Inward transition
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, -- Sequence or act
		["value"] = "Sprint_Loop", -- Number for act, String/Number for sequence
		["value_empty"] = "Sprint_Loop_Empty",
		["is_idle"] = true
	}, -- looping animation
	["out"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, -- Sequence or act
		["value"] = "Sprint_Out", -- Number for act, String/Number for sequence
		["value_empty"] = "Sprint_Out_empty",
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

function SWEP:ChooseIdleAnim(...)
    -- Check if the owner is valid and a player
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
        else
            return BaseClass.ChooseIdleAnim(self, ...)
        end
    else
        -- If the owner is not valid or not a player, default to base class behavior
        return BaseClass.ChooseIdleAnim(self, ...)
    end
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