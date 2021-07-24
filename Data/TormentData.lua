local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--GetMawPowerLinkBySpellID(305308)
--GetSpellDescription(304918)
--GetSpellInfo(305308) 
--FindBaseSpellByID(305308)
--/script DEFAULT_CHAT_FRAME:AddMessage("\124cffffd000\124Hspell:305308\124h[Broker's Purse]\124h\124r");
local TormentNames = {
	{["Avenger"] = 352783,},
	{["Backup"] = 354328,},
	{["Claustrophobic"] = 353059,},
	{["Hardened"] = 354003,},
	{["Lockdown"] = 355153},
	{["Raging"] = 304918,},
	{["Reinforced: Commanding"] = 353949,},
	{["Reinforced: Doom Conduits"] = 353757,},
	{["Reinforced: Follower of Klontzas"] = 355239,},
	{["Reinforced: Reflective"] = 353861,},
	{["Reinforced: Unstoppable"] = 351725,},
	{["Supernatural Power"] = 351809,},
	{["Thanatophobia"] = 353119,},
	{["Tricks and Traps"] = 354491,},
	{["Twisted Magic"] = 352027,},
	{["Twisted Strength"] = 352049,},
	{["Unstable Phantasma"] = 350188,},
	{["Volatile Doom"] = 352234,},

}

addon.TormentNames = TormentNames

addon.TormentTips = {
	[352783] = {L["Avenger_Tip"]},
	[354328] = {L["Backup_Tip"]}, 
	[353059] = {L["Claustrophobic_Tip"]}, 
	[354003] = {L["Hardened_Tip"]}, 
	[355153] = {L["Lockdown_Tip"]}, 
	[304918] = {L["Raging_Tip"]}, 
	[353949] = {L["Reinforced: Commanding_Tip"]}, 
	[353757] = {L["Reinforced: Doom Conduits_Tip"]},
	[355239] = {L["Reinforced: Follower of Klontzas_Tip"]}, 
	[353861] = {L["Reinforced: Reflective_Tip"]},
	[351725] = {L["Reinforced: Unstoppable_Tip"]}, 
	[351809] = {L["Supernatural Power_Tip"]}, 
	[353119] = {L["Thanatophobia_Tip"]}, --
	[354491] = {L["Tricks and Traps_Tip"]},
	[352027] = {L["Twisted Magic_Tip"]}, --
	[352049] = {L["Twisted Strength_Tip"]}, 
	[350188] = {L["Unstable Phantasma_Tip"]}, 
	[352234] = {L["Volatile Doom_Tip"]}, 
}




addon.BlessingNames = {
	{["Advantage"] = 353566,},
	{["Anima Hoarder"] = 351828,},
	{["Armed"] = 350079,},
	{["Challenge Slayer"] = 350871,},
	{["Chaotic Concoctions"] = 351866,},
	{["Cursed Souls"] = 351752,},
	{["Diminishing Blows"] = 351550,},
	{["Phantastic"] = 350127,},
	{["Rampage"] = 352260,},
	{["Resilient"] = 355047,},
	{["Shoplifter"] = 353145,},
	{["Surging Power"] = 353234,},
}


addon.BlessingTips = {
	[353566] = {L["Advantage_Tip"]},
	[351828] = {L["Anima Hoarder_Tip"]}, 
	[350079] = {L["Armed_Tip"]}, 
	[350871] = {L["Challenge Slayer_Tip"]}, 	
	[351866] = {L["Chaotic Concoctions_Tip1"], L["Chaotic Concoctions_Tip2"], L["Chaotic Concoctions_Tip3"], L["Chaotic Concoctions_Tip4"]}, 
	[351752] = {L["Cursed Souls_Tip"]}, 
	[351550] = {L["Diminishing Blows_Tip"]}, 
	[350127] = {L["Phantastics_Tip"], L["Phantastics_Tip2"]},
	[352260] = {L["Rampage_Tip"]}, 
	[355047] = {L["Resilient_Tip"]},
	[353145] = {L["Shoplifter"], L["Shoplifter2"], L["Shoplifter3"], L["Shoplifter4"]}, 
	[353234] = {L["Surging Power_Tip"]}, 
}



local TalentNames = {
	["Blessing of the Ancients - Rank 1"] = 352105,
	["Blessing of the Ancients - Rank 2"] = 352106,
	["Blessing of the Ancients - Rank 3"] = 353059,
	["Empowered Swiftness - Rank 1"] = 354809,
	["Empowered Swiftness - Rank 2"] = 354810,
	["Efficient Looter"] = 355141,
	["Reinforced: Commanding"] = 353949,
	["Reinforced: Doom Conduits"] = 353757,
	["Reinforced: Follower of Klontzas"] = 355239,
	["Reinforced: Reflective"] = 353861,
	["Reinforced: Unstoppable"] = 351725,
	["Supernatural Power"] = 351809,
	["Thanatophobia"] = 353119,
	["Tricks and Traps"] = 354491,
	["Twisted Magic"] = 352027,
	["Twisted Strength"] = 352049,
	["Unstable Phantasma"] = 350188,
	["Volatile Doom"] = 352234,

}

addon.TormentNames = TormentNames

addon.TormentTips = {
	[352783] = {L["Avenger_Tip"]},
	[354328] = {L["Backup_Tip"]}, 
	[353059] = {L["Claustrophobic_Tip"]}, 
	[354003] = {L["Hardened_Tip"]}, 
	[355153] = {L["Lockdown_Tip"]}, 
	[304918] = {L["Raging_Tip"]}, 
	[353949] = {L["Reinforced: Commanding_Tip"]}, 
	[353757] = {L["Reinforced: Doom Conduits_Tip"]},
	[355239] = {L["Reinforced: Follower of Klontzas_Tip"]}, 
	[353861] = {L["Reinforced: Reflective_Tip"]},
	[351725] = {L["Reinforced: Unstoppable_Tip"]}, 
	[351809] = {L["Supernatural Power_Tip"]}, 
	[353119] = {L["Thanatophobia_Tip"]}, --
	[354491] = {L["Tricks and Traps_Tip"]},
	[352027] = {L["Twisted Magic_Tip"]}, --
	[352049] = {L["Twisted Strength_Tip"]}, 
	[350188] = {L["Unstable Phantasma_Tip"]}, 
	[352234] = {L["Volatile Doom_Tip"]}, 
}