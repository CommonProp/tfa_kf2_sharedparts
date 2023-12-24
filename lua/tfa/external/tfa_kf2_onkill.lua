-- Purpose: Provides an easy way to detect when a weapon kills a player or npc.
-- This will pave the way for new abilities and weapon perks later.
-- ALL CREDIT, AND I MEAN *ALL CREDIT* GOES TO Darken217 / Hedron and their fantastic Sci-Fi weapons pack

-- entTarget is what was killed, and entAttacker is the killer

-- EXAMPLE USAGE:

-- function SWEP:OnKill_Jaiden( entTarget, entAttacker )
-- 	print(entTarget, entAttacker)
-- end

local tfaWeaponOnKill_Jaiden = function( entTarget, entAttacker, entInflictor )

	if ( entTarget:IsPlayer() ) then
		local GarryPleaseMakeYourFunctionsConsistent = entAttacker
		entAttacker = entInflictor
		entInflictor = GarryPleaseMakeYourFunctionsConsistent
		
		-- input vars are ordered differently for PlayerKilled and OnNPCKilled
	end

	if ( IsValid( entInflictor ) && entInflictor:IsWeapon() ) then
		if ( entInflictor.OnKill_Jaiden ) then
			entInflictor:OnKill_Jaiden( entTarget, entAttacker )
		end
	end
	
end

hook.Add( "OnNPCKilled", "tfa_WeaponKilledNPC_Jaiden", tfaWeaponOnKill_Jaiden )
hook.Add( "PlayerDeath", "tfa_WeaponKilledPlayer_Jaiden", tfaWeaponOnKill_Jaiden )