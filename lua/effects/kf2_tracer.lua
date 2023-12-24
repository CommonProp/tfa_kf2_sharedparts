AddCSLuaFile()
AddCSLuaFile( "effects/kf2_tracer_base.lua" )
include( "effects/kf2_tracer_base.lua" )

function EFFECT:Think()
	
	util.ParticleTracerEx( 
		"kf2_tracer", 	--particle system
		self.StartPos, 	--startpos
		self.EndPos, 	--endpos
		true, 			--do whiz effect
		-1, 			--entity index
		-1  			--attachment
	)
	
	return false

end