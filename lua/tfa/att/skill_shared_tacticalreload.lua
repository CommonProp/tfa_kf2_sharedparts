if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Tactical Reload"
ATTACHMENT.ShortName = "TAC REL" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = (engine.ActiveGamemode() == "zombiesurvival" and { TFA.Attachments.Colors["+"], "Increase reload speed.", TFA.Attachments.Colors["-"], "Costs 200 points." }) or { TFA.Attachments.Colors["+"], "Increase reload speed." }   --TFA.Attachments.Colors["+"], "Does something good", TFA.Attachments.Colors["-"], "Does something bad" }
ATTACHMENT.Icon = "entities/Skill_Shared_TacticalReload.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.PointCost = 200
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
	if engine.ActiveGamemode() == "zombiesurvival" then -- in zs
		if wep:GetOwner():GetPoints() < self.PointCost then return false end -- higher tier level equipped or can't afford, disregard
	else -- in sandbox
		return true
	end
end

function ATTACHMENT:Attach(wep)
    if not IsValid(wep) then return end
    wep.IsTacticalReloadEquipped = true
	if SERVER and engine.ActiveGamemode() == "zombiesurvival" then
		wep:GetOwner():TakePoints(self.PointCost) -- take points for attaching
	end
end

function ATTACHMENT:Detach(wep)
    if not IsValid(wep) then return end
    wep.IsTacticalReloadEquipped = false
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
