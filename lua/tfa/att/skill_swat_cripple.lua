if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Cripple"
ATTACHMENT.ShortName = "CRIPPLE" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = { TFA.Attachments.Colors["+"], "Multiple hits will slow down enemies down up to 30%. Hitting the legs is most effective." }  --TFA.Attachments.Colors["+"], "Does something good", TFA.Attachments.Colors["-"], "Does something bad" }
ATTACHMENT.Icon = "entities/Skill_SWAT_Cripple.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.WeaponTable = {	
    ["Animations"] = {
		["reload"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "Reload_Half_Elite"
		},
		["reload_empty"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "Reload_Empty_Elite"
	},
	},
} --put replacements for your SWEP table in here e.g. ["Primary"] = {}

function ATTACHMENT:CanAttach(wep)
	return true --can be overridden per-attachment
end

function ATTACHMENT:Attach(wep)
end

function ATTACHMENT:Detach(wep)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
