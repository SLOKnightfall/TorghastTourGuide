--  ///////////////////////////////////////////////////////////////////////////////////////////
--
--   
--  Author: SLOKnightfall

--  

--

--  ///////////////////////////////////////////////////////////////////////////////////////////

local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


local debug = false
local Stats = addon.Stats


function Stats:ResetCurrent()
	addon.Statsdb.profile.current = addon.Stats.ResetCounts()
end


function Stats:ResetAll()
	addon.Statsdb.profile.current = addon.Stats.ResetCounts()
	addon.Statsdb.profile.total = addon.Stats.ResetCounts()
	addon.Statsdb.profile.current.CurentTime = GetTime()
end


local function FindTime()
	local inTorghast = IsInJailersTower()
	if not inTorghast then return end
	local start = addon.Statsdb.profile.current.CurentTime or GetTime()
	local current = GetTime()
	local seconds = current - start

	addon.Statsdb.profile.current.Time = seconds
	addon.Statsdb.profile.total.CurrentTime = addon.Statsdb.profile.total.Time + seconds
end


local function convertTime(seconds)
	if seconds <= 0 then
		return "00:00:00";
	else
		hours = string.format("%02.f", math.floor(seconds/3600));
		mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
		secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
		return hours..":"..mins..":"..secs
	end
end


function Stats:UpdateStats()
	local f = addon.Stats.Frame
	if not f then return end
	local current = addon.Statsdb.profile.current
	local total = addon.Statsdb.profile.total
	FindTime()
	local currentTime = convertTime(current.Time)
	local totalTime = convertTime(total.CurrentTime)
	
	f.currentTimeCount:SetText((L["%sTime Spent: %s"]):format("", currentTime))
	f.currentFloorCount:SetText((L["%sFloors Climbed: %s"]):format("", current.FloorsCompleted))
	f.currentCompleteCount:SetText((L["%sSuccessful Runs: %s"]):format("", current.RunsCompleted))
	f.currentPhantasmaCount:SetText((L["%sPhantasma Collected: %s"]):format("", current.Phantasma))
	f.currentAnimaCount:SetText((L["%sAnima Powers Collected: %s"]):format("", current.AnimaPowers))
	f.currentSoulsCount:SetText((L["%sSouls Collected: %s"]):format("", current.SoulsSaved))
	f.currentQuestCount:SetText((L["%sQuests Completed: %s"]):format("", current.QuestsCompleted))
	f.currentChestCount:SetText((L["%sChests Opened: %s"]):format("", current.Chests))
	f.currentDeathCount:SetText((L["%sDeaths: %s"]):format("", current.Deaths))
	f.currentTrapsCount:SetText((L["%sTraps Sprung: %s"]):format("", current.TrapSprung))
	f.currentgrueCount:SetText((L["%sTimes Tarragrue Released: %s"]):format("", current.Grue))
	f.currentkillCount:SetText((L["%sMobs Killed: %s"]):format("", current.MobsKilled))
	f.currentKillBreakdown:SetText((L["Bosses: %s - Rares: %s - Mawrats: %s"]):format(current.Bosses, current.Rares, current.Mawrats))
	f.currentpotsCount:SetText((L["%sAshen Phylactery Broken: %s"]):format("", current.JarsBroken))

	f.totalTimeCount:SetText((L["%sTime Spent: %s"]):format(L["Total "], totalTime))
	f.totalFloorCount:SetText((L["%sFloors Climbed: %s"]):format(L["Total "], total.FloorsCompleted))
	f.totalCompleteCount:SetText((L["%sSuccessful Runs: %s"]):format(L["Total "], total.RunsCompleted))
	f.totalPhantasmaCount:SetText((L["%sPhantasma Collected: %s"] ):format(L["Total "], total.Phantasma))
	f.totalAnimaCount:SetText((L["%sAnima Powers Collected: %s"]):format(L["Total "], total.AnimaPowers))
	f.totalSoulsCount:SetText((L["%sSouls Collected: %s"]):format(L["Total "], total.SoulsSaved))
	f.totalChestCount:SetText((L["%sChests Opened: %s"]):format(L["Total "], total.Chests))
	f.totalQuestCount:SetText((L["%sQuests Completed: %s"]):format(L["Total "], total.QuestsCompleted))
	f.totalDeathCount:SetText((L["%sDeaths: %s"]):format(L["Total "], total.Deaths))
	f.totalTrapsCount:SetText((L["%sTraps Sprung: %s"]):format(L["Total "], total.TrapSprung))
	f.totalgrueCount:SetText((L["%sTimes Tarragrue Released: %s"]):format(L["Total "], total.Grue))
	f.totalkillCount:SetText((L["%sMobs Killed: %s"]):format(L["Total "], total.MobsKilled))
	f.totalKillBreakdown:SetText((L["Bosses: %s - Rares: %s - Mawrats: %s"]):format(total.Bosses, total.Rares, total.Mawrats))
	f.totalpotsCount:SetText((L["%sAshen Phylactery Broken: %s"]):format(L["Total "], total.JarsBroken))
end


function Stats:InitRun()
	Stats:ResetCurrent()
	addon.Statsdb.profile.current.CurentTime = GetTime()
	Stats:UpdateStats()
end


function Stats:SetPhantasma(quantity)
	if not IsInJailersTower() then return end

	local current = addon.Statsdb.profile.current
	local total = addon.Statsdb.profile.total

	current.Phantasma = current.Phantasma + quantity
	total.Phantasma = total.Phantasma + quantity

	Stats:UpdateStats()
end


local MAW_BUFF_MAX_DISPLAY = 44;
function Stats:AnimaGain()
	if not IsInJailersTower() then return end
	local current = addon.Statsdb.profile.current
	local total = addon.Statsdb.profile.total
	local totalCount = 0
	local diff = 0

	for i=1, MAW_BUFF_MAX_DISPLAY do
		local _, icon, count, _, _, _, _, _, _, spellID = UnitAura("player", i, "MAW");
		if icon then
			if count == 0 then
				count = 1;
			end
			totalCount = totalCount + count;
		end
	end
	diff = totalCount - current.AnimaPowers
	current.AnimaPowers = totalCount

	if diff > 0 then 
		total.AnimaPowers = total.AnimaPowers + diff
	end
	Stats:UpdateStats()
end


function Stats.IncreaseCounter(type)
	if not IsInJailersTower() then return end
	local current = addon.Statsdb.profile.current
	local total = addon.Statsdb.profile.total

	current[type] = current[type] + 1
	total[type] = total[type] + 1

	Stats:UpdateStats()
end