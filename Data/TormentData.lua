local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--GetMawPowerLinkBySpellID(305308)
--GetSpellDescription(304918)
--GetSpellInfo(305308) 
--FindBaseSpellByID(305308)
--/script DEFAULT_CHAT_FRAME:AddMessage("\124cffffd000\124Hspell:305308\124h[Broker's Purse]\124h\124r");
local TormentNames = {
--Ravenous
--achievement=14778/extremely-ravenous
	["Avenger"] = 352783,
	["Backup"] = 354328,
	["Claustrophobic"] = 353059,
	["Hardened"] = 354003,
	["Lockdown"] = 355153,
	["Raging"] = 304918,
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
	[352783] = {L["Avenger_Tip"]}, --Dark Ascended Corrus
	[354328] = {L["Backup_Tip"]}, --Goxul the Devourer
	[353059] = {L["Claustrophobic_Tip"]}, --Custodian Thonar
	[354003] = {L["Hardened_Tip"]}, --Writhing Soulmass
	[355153] = {L["Lockdown_Tip"]}, --Maw of the Maw
	[304918] = {L["Raging_Tip"]}, --The Grand Malleare
	[353949] = {L["Reinforced: Commanding_Tip"]}, --Cellblock Sentinel
	[353757] = {L["Reinforced: Doom Conduits_Tip"]}, --Binder Baritas
	[355239] = {L["Reinforced: Follower of Klontzas_Tip"]}, --Synod
	[353861] = {L["Reinforced: Reflective_Tip"]}, --Watchers of Death
	[351725] = {L["Reinforced: Unstoppable_Tip"]}, --Decayspeaker
	[351809] = {L["Supernatural Power_Tip"]}, --Arch-Suppressor Laguas
	[353119] = {L["Thanatophobia_Tip"]}, --Observer Zelgar
	[354491] = {L["Tricks and Traps_Tip"]}, --Warden Skoldus
	[352027] = {L["Twisted Magic_Tip"]}, --Kosarus the Fallen
	[352049] = {L["Twisted Strength_Tip"]}, --Gherus the Chained
	[350188] = {L["Unstable Phantasma_Tip"]}, --Warden of Souls
	[352234] = {L["Volatile Doom_Tip"]}, --Patrician Cromwell
}