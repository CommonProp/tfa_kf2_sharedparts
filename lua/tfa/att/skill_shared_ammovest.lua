if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Ammo Vest"
ATTACHMENT.ShortName = "AMMO"
ATTACHMENT.Description = { TFA.Attachments.Colors["+"], "Carry up to 30% more ammo." }
ATTACHMENT.Icon = "entities/Skill_Shared_AmmoVest.png"

function ATTACHMENT:Attach(wep)
    if wep.Primary and wep.Primary.DefaultClip then
        -- Debug: Print the original DefaultClip
        print("Original DefaultClip:", wep.Primary.DefaultClip)

        if not wep._originalDefaultClip then
            wep._originalDefaultClip = wep.Primary.DefaultClip
        end

        -- Increase the DefaultClip by 30%
        wep.Primary.DefaultClip = math.floor(wep._originalDefaultClip * 1.30)

        -- Debug: Print the new DefaultClip
        print("New DefaultClip:", wep.Primary.DefaultClip)
    end
end

function ATTACHMENT:Detach(wep)
    if wep._originalDefaultClip then
        -- Restore the original DefaultClip
        wep.Primary.DefaultClip = wep._originalDefaultClip

        -- Debug: Print the restored DefaultClip
        print("Restored DefaultClip:", wep.Primary.DefaultClip)

        wep._originalDefaultClip = nil
    end
end

if not TFA_ATTACHMENT_ISUPDATING then
    TFAUpdateAttachments()
end
