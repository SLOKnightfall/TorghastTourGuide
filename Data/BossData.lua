local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

addon.Bosses ={
	[156239] = {L[156239],93489}, --Dark Ascended Corrus
	[170418] = {L[170418],93853}, --Goxul the Devourer
	[153165] = {L[153165],100473}, --Custodian Thonar
	[156015] = {L[156015],100474}, --Writhing Soulmass
	[153382] = {L[153382],100530}, --Maw of the Maw
	[159755] = {L[159755],100480}, --The Grand Malleare
	[151331] = {L[151331],100478}, --Cellblock Sentinel
	[153011] = {L[153011],97776}, --Binder Baritas
	[159190] = {L[159190],92785}, --Synod
	[153174] = {L[153174],97777}, --Watchers of Death
	[155250] = {L[155250],94412}, --Decayspeaker
	[171422] = {L[171422],97237}, --Arch-Suppressor Laguas
	[169859] = {L[169859],97075}, --Observer Zelgar
	[151329] = {L[151329],92411}, --Warden Skoldus
	[153451] = {L[153451],100476}, --Kosarus the Fallen
	[155945] = {L[155945],100477}, --Gherus the Chained
	[152995] = {L[152995],93213}, --Warden of Souls
	[157122] = {L[157122],92919}, --Patrician Cromwell
	[155251] = {L[155251],93976}, --Elder Longbranch
}