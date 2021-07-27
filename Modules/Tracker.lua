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
addon.Tracker = {}


--local current = addon.Statsdb.profile.current

--[[Annihilator	Floor 5 boss killed in under 20 seconds	20 --Check floor 5. start timer on combat start.  Check time when combat ends
Collector	Collect at least 30 Anima Powers	10  --Check animia power count
Daredevil	Defeat 2 Elites within 10 seconds of each other	10
Executioner	Floor 5 boss killed in under 40 seconds	10 -- Check floor 5. start timer on combat start.  Check time when combat ends
Highlander	No duplicate Anima Powers	15
Hoarder	Defeat the floor 5 boss with at least 500 Phantasma remaining
(Note: Phantasma required will scale up per member of your party!)	10
Hunter	No elite enemies reached 4 stacks of Unnatural Power	15
Pauper	No epic Anima Powers	10
Pillager	90% of Ashen Phylacteries destroyed	5 --cant track
Plunderer	Opened treasure chests	5  --Use stats tracker
Reinforced	Collect at least 5 Obleron Armaments of the same type	10
Rescuer	Assisted a denizen of Torghast	10  --check for quest compl;ete
Robber	Robbed a Broker (Requires Shoplifter blessing active OR usage of a Ravenous Anima Cell)	5  --check for killing mob or for drop
Savior	All Soul Remnants freed	10  -Cant Track
Trapmaster	No trap damage taken  --Use trap damage tracker 



annihilator & executioner  



]]

TTG_TimerMixin = {}

local combatTimer = 0
function TTG_TimerMixin:Show()
end

function TTG_TimerMixin:Hide()
end

function TTG_TimerMixin:Reset()
end

function TTG_TimerMixin:Start()
end

function TTG_TimerMixin:Stop()
end

function TTG_TimerMixin:Update()
end


local MAW_BUFF_MAX_DISPLAY = 44;


local bounses = {
	["Annihilator"] = {nil,20},
	["Collector"] = {nil,10},
	["Daredevil"] = {nil,10},
	["Executioner"] = {nil,10},
	["Highlander"] = {true,15},
	["Hoarder"] = {nil,10},
	["Hunter"] = {nil,15},
	["Pauper"] = {true,10},
	["Pillager"] = {nil,5, true}, --cant track
	["Plunderer"] = {nil,5},  --Use stats tracker
	["Reinforced"] = {nil,10},
	["Rescuer"] = {nil,10},  --check for quest compl;ete
	["Robber"] = {nil,5},  --check for killing mob or for drop
	["Savior"] = {nil,10, true}, --Cant Track
	["Trapmaster"] = {true,10},--Use trap damage tracker 
}

local bonusList = {
"Annihilator",
"Collector",
"Daredevil",
"Executioner",
"Highlander",
"Hoarder",
"Hunter",
"Pauper",
"Pillager",
"Plunderer",
"Reinforced",
"Rescuer",
"Robber",
"Savior",
"Trapmaster",
}


--TODO make persistent on reload

--[[
statsDefaults.profile. bounses = {
	["Annihilator"] = {nil,20},
	["Collector"] = {nil,10},
	["Daredevil"] = {nil,10},
	["Executioner"] = {nil,10},
	["Highlander"] = {nil,15},
	["Hoarder"] = {nil,10},
	["Hunter"] = {nil,15},
	["Pauper"] = {nil,10},
	["Pillager"] = {nil,5}, --cant track
	["Plunderer"] = {nil,5},  --Use stats tracker
	["Reinforced"] = {nil,10},
	["Rescuer"] = {nil,10},  --check for quest compl;ete
	["Robber"] = {nil,5},  --check for killing mob or for drop
	["Savior"] = {nil,10}, --Cant Track
	["Trapmaster"] = {nil,10},--Use trap damage tracker 
}]]

function addon.CheckAnimaPowers(spellID)
	if bounses.Highlander then 
		for i=1, MAW_BUFF_MAX_DISPLAY do
			local _, icon, count, _, _, _, _, _, _, maw_spellID = UnitAura("player", i, "MAW");
			if icon and spellID == maw_spellID then
				if count == 1 then
					return true
				else
					return false 
				end
			end
		end
	end
end
local GREEN_FONT_COLOR = GREEN_FONT_COLOR:GenerateHexColorMarkup()
local RED_FONT_COLOR = RED_FONT_COLOR:GenerateHexColorMarkup()
local ORANGE_FONT_COLOR = ORANGE_FONT_COLOR:GenerateHexColorMarkup()

local YELLOW_FONT_COLOR = YELLOW_FONT_COLOR:GenerateHexColorMarkup()





function addon.CheckAnimaRarity(spellRarity)
	return bounses.Pauper and spellRarity >= Enum.PlayerChoiceRarity.Epic
end


function addon.Tracker:FlagFail(bonusName)
	if bounses[bonusName] then 
		print(RED_FONT_COLOR..(L["Failed Bouns: %s"]):format(bonusName))
	end

	bounses[bonusName][1] = false
	bounses[bonusName][2] = 0
	initBonusList()
end



function addon.Tracker:FlagBonus(bonusName)
	if bounses[bonusName] then 
		print(GREEN_FONT_COLOR..(L["Gained Bouns: %s"]):format(bonusName))
	end

	bounses[bonusName][1] = true
	initBonusList()
end


local function checkBonusStatus(bonusName)
	return bounses[bonusName][1] ~= false
end



local function GetHoarderTotal()
	local total = 500 * GetNumGroupMembers()
	return total
end

function addon.Tracker:CombatBonusChecks()

	if combatTimer > 40 then
		addon.Tracker:FlagFail("Executioner")
	elseif combatTimer > 20 then
		addon.Tracker:FlagFail("Annihilator")
	end

--TODO:  Figure group scaleing
	if addon:CurrentFloor() == 5 and addon:CurrentPhantasma() > 500 then 
		addon.Tracker:FlagBonus("Hoarder")
	end

end

function addon.Tracker:CheckBouns()
	local totalPowers = 0
	for i=1, MAW_BUFF_MAX_DISPLAY do
		local _, icon, count, _, _, _, _, _, _, maw_spellID = UnitAura("player", i, "MAW");
		totalPowers = totalPowers + (count or 0)
		if icon and spellID == maw_spellID then
			if checkBonusStatus("Highlander") and count > 1 then
				addon.Tracker:FlagFail("Highlander")
			end
		end

		if icon and maw_spellID and bounses.Pauper then
			local spellRarity = C_Spell.GetMawPowerBorderAtlasBySpellID(maw_spellID)
			if checkBonusStatus("Pauper") and spellRarity == "jailerstower-animapowerlist-powerborder-purple"  then
				addon.Tracker:FlagFail("Pauper")
			end
		end
	end


	local currentStats = addon.Statsdb.profile.current
	if checkBonusStatus("Trapmaster")  and currentStats.TrapSprung > 0 then
		addon.Tracker:FlagFail("Trapmaster")
	end

	if not checkBonusStatus("Rescuer") and currentStats.QuestsCompleted > 0 then
		addon.Tracker:FlagBonus("Rescuer")
	end

	if not checkBonusStatus("Plunderer")  and currentStats.Chests > 0 then
		addon.Tracker:FlagFail("Plunderer")
	end

	if not checkBonusStatus("Collector")  and totalPowers >= 20 then
		addon.Tracker:FlagBonus("Collector")
	end

	addon.InitScoreFrame()
end



--[[
Daredevil	Defeat 2 Elites within 10 seconds of each other	10
Hunter	No elite enemies reached 4 stacks of Unnatural Power	15
Reinforced	Collect at least 5 Obleron Armaments of the same type	10
Robber	Robbed a Broker (Requires Shoplifter blessing active OR usage of a Ravenous Anima Cell)	5  --check for killing mob or for drop
]]--


function bb()
	for i, name in ipairs(bonusList) do
		if (bounses[name]) then
			
			--print(bounses[name])
			local status = bounses[name][1]
			local pts = bounses[name][2]
			local color = YELLOW_FONT_COLOR
			if status == true then
				color = GREEN_FONT_COLOR
			elseif status == false then 
				color = RED_FONT_COLOR
			end


			print(color..name)
		else
			print(name)
		end
	end

end

local function checkBonusStatus(bonusName)
	return bounses[bonusName][1] ~= false
end

function addon.Tracker:GetBounsScore()
	local bonus = 0
	for i, name in ipairs(bonusList) do
		if (bounses[name]) then		
			--print(bounses[name])
			local status = bounses[name][1]
			local pts = bounses[name][2]
			if status == true then
				bonus = bonus + pts
			end
		end
	end

	return bonus
end

function addon.InitScoreFrame()
	local currentStats = addon.Statsdb.profile.current
	local deaths = currentStats.Deaths
	local DeathPenalty = deaths * -20
	local bonus = addon.Tracker:GetBounsScore()
	local completion = 100
	local total = completion + bonus + DeathPenalty
	--TTGScenarioStageBlock:Show()
	TTGScenarioStageBlock.DeathCount:SetText(deaths)
	if deaths > 0 then 
		TTGScenarioStageBlock.DeathPenalty:SetText(("(%s)"):format(DeathPenalty))
	else
		TTGScenarioStageBlock.DeathPenalty:SetText("")
	end
	TTGScenarioStageBlock.Score:SetText(L["Score:"])
	TTGScenarioStageBlock.ScoreTotal:SetText(total)
	TTGScenarioStageBlock.Completion:SetText((L["Completion: %s"]):format(completion))
	TTGScenarioStageBlock.Bonuses:SetText( (L["Bonuses: %s"]):format(bonus) )
	TTGScenarioStageBlock.Timer:SetText("00:00:00:00")
	TTGScenarioStageBlock.TimerBonus:SetText("~50")
	initBonusList()

	if total >= 40 then
		TTGScenarioStageBlock.Gem1:Show()
	else
		TTGScenarioStageBlock.Gem1:Hide()
	end
	if total >= 80 then
		TTGScenarioStageBlock.Gem2:Show()
	else
		TTGScenarioStageBlock.Gem2:Hide()
	end
		if total >= 120 then
		TTGScenarioStageBlock.Gem3:Show()
	else
		TTGScenarioStageBlock.Gem3:Hide()
	end
		if total >= 160 then
		TTGScenarioStageBlock.Gem4:Show()
	else
		TTGScenarioStageBlock.Gem4:Hide()
	end
		if total >= 200 then
		TTGScenarioStageBlock.Gem5:Show()
	else
		TTGScenarioStageBlock.Gem5:Hide()
	end
end



function initBonusList()
	TTG_BonusList.name = TTG_BonusList.name or {}
	TTG_BonusList.points = TTG_BonusList.points or {}
		TTG_BonusList.overlay = TTG_BonusList.overlay or {}

	for i, name in ipairs(bonusList) do
		if (bounses[name]) then
			local status = bounses[name][1]
			local pts = bounses[name][2]
			local bonusName = TTG_BonusList.name[i]
			local bonusPoints = TTG_BonusList.points[i]
			local overlay = TTG_BonusList.overlay[i]
			if not bonusName then 

				bonusName = TTG_BonusList:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				bonusPoints = TTG_BonusList:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				overlay = CreateFrame("Frame", nil, TTG_BonusList)
				overlay:SetPoint("TOPLEFT", bonusName, "TOPLEFT")
				overlay:SetPoint("BOTTOMRIGHT", bonusPoints, "BOTTOMRIGHT")
				overlay:SetScript("OnEnter", function(self) 
												if name == "Hoarder" then 
													local total = GetHoarderTotal()

													addon.ShowTooltip(self,L[(name.."_Desc")]:format(total))
												else
													addon.ShowTooltip(self,L[(name.."_Desc")])
												end
								end)
				overlay:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

				TTG_BonusList.name[i] = bonusName
				TTG_BonusList.points[i] = bonusPoints
				TTG_BonusList.overlay[i] = overlay

				bonusName:SetHeight(20)
				bonusPoints:SetHeight(20)
				if i == 1 then
					bonusName:SetPoint("TOPLEFT",TTG_BonusList, "TOPLEFT", 15, -15)
					bonusPoints:SetPoint("TOPRIGHT",TTG_BonusList, "TOPRIGHT", -50, -15)
				else
					bonusName:SetPoint("TOPLEFT",TTG_BonusList.name[i-1], "BOTTOMLEFT", 0, 0)
					bonusPoints:SetPoint("TOPRIGHT",TTG_BonusList.points[i-1], "BOTTOMRIGHT", 0,0)
				end
			end

			local color = YELLOW_FONT_COLOR
			if status == true then
				color = GREEN_FONT_COLOR
			elseif status == false then 
				color = RED_FONT_COLOR
			end

			local outputName = name
			if bounses[name][3] then
				outputName = name.."*"
				color = ORANGE_FONT_COLOR
			end

			bonusName:SetText(color..outputName..":")
			bonusPoints:SetText("+"..pts)
		end
	end

	TTG_BonusList.BottomBG:SetPoint("BOTTOMLEFT", TTG_BonusList.name[#bonusList], "BOTTOMLEFT", -15, -15)
end





