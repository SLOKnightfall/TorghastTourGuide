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
--achievement=14778/extremely-ravenous
	["Broker's Purse"] = 305308,
	["Mawrat Harness"] = 342780,
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
	["Pouch of Phantasma"] = 295072,
}

addon.PowerNames = PowerNames

addon.mobs = {
--All Wings
	[151353] = PowerNames["Mawrat Harness"], --Mawrat
	[154030] = PowerNames["Mawrat Harness"], --Oddly Large Mawrat
	[152594] = PowerNames["Broker's Purse"], --Broker Ve'ken
	[170257] = PowerNames["Broker's Purse"], --Broker Ve'nott
	[155798] = PowerNames["Shackle Keys"], --Mawsworn Shackler
	[150965] = PowerNames["Shackle Keys"], --Mawsworn Shackler
	[171172] = PowerNames["Shackle Keys"], --Mawsworn Shackler
	[152661] = PowerNames["Pouch of Phantasma"],--mawsworn-ward
	[165060] = PowerNames["Pouch of Phantasma"],--animimic
	[170419] = PowerNames["Pouch of Phantasma"], --lost-dredger
    [160161] = PowerNames["Pouch of Phantasma"],--fog-dweller
    [164897] = PowerNames["Pouch of Phantasma"],--fog-dweller
	
--Skoldus Hall
	[152708] = PowerNames["Maw Seeker Harness"], --Mawsworn Seeker
	[153878] = PowerNames["Pocketed Soulcage"], --Mawsworn Archer
	[150959] = PowerNames["Pocketed Soulcage"], --Mawsworn Interceptor
	[150958] = PowerNames["Warden's Authority"], --Mawsworn Guard
	[153874] = PowerNames["Warden's Authority"], --Mawsworn Sentry

--Fractured Chambers
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
	[151814] = PowerNames["Purifier's Flame"], --Deadsoul Shade
    [153879] = PowerNames["Purifier's Flame"], --Deadsoul Shadow
    [153885] = PowerNames["Purifier's Flame"], --Deadsoul Shambler
    [153882] = PowerNames["Purifier's Flame"], --Deadsoul Spirit
    [153552] = PowerNames["Purifier's Flame"], --Weeping Wraith

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
}


addon.ZoneList = {
	{L["All Wings"],{151353,154030,152594,170257,155798,152661,165060,170419,160161},},
	{L["Skoldus Hall"], {152708,153878,150959,150958,153874,},},
	{L["Fractured Chambers"],{155790,155830,157810,155949,157809,155812,155824,155793,157819,},},
	{L["Soulforges"], {157584,157583,157572,157571,152708,153878,157634,150958,153874,},},
	{L["Coldheart Interstitia"], {156212,165594,156157,156226,156213,156159,156219,},},
	{L["Upper Reaches"], {152708,155790,155830,157810,155949,157809,155812,155824,155793,150958,153874,},},
	{L["Mort'Regar"], {151816,152644,151815,151814,153879,153885,153882,153552,162661,},},
	{L["Fae Invader"] ,{155225,155221,155216,155226,155215,155211,155219,},},
	{L["Elementals"],{154128,154129,},},
	{L["Prisoner"],{154011,154015,154014,154020,154018,154016,},},
	}


local RarePowerNames = {
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
	["The Fifth Skull"] = 337657,
	["Brittle Bone Dust"] = 337645,
	["Potent Acid Gland"] = 337928,
	["Overgrowth Seedling"] = 338705,
	["Ever-Beating Heart"] = 338733,
}


addon.RareIDs = {
	[152500] = {97777,{0}}, --Deadsoul Amalgam
	[173080] = {96338,{0}}, --Wandering Death
	[173238] = {98490,{RarePowerNames["Resonating Effigy"], RarePowerNames["Ephemeral Effigy"]}}, --Deadsoul Strider
	[152612] = {100485,{RarePowerNames["Vial of Lost Potential"], RarePowerNames["Subjugator's Manacles"]}}, --Subjugator Klontzas
	[152508] = {100490,{RarePowerNames["Tremorbeast Tusk"], RarePowerNames["Tremorbeast Heart"]}}, --Dusky Tremorbeast
	[173051] = {97235,{RarePowerNames["Elongated Skeletal Arms"], RarePowerNames["Coffer of Spectral Whispers"]}}, --Suppressor Xelsor
	[156134] = {97041,{RarePowerNames["Spectral Oats"], RarePowerNames["Spectral Bridle"]}}, --Ghastly Charger
	[170417] = {88739,{RarePowerNames["Fractured Phantasma Lure"], RarePowerNames["Reinforced Lure Casing"]}}, --Animated Stygia
	[155483] = {95199,{RarePowerNames["Shimmering Wingcape"], RarePowerNames["Irritating Moth Dust"]}}, --Faeleaf Shimmerwing
	[170228] = {94814,{RarePowerNames["The Fifth Skull"], RarePowerNames["Brittle Bone Dust"]}}, --Bone Husk
	[169823] = {94207,{RarePowerNames["Lumbering Form"], RarePowerNames["Potent Acid Gland"],}}, -- PowerNames["Obleron Endurance x3"]}, --Gorm Behemoth
	[173114] = {18722,{RarePowerNames["Pulsing Rot-hive"], RarePowerNames["Swarm Form"]}}, --Invasive Decayfly
	[173136] = {98171,{RarePowerNames["Overgrowth Seedling"], RarePowerNames["Ever-Beating Heart"]}}, --blightsmasher
	[170414] = {88583,{RarePowerNames["Erratic Howler"], RarePowerNames["Unstable Form"]}}, --Howling Spectre
	[173191] = {92415,{RarePowerNames["Soulward Clasp"], RarePowerNames["V'lara's Cape of Subterfuge"]}}, --Soulstalker V'lara
	[152517] = {90427,{RarePowerNames["Vitality Guillotine"], RarePowerNames["Blade of the Lifetaker"]}}, --Deadsoul Lifetaker
	[156158] = {93906,{RarePowerNames["Dark Fortress"], RarePowerNames["Fallen Armaments"]}}, --Adjutant Felipos
	[173134] = {92664,{RarePowerNames["Fallen Armaments"], RarePowerNames["Dark Fortress"]}}, --Darksworn Goliath
	[156237] = {94919,{RarePowerNames["Fallen Armaments"], RarePowerNames["Dark Fortress"]}}, --Imperator Dara
	[170385] = {94278,{RarePowerNames["Resonating Effigy"], RarePowerNames["Ephemeral Effigy"]}}, --Writhing Misery
	[156142] = {98720,{RarePowerNames["Frostbite Wand"], RarePowerNames["Icy Heartcrust"]}}, --Seeker of Souls
}


	--[156239] = {L["156239"],93489,{304948,304946,345554}}, --Dark Ascended Corrus



addon.Upgrades = {
	[184620] = {347111, 63202},-- vessel-of-unfortunate-spirits
	[184615] = {347107, 63183}, --extradimensional-pockets
	[184617] = {347108, 63193}, --bangle-of-seniority
	[184621] = {347113, 63204}, --ritual-prism-of-fortune
	[184619] = {347109, 63201}, --loupe-of-unusual-charm
	[184618] = {347110, 63200}, --rank-insignia-acquisitionist
	[180952] = {342815, 61144}, --Possibility Matrix
	[184901] = {349397, 63523}, --broker-traversal-enhancer
}
--C_QuestLog.IsQuestFlaggedCompleted(61144)