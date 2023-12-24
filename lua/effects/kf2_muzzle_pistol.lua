AddCSLuaFile()
AddCSLuaFile( "effects/tfa_kf2_muzzlebase.lua" )
include( "effects/tfa_kf2_muzzlebase.lua" )

EFFECT.Life = 0.075 -- duration of dlight
EFFECT.FlashSize = 1 -- size of dlight
EFFECT.Color = Color(255, 128, 0) -- color of dlight

EFFECT.ParticleEffect = "kf2_muzzleflash_pistol" -- pcf particle system name

EFFECT.FollowMuzzle = true -- render at point of creation, or follow muzzle?