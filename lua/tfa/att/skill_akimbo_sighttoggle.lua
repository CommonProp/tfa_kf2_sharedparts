if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Alt. Aiming Style"
ATTACHMENT.ShortName = "ALT AIM" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = { TFA.Attachments.Colors["+"], "Switches aiming style when in Ironsights." }  --TFA.Attachments.Colors["+"], "Does something good", TFA.Attachments.Colors["-"], "Does something bad" }
ATTACHMENT.Icon = "entities/Skill_Akimbo_SightToggle.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.WeaponTable = {	
    ["IronAnimation"] = {
		["in"] = {
			["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
			["value"] = ACT_DOD_SECONDARYATTACK_PRONE_RIFLE
	    },
		["loop"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "Idle_IronOG",
			["value_empty"] = "Idle_IronOG"
		},
		["out"] = {
			["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
			["value"] = ACT_DOD_SECONDARYATTACK_RIFLE
	    },
	},
} --put replacements for your SWEP table in here e.g. ["Primary"] = {}

function ATTACHMENT:CanAttach(wep)
	return true --can be overridden per-attachment
end

function ATTACHMENT:Attach(wep)
    if not IsValid(wep) then return end
    wep.IsAltAkimboSightEquipped = true
end

function ATTACHMENT:Detach(wep)
    if not IsValid(wep) then return end
    wep.IsAltAkimboSightEquipped = false
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
