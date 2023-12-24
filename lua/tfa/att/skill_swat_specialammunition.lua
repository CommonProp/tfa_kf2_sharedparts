if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Suppression Rounds"
ATTACHMENT.ShortName = "SUPPRESS"
ATTACHMENT.Description = { TFA.Attachments.Colors["+"], "Increase stumble power 100%." }
ATTACHMENT.Icon = "entities/Skill_SWAT_SpecialAmmunition.png"

function ATTACHMENT:Attach(wep)
	if not wep.OldPrimaryForce then -- Check if the original force hasn't been stored yet
		wep.OldPrimaryForce = wep.Primary.Force -- Store the original force
	end

	wep.Primary.Force = wep.Primary.Force * 2 -- Double the force
	
	print(wep.Primary.Force)
end

function ATTACHMENT:Detach(wep)
	if wep.OldPrimaryForce then -- Check if the original force has been stored
		wep.Primary.Force = wep.OldPrimaryForce -- Restore the original force
		wep.OldPrimaryForce = nil -- Clear the stored value
	end
	
	print(wep.Primary.Force)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
