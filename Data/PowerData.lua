local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--GetMawPowerLinkBySpellID(305308)
--GetSpellDescription(304918)
--GetSpellInfo(305308) 
--FindBaseSpellByID(305308)
--/script DEFAULT_CHAT_FRAME:AddMessage("\124cffffd000\124Hspell:305308\124h[Broker's Purse]\124h\124r");
local PowerNames = {
--Ravenous
	["Broker's Purse"] = 305308,
	["Mawrat Harness"] = 304918,
	["Pocketed Soulcage"] = 305269,
	["Shackle Keys"] = 297413,
	["Maw Seeker Harness"] = 304918,
	["Warden's Authority"] = 305266,
	["Marrow Scooper"] = 305287,
	["Skeletal Ward"] = 305288,
	["Flamestarved Cinders"] = 305277,
	["Dark Armaments"] = 305274,
	["Deadsoul Hound Harness"] = 304917,
	["Purifier's Flame"] = 295754,
	["Glasswing Charm"] = 305282,
	["Prisoner's Concord"] = 305293,
--Rare
	["Pulsing Rot-hive"] = 338616,
	["Swarm Form"] = 338631,
	["Obleron Endurance"] = 293025,
	["Obleron Endurance x3"] = 293027,
	["Obleron Winds"] = 294592,
	["Obleron Winds x3"] = 294594,
	["Obleron Talisman x3"] = 294601,
	["Obleron Spikes x3"] = 294588,
	["Spectral Oats"] = 315319,
	["Spectral Bridle"] = 315314,
	["Resonating Effigy"] = 339026,
	["Ephemeral Effigy"] = 339024,
	["Tremorbeast Tusk"] = 297576,
	["Tremorbeast Heart"] = 296140,
	["Soulward Clasp"] = 338922,
	["V'lara's Cape of Subterfuge"] = 338948,
	["Dark Fortress"] = 337878,
	["Fallen Armaments"] = 337881,
	["Fractured Phantasma Lure"] = 337750,
	["Reinforced Lure Casing"] = 337765,
	["Icy Heartcrust"] = 315300,
	["Frostbite Wand"] = 315288,
	["Erratic Howler"] = 337613,
	["Unstable Form"] = 337620,
	["Vial of Lost Potential"] = 305273,
	["Subjugator's Manacles"] = 297721,
	["Shimmering Wingcape"] = 338029,
	["Irritating Moth Dust"] = 338023,
	["Coffer of Spectral Whispers"] = 338446,
	["Elongated Skeletal Arms"] = 338449,
	["Vitality Guillotine"] = 300730,
	["Blade of the Lifetaker"] = 300771,
	["Pouch of Phantasma"] = 295072,
	["Lumbering Form"] = 337938,
	["Potent Acid Gland"] = 337928,
}

addon.mobs = {
--All Wings
	[151353] = PowerNames["Mawrat Harness"], --Mawrat
	[154030] = PowerNames["Mawrat Harness"], --Oddly Large Mawrat
	[152594] = PowerNames["Broker's Purse"], --Broker Ve'ken
	[170257] = PowerNames["Broker's Purse"], --Broker Ve'nott
	[155798] = PowerNames["Shackle Keys"], --Mawsworn Shackler
	[150965] = PowerNames["Shackle Keys"], --Mawsworn Shackler
	[171172] = PowerNames["Shackle Keys"], --Mawsworn Shackler
	
--Skoldus Hall
	[152708] = PowerNames["Maw Seeker Harness"], --Mawsworn Seeker
	[153878] = PowerNames["Pocketed Soulcage"], --Mawsworn Archer
	[150959] = PowerNames["Pocketed Soulcage"], --Mawsworn Interceptor
	[150958] = PowerNames["Warden's Authority"], --Mawsworn Guard
	[153874] = PowerNames["Warden's Authority"], --Mawsworn Sentry

--Fracture Chambers
	[155790] = PowerNames["Marrow Scooper"], --Mawsworn Acolyte
	[155830] = PowerNames["Marrow Scooper"], --Mawsworn Disciple
	[157810] = PowerNames["Marrow Scooper"], --Mawsworn Endbringer
	[155949] = PowerNames["Marrow Scooper"], --Mawsworn Soulbinder
	[155831] = PowerNames["Marrow Scooper"], --Mawsworn Soulbinder
	[157809] = PowerNames["Marrow Scooper"], --Mawsworn Darkcaster
	[155812] = PowerNames["Marrow Scooper"], --Mawsworn Ritualist
	[155824] = PowerNames["Marrow Scooper"], --Lumbering Creation
	[155793] = PowerNames["Skeletal Ward"], --Skeletal Remains
	[157819] = PowerNames["Warden's Authority"], --Mawsworn Shadestalker
	[171173] = PowerNames["Warden's Authority"], --Mawsworn Shadestalker

--	Soulforges
	[157584] = PowerNames["Flamestarved Cinders"], --Flameforge Master
	[157583] = PowerNames["Flamestarved Cinders"], --Forge Keeper
	[157572] = PowerNames["Flamestarved Cinders"], --Mawsworn Firecaller
	[157571] = PowerNames["Flamestarved Cinders"], --Mawsworn Flametender	
	[152708] = PowerNames["Maw Seeker Harness"], --Mawsworn Seeker
	[153878] = PowerNames["Pocketed Soulcage"], --Mawsworn Archer
	[157634] = PowerNames["Warden's Authority"], --Flameforge Enforcer
	[150958] = PowerNames["Warden's Authority"], --Mawsworn Guard
	[153874] = PowerNames["Warden's Authority"], --Mawsworn Sentry

-- Coldheart Interstitia
	[156212] = PowerNames["Dark Armaments"], --Coldheart Agent
	[165594] = PowerNames["Dark Armaments"], --Coldheart Ambusher
	[156157] = PowerNames["Dark Armaments"], --Coldheart Ascendant
	[156226] = PowerNames["Dark Armaments"], --Coldheart Binder
	[156213] = PowerNames["Dark Armaments"], --Coldheart Guardian
	[156159] = PowerNames["Dark Armaments"], --Coldheart Javelineer
	[156219] = PowerNames["Dark Armaments"], --Coldheart Scout

--Upper Reaches
	[152708] = PowerNames["Maw Seeker Harness"], --Mawsworn Seeker
	[155790] = PowerNames["Marrow Scooper"], --Mawsworn Acolyte
	[155830] = PowerNames["Marrow Scooper"], --Mawsworn Disciple
	[157810] = PowerNames["Marrow Scooper"], --Mawsworn Endbringer
	[155949] = PowerNames["Marrow Scooper"], --Mawsworn Soulbinder
	[155831] = PowerNames["Marrow Scooper"], --Mawsworn Soulbinder
	[157809] = PowerNames["Marrow Scooper"], --Mawsworn Darkcaster
	[155812] = PowerNames["Marrow Scooper"], --Mawsworn Ritualist
	[155824] = PowerNames["Marrow Scooper"], --Lumbering Creation
	[155793] = PowerNames["Skeletal Ward"], --Skeletal Remains
	[150958] = PowerNames["Warden's Authority"], --Mawsworn Guard
	[153874] = PowerNames["Warden's Authority"], --Mawsworn Sentry

--Mort'Regar
	[151816] = PowerNames["Deadsoul Hound Harness"], --Deadsoul Scavenger
	[152644] = PowerNames["Purifier's Flame"], --Deadsoul Drifter
	[151815] = PowerNames["Purifier's Flame"], --Deadsoul Echo
	[151816] = PowerNames["Purifier's Flame"], --Deadsoul Scavenger
	[151814] = PowerNames["Purifier's Flame"], --Deadsoul Shade
    [153879] = PowerNames["Purifier's Flame"], --Deadsoul Shadow
    [153885] = PowerNames["Purifier's Flame"], --Deadsoul Shambler
    [153882] = PowerNames["Purifier's Flame"], --Deadsoul Spirit
    [153552] = PowerNames["Purifier's Flame"], --Weeping Wraith

	--[162661] = PowerNames["Shackle Keys"], --Mawsworn Ward
	

	--FaeInvader
	[155225] = PowerNames["Glasswing Charm"], --Faeleaf Grovesinger
	[155221] = PowerNames["Glasswing Charm"], --Faeleaf Tender
	[155216] = PowerNames["Glasswing Charm"], --Faeleaf Warden
	[155226] = PowerNames["Glasswing Charm"], --Verdant Keeper
	[155215] = PowerNames["Glasswing Charm"], --Faeleaf Lasher
	[155211] = PowerNames["Glasswing Charm"], --Gormling Pest
	[155219] = PowerNames["Glasswing Charm"], --Gormling Spitter
	
	--Elementals
	[154128] = PowerNames["Flamestarved Cinders"], --Blazing Elemental
	[154129] = PowerNames["Flamestarved Cinders"], --Burning Emberguard
	
	--Prisoner
	[154011] = PowerNames["Prisoner's Concord"], --Armed Prisoner
	[154015] = PowerNames["Prisoner's Concord"], --Escaped Ritualist
	[154014] = PowerNames["Prisoner's Concord"], --Imprisoned Cabalist
	[154020] = PowerNames["Prisoner's Concord"], --Prisonbreak Cursewalker
	[154018] = PowerNames["Prisoner's Concord"], --Prisonbreak Mauler
	[154016] = PowerNames["Prisoner's Concord"], --Prisonbreak Soulmender	

	--Misc
	[164897] =  PowerNames["Pouch of Phantasma"], --Fog Dweller		
}

addon.ZoneList = {
	[L["All Wings"]] = {151353,154030,152594,170257,155798,},
	[L["Skoldus Hall"]] = {152708,153878,150959,150958,153874,},
	[L["Fracture Chambers"]] = {155790,155830,157810,155949,157809,155812,155824,155793,157819,},
	[L["Soulforges"]] = {157584,157583,157572,157571,152708,153878,157634,150958,153874,},
	[L["Coldheart Interstitia"]] = {156212,165594,156157,156226,156213,156159,156219,},
	[L["Upper Reaches"]] = {152708,155790,155830,157810,155949,157809,155812,155824,155793,150958,153874,},
	[L["Mort'Regar"]] = {151816,152644,151815,151816,151814,153879,153885,153882,153552,162661,},
	[L["Fae Invader"]] = {155225,155221,155216,155226,155215,155211,155219,},
	[L["Elementals"]] = {154128,154129,},
	[L["Prisoner"]] = {154011,154015,154014,154020,154018,154016,},
}

addon.RareIDs = {
	[173134] = {PowerNames["Fallen Armaments"], PowerNames["Dark Fortress"]}, --Darksworn Goliath
	[173114] = {PowerNames["Pulsing Rot-hive"], PowerNames["Swarm Form"]}, --Invasive Decayfly
	[156134] = {PowerNames["Spectral Oats"], PowerNames["Spectral Bridle"]}, --Ghastly Charger
	[170385] = {PowerNames["Resonating Effigy"], PowerNames["Ephemeral Effigy"]}, --Writhing Misery
	[152508] = {PowerNames["Tremorbeast Tusk"], PowerNames["Tremorbeast Heart"]}, --Dusky Tremorbeast
	[173191] = {PowerNames["Soulward Clasp"], PowerNames["V'lara's Cape of Subterfuge"]}, --Soulstalker V'lara
	[156158] = {PowerNames["Dark Fortress"], PowerNames["Fallen Armaments"]}, --Adjutant Felipos
	[170414] = {PowerNames["Erratic Howler"], PowerNames["Unstable Form"]}, --Howling Spectre
	[170417] = {PowerNames["Fractured Phantasma Lure"], PowerNames["Reinforced Lure Casing"]}, --Animated Stygia
	[156142] = {PowerNames["Frostbite Wand"], PowerNames["Icy Heartcrust"]}, --Icy Heartcrust
	[152517] = {PowerNames["Vitality Guillotine"], PowerNames["Blade of the Lifetaker"]}, --Deadsoul Lifetaker
	[152612] = {PowerNames["Vial of Lost Potential"], PowerNames["Subjugator's Manacles"]}, --Subjugator Klontzas
	[155483] = {PowerNames["Shimmering Wingcape"], PowerNames["Irritating Moth Dust"]}, --Faeleaf Shimmerwing
	[173051] = {PowerNames["Elongated Skeletal Arms"], PowerNames["Coffer of Spectral Whispers"]}, --Suppressor Xelsor
	[156237] = {PowerNames["Fallen Armaments"], PowerNames["Dark Fortress"]}, --Imperator Dara
	[169823] = {PowerNames["Lumbering Form"], PowerNames["Potent Acid Gland"],}, -- PowerNames["Obleron Endurance x3"]}, --Gorm Behemoth
}

addon.Upgrades = {
	[184620] = {347111, 63202},-- vessel-of-unfortunate-spirits
	[184615] = {347107, 63202}, --extradimensional-pockets
	[184617] = {347108, 63193}, --bangle-of-seniority
	[184621] = {347113, 63204}, --ritual-prism-of-fortune
	[184619] = {347109, 63201}, --loupe-of-unusual-charm
	[184618] = {347110, 63200}, --rank-insignia-acquisitionist
	[180952] = {342815, 61144}, --Possibility Matrix
}
--C_QuestLog.IsQuestFlaggedCompleted(61144)