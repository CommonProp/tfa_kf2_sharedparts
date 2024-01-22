local path, pref

local basepath = "tfa_kf2_soundbank/"
local basepref = "TFA_KF2."

do -- Generic Shared
	path1 = basepath .. "WEP_Shared/" 
	path2 = basepath .. "WEP_SA_1858/"
	path3 = basepath .. "UI_PlayerCharacter/"
	path4 = basepath .. "Skin_Impacts/"
	pref = basepref .. "Generic"
	
	TFA.AddSound(pref .. ".RifleRattle", CHAN_AUTO, 0.6, 75, 100, {
		path1 .. "PC_MVT_Rifle_Rattle_01.ogg",
		path1 .. "PC_MVT_Rifle_Rattle_02.ogg",
		path1 .. "PC_MVT_Rifle_Rattle_03.ogg",
		path1 .. "PC_MVT_Rifle_Rattle_04.ogg",
		path1 .. "PC_MVT_Rifle_Rattle_05.ogg"
	}, ")")
	
	TFA.AddSound(pref .. ".ClothMedium", CHAN_AUTO, 0.6, 75, 100, {
		path2 .. "PC_Movement_Cloth_Medium_05.ogg",
		path2 .. "PC_Movement_Cloth_Medium_06.ogg",
		path2 .. "PC_Movement_Cloth_Medium_08.ogg"
	}, ")")
	
	TFA.AddSound(pref .. ".ClothDefault", CHAN_AUTO, 0.6, 75, 100, {
		path2 .. "PC_Move_Cloth_Default_01.ogg",
		path2 .. "PC_Move_Cloth_Default_02.ogg",
		path2 .. "PC_Move_Cloth_Default_05.ogg",
		path2 .. "PC_Move_Cloth_Default_06.ogg",
		path2 .. "PC_Move_Cloth_Default_07.ogg",
		path2 .. "PC_Move_Cloth_Default_08.ogg"
	}, ")")
	
	TFA.AddSound(pref .. ".ClothMix", CHAN_AUTO, 0.6, 75, 100, {
		path2 .. "PC_Movement_Cloth_Medium_05.ogg",
		path2 .. "PC_Movement_Cloth_Medium_06.ogg",
		path2 .. "PC_Movement_Cloth_Medium_08.ogg",
		path2 .. "PC_Move_Cloth_Default_01.ogg",
		path2 .. "PC_Move_Cloth_Default_02.ogg",
		path2 .. "PC_Move_Cloth_Default_05.ogg",
		path2 .. "PC_Move_Cloth_Default_06.ogg",
		path2 .. "PC_Move_Cloth_Default_07.ogg",
		path2 .. "PC_Move_Cloth_Default_08.ogg"
	}, ")")
	
	TFA.AddSound(pref .. ".Bash", CHAN_AUTO, 0.6, 75, 100, {
		path3 .. "PC_Weapon_Bash_01.ogg",
		path3 .. "PC_Weapon_Bash_02.ogg",
		path3 .. "PC_Weapon_Bash_03.ogg",
		path3 .. "PC_Weapon_Bash_04.ogg",
		path3 .. "PC_Weapon_Bash_05.ogg",
		path3 .. "PC_Weapon_Bash_06.ogg"
	}, ")")
	
	TFA.AddSound(pref .. ".ImpactBallisticMetal", CHAN_AUTO, 0.6, 75, 100, {
		path4 .. "IMP_Ballistic_Metal_14.ogg",
		path4 .. "IMP_Ballistic_Metal_13.ogg",
		path4 .. "IMP_Ballistic_Metal_12.ogg",
		path4 .. "IMP_Ballistic_Metal_11.ogg",
		path4 .. "IMP_Ballistic_Metal_10.ogg",
		path4 .. "IMP_Ballistic_Metal_9.ogg",
		path4 .. "IMP_Ballistic_Metal_8.ogg",
		path4 .. "IMP_Ballistic_Metal_7.ogg",
		path4 .. "IMP_Ballistic_Metal_6.ogg",
		path4 .. "IMP_Ballistic_Metal_5.ogg",
		path4 .. "IMP_Ballistic_Metal_4.ogg",
		path4 .. "IMP_Ballistic_Metal_3.ogg",
		path4 .. "IMP_Ballistic_Metal_2.ogg",
		path4 .. "IMP_Ballistic_Metal_1.ogg"
	}, ")")
	
	TFA.AddSound(pref .. ".ImpactShieldHit", CHAN_AUTO, 0.6, 75, 100, {
		path4 .. "IMP_Shield_Hit_01.ogg",
		path4 .. "IMP_Shield_Hit_02.ogg",
		path4 .. "IMP_Shield_Hit_03.ogg",
		path4 .. "IMP_Shield_Hit_04.ogg",
		path4 .. "IMP_Shield_Hit_05.ogg",
		path4 .. "IMP_Shield_Hit_06.ogg"
	}, ")")
	
	TFA.AddSound(pref .. ".PickupWeapon", CHAN_AUTO, 0.6, 75, 100, path3 .. "UI_Pickup_Weapon.ogg")
	TFA.AddSound(pref .. ".ModeSwitch", CHAN_AUTO, 0.6, 75, 100, path3 .. "WEP_ModeSwitch.ogg")
	TFA.AddSound(pref .. ".FlashlightOn", CHAN_AUTO, 0.6, 75, 100, path3 .. "WEP_Flashlight_TurnOn.ogg")
	TFA.AddSound(pref .. ".FlashlightOff", CHAN_AUTO, 0.6, 75, 100, path3 .. "WEP_Flashlight_TurnOff.ogg")
end 

do -- Thompson 
	path = basepath .. "WEP_Thompson/"
	path1 = basepath .. "WEP_Distant/"
	pref = basepref .. "Thompson"

	TFA.AddFireSound(pref .. ".Fire", {
		path .. "WEP_Thompson_Single_Fire_01_Mix.ogg",
		path .. "WEP_Thompson_Single_Fire_02_Mix.ogg",
		path .. "WEP_Thompson_Single_Fire_04_Mix.ogg"
	}, true, "^"  ) 

	TFA.AddFireSound(pref .. ".FireLoop", path .. "WEP_Thompson_Loop_07_Mix.wav", true, "^"  ) 
	TFA.AddFireSound(pref .. ".FireLoopEnd", path .. "WEP_Thompson_EndLoop_04_Mix.ogg", true, "^"  ) 
	
	TFA.AddFireSound(pref .. ".EchoFire", {
		path1 .. "WEP_Thompson_Echo_Outdoor_LoopEnd_01.ogg",
--		path1 .. "WEP_Thompson_Echo_Outdoor_LoopEnd_02.ogg", annoying start
		path1 .. "WEP_Thompson_Echo_Outdoor_LoopEnd_03.ogg", 
		path1 .. "WEP_Thompson_Echo_Outdoor_LoopEnd_04.ogg", 
		path1 .. "WEP_Thompson_Echo_Outdoor_LoopEnd_05.ogg", 
		path1 .. "WEP_Thompson_Echo_Outdoor_LoopEnd_06.ogg", 
		path1 .. "WEP_Thompson_Echo_Outdoor_LoopEnd_07.ogg", 
		path1 .. "WEP_Thompson_Echo_Outdoor_LoopEnd_08.ogg"
	}, true, "^"  )	
	
	TFA.AddSound(pref .. ".Bolt", CHAN_AUTO, 0.6, 75, 100, {
		path .. "WEP_Thompson_Bolt_1.ogg",
		path .. "WEP_Thompson_Bolt_2.ogg"
	}, ")")
	
	TFA.AddSound(pref .. ".DrumInLong", CHAN_AUTO, 0.6, 75, 100, {
		path .. "WEP_Thompson_Drum_In_Long_1.ogg",
		path .. "WEP_Thompson_Drum_In_Long_2.ogg"
	}, ")")
	
	TFA.AddSound(pref .. ".DrumInShort", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_Thompson_Drum_In_Short.ogg")
	
	TFA.AddSound(pref .. ".DrumOut", CHAN_AUTO, 0.6, 75, 100, {
		path .. "WEP_Thompson_Drum_Out_1.ogg",
		path .. "WEP_Thompson_Drum_Out_2.ogg"
	}, ")")

	TFA.AddSound(pref .. ".Dryfire", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_Thompson_Foley_DryFire_01.ogg")
end 

do -- MP5 
	path = basepath .. "WEP_MP5/"
	pref = basepref .. "MP5RAS"

	TFA.AddFireSound(pref .. ".Fire", {
		path .. "MP5_Single_2_Mix.ogg",
		path .. "MP5_Single_3_Mix.ogg",
		path .. "MP5_Single_4_Mix.ogg"
	}, true, "^"  ) 

	TFA.AddFireSound(pref .. ".FireLoop", path .. "MP5_Auto_Loop_City_Mix.wav", true, "^"  ) 
	TFA.AddFireSound(pref .. ".FireLoopEnd", path .. "MP5_Auto_Tail_City_Mix.ogg", true, "^"  ) 

	TFA.AddSound(pref .. ".SlideBack", CHAN_AUTO, 0.6, 75, 100, path .. "MP5_Reload_Handle_Back.ogg")
	TFA.AddSound(pref .. ".SlideForward", CHAN_AUTO, 0.6, 75, 100, path .. "MP5_Reload_Handle_FWD.ogg")
	TFA.AddSound(pref .. ".SlideBackInspect", CHAN_AUTO, 0.6, 75, 100, path .. "MP5_Check_Handle_Back.ogg")
	TFA.AddSound(pref .. ".SlideForwardInspect", CHAN_AUTO, 0.6, 75, 100, path .. "MP5_Check_Handle_FWD.ogg")
	TFA.AddSound(pref .. ".MagOutHalf", CHAN_AUTO, 0.6, 75, 100, path .. "MP5_Half_Reload_Mag_Out.ogg")
	TFA.AddSound(pref .. ".MagInHalf", CHAN_AUTO, 0.6, 75, 100, path .. "MP5_Half_Reload_Mag_In.ogg")
	TFA.AddSound(pref .. ".MagOut", CHAN_AUTO, 0.6, 75, 100, path .. "MP5_Reload_Mag_Out.ogg")
	TFA.AddSound(pref .. ".MagIn", CHAN_AUTO, 0.6, 75, 100, path .. "MP5_Reload_Mag_In.ogg")
	TFA.AddSound(pref .. ".MagOutInspect", CHAN_AUTO, 0.6, 75, 100, path .. "MP5_Check_Mag_Out.ogg")
	TFA.AddSound(pref .. ".MagInInspect", CHAN_AUTO, 0.6, 75, 100, path .. "MP5_Check_Mag_In.ogg")
end

do -- Kriss SMG 
	path = basepath .. "WEP_KRISS/"
	pref = basepref .. "Kriss"

	TFA.AddFireSound(pref .. ".Fire", {
		path .. "KRISS_Single_1_Mix.ogg",
		path .. "KRISS_Single_2_Mix.ogg",
		path .. "KRISS_Single_3_Mix.ogg",
		path .. "KRISS_Single_4_Mix.ogg"
	}, true, "^"  )	

	TFA.AddFireSound(pref .. ".FireLoop", path .. "KRISS_Auto_Loop_City_Mix.wav", true, "^"  ) 
	TFA.AddFireSound(pref .. ".FireLoopEnd", path .. "KRISS_Auto_Tail_City_Mix.ogg", true, "^"  ) 

	TFA.AddSound(pref .. ".Slide", CHAN_AUTO, 0.6, 75, 100, path .. "KRISS_Reload_Handle.ogg")
	TFA.AddSound(pref .. ".SlideBackInspect", CHAN_AUTO, 0.6, 75, 100, path .. "KRISS_Check_Handle_Back.ogg")
	TFA.AddSound(pref .. ".SlideForwardInspect", CHAN_AUTO, 0.6, 75, 100, path .. "KRISS_Check_Handle_FWD.ogg")
	TFA.AddSound(pref .. ".MagOutHalf", CHAN_AUTO, 0.6, 75, 100, path .. "KRISS_Half_Mag_Out.ogg")
	TFA.AddSound(pref .. ".MagInHalf", CHAN_AUTO, 0.6, 75, 100, path .. "KRISS_Half_Mag_In.ogg")
	TFA.AddSound(pref .. ".MagOut", CHAN_AUTO, 0.6, 75, 100, path .. "KRISS_Reload_Mag_Out.ogg")
	TFA.AddSound(pref .. ".MagInA", CHAN_AUTO, 0.6, 75, 100, path .. "KRISS_Reload_Mag_In_A.ogg")
	TFA.AddSound(pref .. ".MagInB", CHAN_AUTO, 0.6, 75, 100, path .. "KRISS_Reload_Mag_In_B.ogg")
	TFA.AddSound(pref .. ".ButtonInspect", CHAN_AUTO, 0.6, 75, 100, path .. "KRISS_Check_Button.ogg")
	TFA.AddSound(pref .. ".MagOutInspect", CHAN_AUTO, 0.6, 75, 100, path .. "KRISS_Check_Mag_Out.ogg")
	TFA.AddSound(pref .. ".MagInInspect", CHAN_AUTO, 0.6, 75, 100, path .. "KRISS_Check_Mag_In.ogg")
end

do -- UMP 
	path = basepath .. "WEP_UMP/"
	pref = basepref .. "UMP"
	
	TFA.AddFireSound(pref .. ".Fire", path .. "WEP_SA_UMP_1P_Fire_Single_City_Mix.ogg", true, "^"  ) 

	TFA.AddFireSound(pref .. ".Fire2Burst", path .. "WEP_SA_UMP_1P_Fire_2Burst_City_Mix.ogg", true, "^"  ) 
	TFA.AddFireSound(pref .. ".Fire3Burst", path .. "WEP_SA_UMP_1P_Fire_3Burst_City_Mix.ogg", true, "^"  ) 

	TFA.AddFireSound(pref .. ".FireLoop", path .. "WEP_SA_UMP_3P_Fire_Loop_City_Mix.wav", true, "^"  ) 
	TFA.AddFireSound(pref .. ".FireLoopEnd", path .. "WEP_SA_UMP_1P_Fire_EndLoop_City_Mix.ogg", true, "^"  ) 

	TFA.AddSound(pref .. ".SlideBack", CHAN_AUTO, 0.6, 75, 100, path .. "UMP_Reload_Full_Bolt_Back.ogg")
	TFA.AddSound(pref .. ".SlideForward", CHAN_AUTO, 0.6, 75, 100, path .. "UMP_Reload_Full_Bolt_Release.ogg")
	TFA.AddSound(pref .. ".SlideBackInspect", CHAN_AUTO, 0.6, 75, 100, path .. "UMP_Check_Bolt_Back.ogg")
	TFA.AddSound(pref .. ".SlideForwardInspect", CHAN_AUTO, 0.6, 75, 100, path .. "UMP_Check_Bolt_Release.ogg")
	TFA.AddSound(pref .. ".MagOutHalf", CHAN_AUTO, 0.6, 75, 100, path .. "UMP_Reload_Half_Mag_Out.ogg")
	TFA.AddSound(pref .. ".MagInHalf", CHAN_AUTO, 0.6, 75, 100, path .. "UMP_Reload_Half_Mag_In.ogg")
	TFA.AddSound(pref .. ".MagOut", CHAN_AUTO, 0.6, 75, 100, path .. "UMP_Reload_Full_Mag_Out.ogg")
	TFA.AddSound(pref .. ".MagIn1", CHAN_AUTO, 0.6, 75, 100, path .. "UMP_Reload_Full_Mag_In_1.ogg")
	TFA.AddSound(pref .. ".MagIn2", CHAN_AUTO, 0.6, 75, 100, path .. "UMP_Reload_Full_Mag_In_2.ogg")
	TFA.AddSound(pref .. ".MagOutInspect", CHAN_AUTO, 0.6, 75, 100, path .. "UMP_Check_Mag_Out.ogg")
	TFA.AddSound(pref .. ".MagInInspect", CHAN_AUTO, 0.6, 75, 100, path .. "UMP_Check_Mag_In.ogg")
end

do -- P90
	path = basepath .. "WEP_P90/"
	pref = basepref .. "P90"
	
	TFA.AddFireSound(pref .. ".Fire", {
		path .. "P90_Single_1_Mix.ogg",
		path .. "P90_Single_2_Mix.ogg",
		path .. "P90_Single_3_Mix.ogg",
		path .. "P90_Single_4_Mix.ogg",
		path .. "P90_Single_5_Mix.ogg"
	}, true, "^"  )	

	TFA.AddFireSound(pref .. ".FireLoop", path .. "P90_Auto_Loop_City_Mix.wav", true, "^"  ) 
	TFA.AddFireSound(pref .. ".FireLoopEnd", path .. "P90_Auto_Tail_City_Mix.ogg", true, "^"  ) 

	TFA.AddSound(pref .. ".Slide", CHAN_AUTO, 0.6, 75, 100, path .. "P90_Reload_Empty_Slide.ogg")
	TFA.AddSound(pref .. ".SlideBackInspect", CHAN_AUTO, 0.6, 75, 100, path .. "P90_GunCheck_V2_Slide_Back.ogg")
	TFA.AddSound(pref .. ".SlideForwardInspect", CHAN_AUTO, 0.6, 75, 100, path .. "P90_GunCheck_V2_Slide_FWD.ogg")
	TFA.AddSound(pref .. ".MagOut", CHAN_AUTO, 0.6, 75, 100, path .. "P90_Reload_Empty_MagOut.ogg")
	TFA.AddSound(pref .. ".MagIn", CHAN_AUTO, 0.6, 75, 100, path .. "P90_Reload_Empty_MagIn.ogg")
	TFA.AddSound(pref .. ".MagHit", CHAN_AUTO, 0.6, 75, 100, path .. "P90_Reload_Empty_Hit.ogg")
	TFA.AddSound(pref .. ".MagOutHalf", CHAN_AUTO, 0.6, 75, 100, path .. "P90_Reload_Half_MagOut.ogg")
	TFA.AddSound(pref .. ".MagInHalfStart", CHAN_AUTO, 0.6, 75, 100, path .. "P90_Reload_Half_MagIn_Start.ogg")
	TFA.AddSound(pref .. ".MagInHalfMid", CHAN_AUTO, 0.6, 75, 100, path .. "P90_Reload_Half_MagIn_Mid.ogg")
	TFA.AddSound(pref .. ".MagInHalfEnd", CHAN_AUTO, 0.6, 75, 100, path .. "P90_Reload_Half_MagIn_End.ogg")
	TFA.AddSound(pref .. ".MagOutInspect", CHAN_AUTO, 0.6, 75, 100, path .. "P90_GunCheck_V3_MagOut.ogg")
	TFA.AddSound(pref .. ".MagInInspect", CHAN_AUTO, 0.6, 75, 100, path .. "P90_GunCheck_V3_MagIn.ogg")
	TFA.AddSound(pref .. ".MagHitInspect", CHAN_AUTO, 0.6, 75, 100, path .. "P90_GunCheck_V3_Hit.ogg")
end

do -- G18
	path = basepath .. "WEP_G18/"
	pref = basepref .. "G18"

	TFA.AddFireSound(pref .. ".Fire", {
		path .. "WEP_G18_Auto_Single_1_Mix.ogg",
		path .. "WEP_G18_Auto_Single_2_Mix.ogg",
		path .. "WEP_G18_Auto_Single_3_Mix.ogg"
	}, true, "^"  )	

	TFA.AddFireSound(pref .. ".FireLoop", path .. "WEP_G18_Auto_3P_Loop_Mix.wav", true, "^"  ) 
	TFA.AddFireSound(pref .. ".FireLoopEnd", path .. "WEP_G18_Auto_Loop_End_City_Mix.ogg", true, "^"  ) 

	TFA.AddSound(pref .. ".Deploy", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_Riot_Shield_Equip.ogg")
	TFA.AddSound(pref .. ".Holster", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_Riot_Shield_Put_Away.ogg")
	
	TFA.AddSound(pref .. ".Bash", CHAN_AUTO, 0.6, 75, 100, {
		path .. "WEP_Riot_Shield_Bash_1.ogg",
		path .. "WEP_Riot_Shield_Bash_2.ogg"
	}, ")")
	
	TFA.AddSound(pref .. ".NadeThrow1", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_Riot_Shield_Nade_Throw_1.ogg")
	TFA.AddSound(pref .. ".NadeThrow2", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_Riot_Shield_Nade_Throw_2.ogg")
	
	TFA.AddSound(pref .. ".MagOutHalf", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_G18_Half_Mag_Out.ogg")
	TFA.AddSound(pref .. ".MagInHalf", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_G18_Half_Mag_In.ogg")
	TFA.AddSound(pref .. ".MagOutHalfElite", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_G18_Half_Elite_Mag_Out.ogg")
	TFA.AddSound(pref .. ".MagInHalfElite", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_G18_Half_Elite_Mag_In.ogg")
	TFA.AddSound(pref .. ".MagOutEmpty", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_G18_Empty_Mag_Out.ogg")
	TFA.AddSound(pref .. ".MagInEmpty", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_G18_Empty_Mag_In.ogg")
	TFA.AddSound(pref .. ".SlideForward", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_G18_Empty_Slide_FWD.ogg")
	TFA.AddSound(pref .. ".MagOutEmptyElite", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_G18_Empty_Elite_Mag_In.ogg")
	TFA.AddSound(pref .. ".MagInEmptyElite", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_G18_Empty_Elite_Mag_Out.ogg")
	TFA.AddSound(pref .. ".SlideForwardElite", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_G18_Empty_Elite_Slide_FWD.ogg")
end

do -- MP7 
	path = basepath .. "WEP_MP7/"
	pref = basepref .. "MP7"
	
	TFA.AddFireSound(pref .. ".Fire", {
		path .. "MP7_Sil_Single_Shot_1_Mix.ogg",
		path .. "MP7_Sil_Single_Shot_2_Mix.ogg",
		path .. "MP7_Sil_Single_Shot_3_Mix.ogg",
		path .. "MP7_Sil_Single_Shot_4_Mix.ogg"
	}, true, "^"  )	

	TFA.AddFireSound(pref .. ".FireLoop", path .. "MP7_Sil_Auto_Loop_Small_Mix.wav", true, "^"  ) 
	TFA.AddFireSound(pref .. ".FireLoopEnd", path .. "MP7_Sil_Auto_Tail_City_Mix.ogg", true, "^"  ) 

	TFA.AddSound(pref .. ".SlideBack", CHAN_AUTO, 0.6, 75, 100, path .. "MP7_Reload_Empty_Back.ogg")
	TFA.AddSound(pref .. ".SlideForward", CHAN_AUTO, 0.6, 75, 100, path .. "MP7_Reload_Empty_Forward.ogg")
	TFA.AddSound(pref .. ".SlideBackInspect", CHAN_AUTO, 0.6, 75, 100, path .. "MP7_Check_V2_Back.ogg")
	TFA.AddSound(pref .. ".SlideForwardInspect", CHAN_AUTO, 0.6, 75, 100, path .. "MP7_Check_V2_Forward.ogg")
	TFA.AddSound(pref .. ".MagOut", CHAN_AUTO, 0.6, 75, 100, path .. "MP7_Mag_Out.ogg")
	TFA.AddSound(pref .. ".MagIn", CHAN_AUTO, 0.6, 75, 100, path .. "MP7_Mag_In.ogg")
end

do -- AR15
	path = basepath .. "WEP_SA_AR15/"
	path1 = basepath .. "WEP_Distant/"
	pref = basepref .. "AR15"
	
	TFA.AddFireSound(pref .. ".EchoFire", {
		path1 .. "Rifle_Outdoor_Single_Echo_01.ogg",
		path1 .. "Rifle_Outdoor_Single_Echo_02.ogg",
		path1 .. "Rifle_Outdoor_Single_Echo_03.ogg", 
		path1 .. "Rifle_Outdoor_Single_Echo_04.ogg", 
		path1 .. "Rifle_Outdoor_Single_Echo_05.ogg", 
		path1 .. "Rifle_Outdoor_Single_Echo_06.ogg", 
		path1 .. "Rifle_Outdoor_Single_Echo_07.ogg", 
		path1 .. "Rifle_Outdoor_Single_Echo_08.ogg"
	}, true, "^"  )	
end 

do -- AK12
	path = basepath .. "WEP_SA_AK12/"
	path1 = basepath .. "WEP_Distant/"
	pref = basepref .. "AK12"
	
	TFA.AddFireSound(pref .. ".EchoFire", {
		path1 .. "WEP_SA_AK12_Echo_Outdoor_Single_01.ogg",
		path1 .. "WEP_SA_AK12_Echo_Outdoor_Single_02.ogg",
		path1 .. "WEP_SA_AK12_Echo_Outdoor_Single_03.ogg", 
		path1 .. "WEP_SA_AK12_Echo_Outdoor_Single_04.ogg", 
		path1 .. "WEP_SA_AK12_Echo_Outdoor_Single_05.ogg", 
		path1 .. "WEP_SA_AK12_Echo_Outdoor_Single_06.ogg", 
		path1 .. "WEP_SA_AK12_Echo_Outdoor_Single_07.ogg", 
		path1 .. "WEP_SA_AK12_Echo_Outdoor_Single_08.ogg"
	}, true, "^"  )	

	TFA.AddSound(pref .. ".DryFire", CHAN_AUTO, 0.6, 75, 100, {
		path .. "WEP_SA_AK12_Handling_DryFire_01.ogg",
		path .. "WEP_SA_AK12_Handling_DryFire_02.ogg",
		path .. "WEP_SA_AK12_Handling_DryFire_03.ogg"
	}, ")")

	TFA.AddSound(pref .. ".Deploy", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_SA_AK12_Handling_PullOut.ogg")
	TFA.AddSound(pref .. ".Holster", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_SA_AK12_Handling_PutAway.ogg")
end 

do -- L85A2
	path = basepath .. "WEP_SA_L85A2/"
	pref = basepref .. "L85A2"
	
	TFA.AddSound(pref .. ".Rustle", CHAN_AUTO, 0.6, 75, 100, {
		path .. "WEP_SA_L85A2_Handling_Rustle_01.ogg",
		path .. "WEP_SA_L85A2_Handling_Rustle_02.ogg",
		path .. "WEP_SA_L85A2_Handling_Rustle_03.ogg"
	}, ")")
end 

do -- 9mm
	path = basepath .. "WEP_SA_9MM/"
	path1 = basepath .. "WEP_Distant/"
	pref = basepref .. "9MM"

	TFA.AddFireSound(pref .. ".Fire", {
		path .. "9mm_V1_1_Mix.ogg",
		path .. "9mm_V1_2_Mix.ogg",
		path .. "9mm_V1_3_Mix.ogg", 
		path .. "9mm_V1_4_Mix.ogg"
	}, true, "^"  ) 

	TFA.AddFireSound(pref .. ".EchoFire", {
--		path1 .. "WEP_SA_9mm_Echo_Outdoor_01.ogg",
--		path1 .. "WEP_SA_9mm_Echo_Outdoor_02.ogg",
--		path1 .. "WEP_SA_9mm_Echo_Outdoor_03.ogg", 
--		path1 .. "WEP_SA_9mm_Echo_Outdoor_04.ogg", bad for auto and doesn't fit in general
		path1 .. "WEP_SA_9mm_Echo_Outdoor_05.ogg", 
		path1 .. "WEP_SA_9mm_Echo_Outdoor_06.ogg", 
		path1 .. "WEP_SA_9mm_Echo_Outdoor_07.ogg", 
		path1 .. "WEP_SA_9mm_Echo_Outdoor_08.ogg"
	}, true, "^"  )

	TFA.AddSound(pref .. ".Deploy", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_SA_.ogg" )
	TFA.AddSound(pref .. ".MagOut", CHAN_AUTO, 0.6, 75, 100, {
		path .. "WEP_SA_9mm_Handling_MagOut_01.ogg",
		path .. "WEP_SA_9mm_Handling_MagOut_03.ogg",
		path .. "WEP_SA_9mm_Handling_MagOut_03.ogg",
	}, ")")
	TFA.AddSound(pref .. ".MagInA", CHAN_AUTO, 0.6, 75, 100, {
		path .. "WEP_SA_9mm_Handling_MagInA_01.ogg",
		path .. "WEP_SA_9mm_Handling_MagInA_02.ogg",
		path .. "WEP_SA_9mm_Handling_MagInA_03.ogg",
	}, ")")
	TFA.AddSound(pref .. ".MagInB", CHAN_AUTO, 0.6, 75, 100, {
		path .. "WEP_SA_9mm_Handling_MagInB_01.ogg",
		path .. "WEP_SA_9mm_Handling_MagInB_02.ogg",
		path .. "WEP_SA_9mm_Handling_MagInB_03.ogg",
	}, ")")
	TFA.AddSound(pref .. ".SlideBack", CHAN_AUTO, 0.6, 75, 100, {
		path .. "WEP_SA_9mm_Handling_SlideOpen_01.ogg",
		path .. "WEP_SA_9mm_Handling_SlideOpen_02.ogg",
		path .. "WEP_SA_9mm_Handling_SlideOpen_03.ogg",
	}, ")")
	TFA.AddSound(pref .. ".SlideForward", CHAN_AUTO, 0.6, 75, 100, {
		path .. "WEP_SA_9mm_Handling_SlideClose_01.ogg",
		path .. "WEP_SA_9mm_Handling_SlideClose_02.ogg",
		path .. "WEP_SA_9mm_Handling_SlideClose_03.ogg",
	}, ")")
	TFA.AddSound(pref .. ".Rustle", CHAN_AUTO, 0.6, 75, 100, {
		path .. "WEP_SA_9mm_Handling_Rattle_01.ogg",
		path .. "WEP_SA_9mm_Handling_Rattle_02.ogg",
		path .. "WEP_SA_9mm_Handling_Rattle_03.ogg",
		path .. "WEP_SA_9mm_Handling_Rattle_04.ogg",
		path .. "WEP_SA_9mm_Handling_Rattle_05.ogg",
		path .. "WEP_SA_9mm_Handling_Rattle_06.ogg"
	}, ")")
end 

do -- Deagle
	path = basepath .. "WEP_SA_DesertEagle/"
	path1 = basepath .. "WEP_Distant/"
	pref = basepref .. "DesertEagle"

	TFA.AddFireSound(pref .. ".Fire", {
		path .. "DE_Shot_Medium_1.ogg",
		path .. "DE_Shot_Medium_2.ogg",
		path .. "DE_Shot_Medium_3.ogg", 
		path .. "DE_Shot_Medium_4.ogg",
		path .. "DE_Shot_Small_1.ogg",
		path .. "DE_Shot_Small_2.ogg",
		path .. "DE_Shot_Small_3.ogg", 
		path .. "DE_Shot_Small_4.ogg",
	}, true, "^"  )

	TFA.AddSound(pref .. ".MagOut", CHAN_AUTO, 0.6, 75, 90, {
		path .. "WEP_SA_9mm_Handling_MagOut_01.ogg",
		path .. "WEP_SA_9mm_Handling_MagOut_03.ogg",
		path .. "WEP_SA_9mm_Handling_MagOut_03.ogg",
	}, ")")
	TFA.AddSound(pref .. ".MagInA", CHAN_AUTO, 0.6, 75, 90, {
		path .. "WEP_SA_9mm_Handling_MagInA_01.ogg",
		path .. "WEP_SA_9mm_Handling_MagInA_02.ogg",
		path .. "WEP_SA_9mm_Handling_MagInA_03.ogg",
	}, ")")
	TFA.AddSound(pref .. ".MagInB", CHAN_AUTO, 0.6, 75, 90, {
		path .. "WEP_SA_9mm_Handling_MagInB_01.ogg",
		path .. "WEP_SA_9mm_Handling_MagInB_02.ogg",
		path .. "WEP_SA_9mm_Handling_MagInB_03.ogg",
	}, ")")
	TFA.AddSound(pref .. ".SlideBack", CHAN_AUTO, 0.6, 75, 90, {
		path .. "WEP_SA_9mm_Handling_SlideOpen_01.ogg",
		path .. "WEP_SA_9mm_Handling_SlideOpen_02.ogg",
		path .. "WEP_SA_9mm_Handling_SlideOpen_03.ogg",
	}, ")")
	TFA.AddSound(pref .. ".SlideForward", CHAN_AUTO, 0.6, 75, 90, {
		path .. "WEP_SA_9mm_Handling_SlideClose_01.ogg",
		path .. "WEP_SA_9mm_Handling_SlideClose_02.ogg",
		path .. "WEP_SA_9mm_Handling_SlideClose_03.ogg",
	}, ")") 

	TFA.AddFireSound(pref .. ".EchoFire", {
--		path1 .. "WEP_SA_9mm_Echo_Outdoor_01.ogg",
--		path1 .. "WEP_SA_9mm_Echo_Outdoor_02.ogg",
--		path1 .. "WEP_SA_9mm_Echo_Outdoor_03.ogg", 
--		path1 .. "WEP_SA_9mm_Echo_Outdoor_04.ogg", bad for auto and doesn't fit in general
		path1 .. "WEP_SA_9mm_Echo_Outdoor_05.ogg", 
		path1 .. "WEP_SA_9mm_Echo_Outdoor_06.ogg", 
		path1 .. "WEP_SA_9mm_Echo_Outdoor_07.ogg", 
		path1 .. "WEP_SA_9mm_Echo_Outdoor_08.ogg"
	}, true, "^"  )

	TFA.AddSound(pref .. ".Deploy", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_SA_.ogg" )
end

do -- 1911
	path = basepath .. "WEP_1911/"
	path1 = basepath .. "WEP_Distant/"
	pref = basepref .. "1911"

	TFA.AddFireSound(pref .. ".Fire", {
		path .. "1911_Shot_1_Mix.ogg",
		path .. "1911_Shot_2_Mix.ogg",
		path .. "1911_Shot_3_Mix.ogg", 
		path .. "1911_Shot_4_Mix.ogg"
	}, true, "^"  ) 

	TFA.AddFireSound(pref .. ".EchoFire", {
		path1 .. "WEP_SA_9mm_Echo_Outdoor_01.ogg", 
		path1 .. "WEP_SA_9mm_Echo_Outdoor_02.ogg", 
		path1 .. "WEP_SA_9mm_Echo_Outdoor_03.ogg", 
		path1 .. "WEP_SA_9mm_Echo_Outdoor_04.ogg"
	}, true, "^"  )
end

do -- 1858 Revolver
	path = basepath .. "WEP_SA_1858/"
	path1 = basepath .. "WEP_Distant/"
	pref = basepref .. "1858"

	TFA.AddFireSound(pref .. ".Fire", {
		path .. "1858_Shot_Medium_1.ogg",
		path .. "1858_Shot_Medium_2.ogg",
		path .. "1858_Shot_Medium_3.ogg", 
		path .. "1858_Shot_Medium_4.ogg"
	}, true, "^"  ) 

	TFA.AddSound(pref .. ".CylinderIn", CHAN_AUTO, 0.6, 75, 100, path .. "1858_Cylinder_In.ogg" )
	TFA.AddSound(pref .. ".CylinderOut", CHAN_AUTO, 0.6, 75, 100, path .. "1858_Cylinder_Out.ogg" )
	TFA.AddSound(pref .. ".Hammer", CHAN_AUTO, 0.6, 75, 100, path .. "1858_Hammer.ogg" )
	TFA.AddSound(pref .. ".PinSlide", CHAN_AUTO, 0.6, 75, 100, path .. "1858_Pin_Slide.ogg" )
	TFA.AddSound(pref .. ".LeverClose", CHAN_AUTO, 0.6, 75, 100, {
		path .. "1858_Lever_Close_2.ogg",
		path .. "1858_Lever_Close_3.ogg",
		path .. "1858_Lever_Close_4.ogg",
	}, ")")
	TFA.AddSound(pref .. ".LeverOpen", CHAN_AUTO, 0.6, 75, 100, {
		path .. "1858_Lever_Open_2.ogg",
		path .. "1858_Lever_Open_3.ogg",
		path .. "1858_Lever_Open_4.ogg",
	}, ")")
	TFA.AddSound(pref .. ".HammerBack", CHAN_AUTO, 0.6, 75, 100, {
		path .. "Hammer_Back_1.ogg",
		path .. "Hammer_Back_2.ogg",
		path .. "Hammer_Back_3.ogg",
		path .. "Hammer_Back_4.ogg",
		path .. "Hammer_Back_5.ogg",
		path .. "Hammer_Back_6.ogg",
	}, ")")
end

do -- AA12
	path = basepath .. "WEP_SA_AA12/"
	pref = basepref .. "AA12"
	
	TFA.AddSound(pref .. ".Dryfire", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_SA_AA12_Handling_DryFire.ogg" )
	TFA.AddSound(pref .. ".Equip", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_SA_AA12_Handling_Equip.ogg" )
	TFA.AddSound(pref .. ".Unequip", CHAN_AUTO, 0.6, 75, 100, path .. "WEP_SA_AA12_Handling_Unequip.ogg" )
end 