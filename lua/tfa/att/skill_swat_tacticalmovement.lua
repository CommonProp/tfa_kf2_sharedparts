if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Tactical Movement"
ATTACHMENT.ShortName = "TAC MOVE"
ATTACHMENT.Description = { TFA.Attachments.Colors["+"], "No movement penalty for using iron sights or crouch movement." }
ATTACHMENT.Icon = "entities/Skill_SWAT_TacticalMovement.png"

function ATTACHMENT:Attach(wep)
	if not wep.OldIronSightsMoveSpeed then
		wep.OldIronSightsMoveSpeed = wep.IronSightsMoveSpeed
	end

	-- Set the IronSightsMoveSpeed to the weapon's MoveSpeed
	wep.IronSightsMoveSpeed = wep.MoveSpeed
end

function ATTACHMENT:Detach(wep)
	-- Restore the original IronSightsMoveSpeed
	if wep.OldIronSightsMoveSpeed then
		wep.IronSightsMoveSpeed = wep.OldIronSightsMoveSpeed
		wep.OldIronSightsMoveSpeed = nil
	end
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end


if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end