local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

addon.Bosses = {
	[156239] = {93489,{304948,304946,345554}}, --Dark Ascended Corrus
	[170418] = {93853,{332239,332181}}, --Goxul the Devourer
	[153165] = {100473,{327467,327461,297292}}, --Custodian Thonar
	[156015] = {100474,{304479,999999999}}, --Writhing Soulmass
	[153382] = {100530,{330479,297966}}, --Maw of the Maw
	[159755] = {100480,{295985,335528,330118}}, --The Grand Malleare
	[151331] = {100478,{293063,295985,295991,330458}}, --Cellblock Sentinel
	[153011] = {97776,{297020,297024,183345}}, --Binder Baritas
	[159190] = {92785,{184381,310392,310405}}, --Synod
	[153174] = {97777,{330438,330477,297310}}, --Watchers of Death
	[155250] = {94412,{330500,272382,330496}}, --Decayspeaker
	[171422] = {97237,{294526,334538,329322,334562}}, --Arch-Suppressor Laguas
	[169859] = {97075,{330793,330755,330822}}, --Observer Zelgar
	[151329] = {92411,{295932,295942,295929}}, --Warden Skoldus
	[153451] = {100476,{298160,298073}}, --Kosarus the Fallen
	[155945] = {100477,{318995,304254,167012}}, --Gherus the Chained
	[152995] = {93213,{297018,297017,296961}}, --Warden of Souls
	[157122] = {92919,{328879,252057,328869,252063}}, --Patrician Cromwell
	[155251] = {93976,{330573,326399,330500}}, --Elder Longbranch
}


addon.BossTips = {
	[156239] = {L["Corrus_Tip1"], L["Corrus_Tip2"]}, --Dark Ascended Corrus
	[170418] = {L["Goxul_Tip1"],L["Goxul_Tip2"]}, --Goxul the Devourer
	[153165] = {L["Thonar_Tip1"],L["Thonar_Tip2"],L["Thonar_Tip3"],L["Thonar_Tip4"]}, --Custodian Thonar
	[156015] = {L["Soulmass_Tip1"],L["Soulmass_Tip2"]}, --Writhing Soulmass
	[153382] = {L["Maw_Tip1"],L["Maw_Tip2"]}, --Maw of the Maw
	[159755] = {L["Malleare_Tip1"],L["Malleare_Tip2"]}, --The Grand Malleare
	[151331] = {L["Sentinel_Tip1"],L["Sentinel_Tip2"]}, --Cellblock Sentinel
	[153011] = {L["Baritas_Tip1"],L["Baritas_Tip2"]}, --Binder Baritas
	[159190] = {L["Synod_Tip1"],L["Synod_Tip2"],L["Synod_Tip3"],L["Synod_Tip4"]}, --Synod
	[153174] = {L["Watchers_Tip1"],L["Watchers_Tip2"]}, --Watchers of Death
	[155250] = {L["Decayspeaker_Tip1"],L["Decayspeaker_Tip2"]}, --Decayspeaker
	[171422] = {L["Laguas_Tip1"],L["Laguas_Tip2"],L["Laguas_Tip3"],L["Laguas_Tip4"]}, --Arch-Suppressor Laguas
	[169859] = {L["Zelgar_Tip1"],L["Zelgar_Tip2"],L["Zelgar_Tip3"]}, --Observer Zelgar
	[151329] = {L["Skoldus_Tip1"],L["Skoldus_Tip2"]}, --Warden Skoldus
	[153451] = {L["Kosarus_Tip1"],L["Kosarus_Tip2"]}, --Kosarus the Fallen
	[155945] = {L["Gherus_Tip1"],L["Gherus_Tip2"],L["Gherus_Tip3"]}, --Gherus the Chained
	[152995] = {L["Warden_Tip1"],L["Warden_Tip2"],L["Warden_Tip3"]}, --Warden of Souls
	[157122] = {L["Cromwell_Tip1"],L["Cromwell_Tip2"],L["Cromwell_Tip3"]}, --Patrician Cromwell
	[155251] = {L["Longbranch_Tip1"],L["Longbranch_Tip2"],L["Longbranch_Tip3"]}, --Elder Longbranch
}

addon.BossCamera = {
	[95004] = 362, --venari
	[152253] = 9, --tarraske
	[156239] = 65, --Dark Ascended Corrus
	[170418] = 65, --Goxul the Devourer
	[156015] = 9, --Writhing Soulmass
	[153382] = 9, --Maw of the Maw
	[159755] = 9, --The Grand Malleare
	[151331] = 65, --Cellblock Sentinel
	[169859] = 65, --Observer Zelgar
	[152995] = 9, --Warden of Souls
	[157122] = 355, --Patrician Cromwell
	[155251] = 66 , --Elder Longbranch
	[153011] = 65, --Binder Baritas
	[153174] = 65, --Watchers of Death

	--[151329] = 355, --Warden of Souls
	--[153165] = 65, --Custodian Thonar
	
	[152500] = 65, --Deadsoul Amalgam
	[173080] = 9, --Wandering Death
	[173238] = 65, --Deadsoul Strider
	[152612] = 9, --Subjugator Klontzas
	[152508] = 9, --Dusky Tremorbeast
	[173051] = 9, --Suppressor Xelsor
	[156134] = 9, --Ghastly Charger
	[170417] = 9, --Animated Stygia
	[155483] = 9, --Faeleaf Shimmerwing
	[170228] = 355, --Bone Husk
	[169823] = 9, --Gorm Behemoth
	[173114] = 362, --Invasive Decayfly
	[173136] = 65, --blightsmasher
	[170414] = 9, --Howling Spectre
	[173191] = 9, --Soulstalker V'lara
	[152517] = 9, --Deadsoul Lifetaker
	[156158] = 65, --Adjutant Felipos
	[173134] = 65, --Darksworn Goliath
	[156237] = 65, --Imperator Dara
	[170385] = 9, --Writhing Misery
	[156142] = 9, --Seeker of Souls
}
