local cv_KF2DamageMult = CreateConVar("sv_tfa_kf2_damage_multiplier", 1, FCVAR_ARCHIVE, "Multiply KF2 weapon damage by how much?")

hook.Add("TFA_GetStat", "TFA_KF2_Multiply_Damage_NonZS", function(weapon, stat, value)
	if not string.find(weapon:GetClass(), "tfa_kf2") then return end
	local multiplier = cv_KF2DamageMult:GetFloat()
	if stat == "Primary.Damage" then
		return value * multiplier
	end
	if stat == "Secondary.Damage" then
		return value * multiplier
	end
end)