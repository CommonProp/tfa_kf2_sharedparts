hook.Add( "PopulateToolMenu", "KF2SettingsMenu", function()
	spawnmenu.AddToolMenuOption( "Utilities", "TFA SWEP Base Settings", "TFA KF2", "TFA KF2", "", "", function( panel )
		panel:ClearControls()

		panel:NumSlider( "Damage Multiplier", "sv_tfa_kf2_damage_multiplier", 0, 5 )
		panel:ControlHelp( "Default is 1." )

		panel:CheckBox( "Enable magazine drop effect?", "cl_tfa_kf2_magdrop", 1, 0 )
		panel:ControlHelp( "Default is on." )

		panel:NumSlider( "Magazine Lifetime", "cl_tfa_kf2_maglife", 1, 120 )
		panel:ControlHelp( "Default is 15." )
	end )
end )