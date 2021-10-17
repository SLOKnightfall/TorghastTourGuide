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


TTG_FrameMixin = {}
function TTG_FrameMixin:OnEnter()
	local current = addon.Statsdb.profile.current
	local completion = current.FloorCompletion
	local text = ""
	for i, data in pairs(completion) do
			--GameTooltip:AddLine(self.tooltipText, nil, nil, nil, true);
		text = text..("%s %s: %s\n"):format(L["Floor"], i, data)
	end
	addon.ShowTooltip(self,text)
end


function TTG_FrameMixin:OnLeave()
	GameTooltip_Hide()
end


TTG_BonusListMixin = {}
function TTG_BonusListMixin:OnShow()
	if addon.db.profile.BonusAutoHideTime then
		C_Timer.After(addon.db.profile.BonusAutoHideTimeValue, function(self) TTG_BonusList:Hide() end)
	end

end




TTG_GemMixin = {}
function TTG_GemMixin:OnEnter()
	local id = self:GetID()
	local score = 40 * id
	addon.ShowTooltip(self,(">=%spts"):format(score))
end

function TTG_GemMixin:SetState(toggle)
	if toggle then 
		self.icon:SetAtlas("jailerstower-score-gem-icon")
	else
		self.icon:SetAtlas("jailerstower-score-disabled-gem-icon")
	end
end

TTG_ScoreMixin = {}
function TTG_ScoreMixin:OnEnter()
end

function TTG_ScoreMixin:OnClick()
	if TTG_BonusList:IsShown() then
		TTG_BonusList:Hide()
	else
		TTG_BonusList:Show()
	end
end

function TTG_ScoreMixin:OnLoad()
	self:RegisterForDrag("LeftButton");
end

function TTG_ScoreMixin:OnDragStart()
	self:StartMoving();
	addon.db.profile.customScorePosition = true
end

function TTG_ScoreMixin:OnDragStop()
	self:StopMovingOrSizing()
end

-- speed optimizations (mostly so update functions are faster)
local _G = getfenv(0);
local date = _G.date;
local abs = _G.abs;
local min = _G.min;
local max = _G.max;
local floor = _G.floor;
local mod = _G.mod;
local tonumber = _G.tonumber;
local gsub = _G.gsub;

-- private data
local SEC_TO_MINUTE_FACTOR = 1/60;
local SEC_TO_HOUR_FACTOR = SEC_TO_MINUTE_FACTOR*SEC_TO_MINUTE_FACTOR;







--338907/refuge-of-the-damned

TTG_TimerMixin = {}
function TTG_TimerMixin:OnEnter()
	local current = addon.Statsdb.profile.current
	local par = current.FloorPar
	local floor_time = current.FloorTime
	local text = ""
		for i, data in pairs(floor_time) do
			--GameTooltip:AddLine(self.tooltipText, nil, nil, nil, true);
		text = text..("%s %s: %s (%s)\n"):format(L["Floor"], i, data, par[i])
	end
			addon.ShowTooltip(self,text)

end

function TTG_TimerMixin:OnLeave()
	GameTooltip_Hide()
end

local combatTimer = 0
function TTG_TimerMixin:OnLoad(isCombat)
	self:RegisterForDrag("LeftButton")
	self:Reset()
	self.isCombat = isCombat
end


function TTG_TimerMixin:OnHide()
	self:Reset(true)
end

function TTG_TimerMixin:Reset(combat)
	if self.isCombat then 
		combatTimer = 0
	end

	--TTG_ScoreFrame.Timer
	self.playing = false;
	self.timer = 0
	self:SetScript("OnUpdate", nil);
	self:Update();
end


function TTG_TimerMixin:Start()
	self.playing = true;
	self.paused = false
	self:SetScript("OnUpdate", 	self.OnUpdate  );
end


function TTG_TimerMixin:ScorePause()
	self.paused = true
	self.playing = false;
	self:SetScript("OnUpdate", 	self.OnPause  );
end


function TTG_TimerMixin:OnUpdate(elapsed)
	self.timer = self.timer + elapsed;
	self:Update();
end

 function BuffCheck(spellID)

local buffs, i = { }, 1;
	local buffSpellId = select(10, UnitBuff("player", i))
	if buffSpellId and spellID == buffSpellId then return true end
	while buffSpellId do
	  i = i + 1;
	  buffSpellId = select(10, UnitBuff("player", i))
	 -- print(buffSpellId)
		if buffSpellId and spellID == buffSpellId then return true end
	end
	return false
end


function TTG_TimerMixin:OnPause(elapsed)
	local refuge = BuffCheck(338907)
	if refuge and not self.paused then 
		TTG_TimerMixin:ScorePause()
--print("safe")
	elseif not refuge then 
--print("start")
		TTG_TimerMixin:ScoreStart()
	end
	--self.timer = self.timer + elapsed;
	--self:Update();
end


function TTG_TimerMixin:ScoreStart()
	TTG_ScoreFrame.Timer.playing = true;
	TTG_ScoreFrame.Timer:SetScript("OnUpdate", function(self, elapsed) 
			--print(elapsed)
		local refuge = BuffCheck(338907)
		if refuge then 
			self:ScorePause()
			return
		end
		TTG_ScoreFrame.Timer.timer = TTG_ScoreFrame.Timer.timer + elapsed;
		addon.Statsdb.profile.current.scoreTimer = TTG_ScoreFrame.Timer.timer
		TTG_ScoreFrame.Timer:Update(elapsed);
		--currentStats.scoreTimer = TTG_ScoreFrame.Timer 
	 end)
end

function TTG_TimerMixin:Stop()
	--TTG_ScoreFrame.Timer
	self.playing = false;
	self:SetScript("OnUpdate", nil);
end

function TTG_TimerMixin:Update()
	local timer = self.timer;
	local hour = min(floor(timer*SEC_TO_HOUR_FACTOR), 99);
	local minute = mod(timer*SEC_TO_MINUTE_FACTOR, 60);
	local second = mod(timer, 60);
	self.StopwatchTickerHour:SetFormattedText(STOPWATCH_TIME_UNIT, hour);
	self.StopwatchTickerMinute:SetFormattedText(STOPWATCH_TIME_UNIT, minute);
	self.StopwatchTickerSecond:SetFormattedText(STOPWATCH_TIME_UNIT, second);
end

function TTG_TimerMixin:OnUpdate(elapsed)

	self.timer = self.timer + elapsed;
	self:Update();
end

function TTG_TimerMixin:IsPlaying()
	return self.playing;
end

local function GetHoarderTotal()
	local total = 500 * GetNumGroupMembers()
	return total
end

function TTG_TimerMixin:CheckBonus()
	if not self.isCombat then return end

	--Boss Bonuses
	if addon:CurrentFloor() == 5 then 
		if self.timer > 40 then
			addon.Tracker:FlagFail("Executioner")
		elseif self.timer > 20 then
			addon.Tracker:FlagFail("Annihilator")
		end

		if addon:CurrentPhantasma() > GetHoarderTotal() then 
			addon.Tracker:FlagBonus("Hoarder")
		end


	end
end

local MAW_BUFF_MAX_DISPLAY = 44;


--3387 lives?
--3373 	Deaths:  
--3369 Speed Demon - Completed within 60% of par time
--3370 	Speedy:  	Completed within par time




local function getBonusDefault()
	local list =	{
		["Empowered"] = {3392, true, 0},
		["Completion"] = {3366, true, 100},
		["Annihilator"] = {3383, nil, 20},
		["Collector"] = {3386, nil, 10},
		["Daredevil"] = {3380, nil, 10,},--true},
		["Executioner"] = {3382, nil, 10},
		["Highlander"] = {3375, true, 15},
		["Hoarder"] = {3384, nil, 10},
		["Hunter"] = {3371, nil, 15, },--true},
		["Pauper"] = {3376, true, 10},
		["Pillager"] = {3372, nil ,5,},--true}, --cant track
		["Plunderer"] = {3381, nil, 5},  --Use stats tracker
		["Reinforced"] = {3385, nil, 10},
		["Rescuer"] = {3379, nil, 10},  --check for quest compl;ete
		["Robber"] = {3378, nil, 5},  --check for killing mob or for drop
		["Savior"] = {3374, nil, 10,},--true}, --Cant Track
		["Trapmaster"] = {3377, nil, 10}, --Use trap damage tracker 
	}
	 
	 return list
end

local Bonuses = getBonusDefault()
local function ResetBonuses()
	Bonuses =  getBonusDefault()
	local current = addon.Statsdb.profile.current

end


local bonusList = {
	"Empowered",
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




function addon.GetAnimaPowerCount(spellID, targetID)
	local target = targetID
	local filter = ""
	if not target then target = "player"; filter = "MAW" end
	for i=1, MAW_BUFF_MAX_DISPLAY do
		local _, icon, count, _, _, _, _, _, _, maw_spellID = UnitAura(target, i, filter);
		if icon and spellID == maw_spellID then
			return count
		end
	end
	return 0
end


function addon.CheckAnimaPowers(spellID)
	if Bonuses.Highlander then 
		local count = addon.GetAnimaPowerCount(spellID)
		if count == 1 then
			return true
		else
			return false 
		end
	end
end

local GREEN_FONT_COLOR = GREEN_FONT_COLOR:GenerateHexColorMarkup()
local RED_FONT_COLOR = RED_FONT_COLOR:GenerateHexColorMarkup()
local ORANGE_FONT_COLOR = ORANGE_FONT_COLOR:GenerateHexColorMarkup()
local YELLOW_FONT_COLOR = YELLOW_FONT_COLOR:GenerateHexColorMarkup()

local function updateAll()
	addon.UpdateBonusList()
	addon.UpdataeScoreFrame()
end

function addon.CheckAnimaRarity(spellRarity)
	return Bonuses.Pauper and spellRarity >= Enum.PlayerChoiceRarity.Epic
end




local function ResetCounts()
	TorghastTourgiudeDB.Tracker = {
			Phantasma = 0,
			AnimaPowers = 0,
			JarsBroken = 0,
			FloorsCompleted = 0,
			Deaths = 0,
			Grue = 0,
			MobsKilled = 0,
			Mawrats = 0,
			Rares = 0,
			Bosses = 0,
			Time = 0,
			CurrentTime = 0,
			TrapSprung = 0,
			Bosses = 0,
			Rares = 0,
			SoulsSaved = 0,
			Chests = 0,
			QuestsCompleted = 0,
			RunsCompleted = 0,
			vendorsKilled = 0,
			scoreTimer = 0,
			currentPhantasma = 0,
			timeBonus = 30,

			FloorPar = {},
			FloorTime =  {},
			TotalPar = 0,
			FloorCompletion = {},
			TotalPar = 0,
			TrackerMessages = {},
		}
end







function addon.Tracker:Init()
	ResetCounts()
	ResetBonuses()

end



function addon.Tracker:FlagFail(bonusName, silent)
	if addon.Statsdb.profile.current.TrackerMessages[bonusName] then return end

	if Bonuses[bonusName] and not silent and addon.db.profile.ShowBonusMessages then 
		print(RED_FONT_COLOR..(L["Failed Bonus: %s"]):format(bonusName))
	end

	Bonuses[bonusName][2] = false
	Bonuses[bonusName][3] = 0
	TorghastTourgiudeDB.Tracker.TrackerMessages[bonusName] = true
	--updateAll()
end

function addon.Tracker:FlagBonus(bonusName)
	
	if TorghastTourgiudeDB.Tracker.TrackerMessages[bonusName] then return end
	if Bonuses[bonusName] and addon.db.profile.ShowBonusMessages then 
		print(GREEN_FONT_COLOR..(L["Gained Bonus: %s"]):format(bonusName))
	end

	Bonuses[bonusName][2] = true
	TorghastTourgiudeDB.Tracker.TrackerMessages[bonusName] = true
	--updateAll()





		if addon.Statsdb.profile.current.TrackerMessages[bonusName] then return end
	if Bonuses[bonusName] and addon.db.profile.ShowBonusMessages then 
		print(GREEN_FONT_COLOR..(L["Gained Bonus: %s"]):format(bonusName))
	end

	Bonuses[bonusName][2] = true
	addon.Statsdb.profile.current.TrackerMessages[bonusName] = true
	--updateAll()
end


local function checkBonusStatus(bonusName)
	return Bonuses[bonusName][2]-- ~= false
end
addon.checkBonusStatus = checkBonusStatus

function addon.Tracker:CombatBonusChecks()
	if combatTimer > 40 then
		addon.Tracker:FlagFail("Executioner")
	elseif combatTimer > 20 then
		addon.Tracker:FlagFail("Annihilator")
	end

	if addon:CurrentFloor() == 5 and addon:CurrentPhantasma() > GetHoarderTotal() then 
		addon.Tracker:FlagBonus("Hoarder")
	end
	
	updateAll()
end


local BuffName
local RefugeOfTheDammedBuffID = 338907

local armaments = {[294592] = true, [294609]= true, [294597]= true, [294578]= true, [294602]= true, [293025]= true}
function addon.Tracker:CheckBonus()
	local totalPowers = 0
	if not BuffName then
		local spell = Spell:CreateFromSpellID(RefugeOfTheDammedBuffID)
		spell:ContinueOnSpellLoad(function()
			BuffName = spell:GetSpellName()
		end)
	end

	for i=1, MAW_BUFF_MAX_DISPLAY do
		local _, icon, count, _, _, _, _, _, _, maw_spellID = UnitAura("player", i, "MAW");
		totalPowers = totalPowers + (count or 0)
		if icon and maw_spellID and not armaments[maw_spellID]  then

			if checkBonusStatus("Highlander") and count > 1 then
				addon.Tracker:FlagFail("Highlander")
			end
		end

		if icon and maw_spellID and armaments[maw_spellID]  then
			if checkBonusStatus("Reinforced") and count >= 5 then
				addon.Tracker:FlagFail("Reinforced")
			end
		end

		if icon and maw_spellID and Bonuses.Pauper then
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
		addon.Tracker:FlagBonus("Plunderer")
	end

	if not checkBonusStatus("Collector")  and totalPowers >= 20 then
		addon.Tracker:FlagBonus("Collector")
	end

	if addon:CurrentPhantasma() > GetHoarderTotal() then 
		--addon.Tracker:FlagBonus("Hoarder")
	elseif addon:CurrentPhantasma() < GetHoarderTotal() then 
		--addon.Tracker:FlagFail("Hoarder", true)
	end

	local current = addon.Statsdb.profile.current
	local current_Time = TTG_ScoreFrame.Timer.timer
	local current_Par = current.TotalPar
	if tonumber(current_Par) ~= 0 then
		local bonus = min(floor((current_Par/current_Time)*30), 50)
		currentStats.timeBonus = bonus
	else
		currentStats.timeBonus = 30
	end

	updateAll()
end


--[[
Daredevil	Defeat 2 Elites within 10 seconds of each other	10
Hunter	No elite enemies reached 4 stacks of Unnatural Power	15
]]--

local function getDeaths()
	local Info = UIWidgetManager:GetWidgetTypeInfo(21).visInfoDataFunction(3373);
	if Info and Info.entries then 
	  local deaths = Info.entries[2].text
		--local floor_time = TimeInfo.entries[3].text
		return deaths
	else
		return 0
	end

end


function addon.Tracker:GetBonusScore()
	local bonus = 0
	addon.GetWidgetBonuses()

	for i, name in ipairs(bonusList) do
		if (Bonuses[name]) then		
			--print(Bonuses[name])
			local status = Bonuses[name][2]
			local pts = Bonuses[name][3]
			if status == true then
				bonus = bonus + pts
			end
		end
	end

	return bonus
end


function addon.InitScoreFrame()
	if addon.db.profile.ShowScore then 
		TTG_ScoreFrame:Show()
	else
		TTG_ScoreFrame:Hide()
		return
	end
	

	local currentStats = addon.Statsdb.profile.current.scoreTimer
	TTG_ScoreFrame.Timer.timer = 0 + addon.Statsdb.profile.current.scoreTimer
--[[	TTG_ScoreFrame.Timer.playing = true;
		TTG_ScoreFrame:SetScript("OnUpdate", function(self, elapsed) 
				--print(elapsed)
			TTG_ScoreFrame.Timer.timer = TTG_ScoreFrame.Timer.timer + elapsed;
			addon.Statsdb.profile.current.scoreTimer = TTG_ScoreFrame.Timer.timer
			TTG_ScoreFrame.Timer:Update(elapsed);
			--currentStats.scoreTimer = TTG_ScoreFrame.Timer 
		 end)]]
	TTG_ScoreFrame.Timer:Update()

	addon.UpdataeScoreFrame()
	addon.UpdateBonusList()
	addon:ResetBonusLocation()

end


function addon.UpdataeScoreFrame()
	local currentStats = addon.Statsdb.profile.current
	--addon.Tracker:CheckBonus()
	--GetTimeBonus()
	local deaths = tonumber(getDeaths())
	local DeathPenalty = deaths * -20
	local bonus = addon.Tracker:GetBonusScore()
	local completion = Bonuses["Completion"][3]
	local timeBonus = currentStats.timeBonus    --- Actual bonus is partime/actualtime*30
	--print(timeBonus)
	local total = completion + bonus + DeathPenalty + timeBonus
	--TTG_ScoreFrame:Show()
	TTG_ScoreFrame.DeathCount:SetText(deaths)
	if deaths > 0 then 
		TTG_ScoreFrame.DeathPenalty:SetText(("(%s)"):format(DeathPenalty))
	else
		TTG_ScoreFrame.DeathPenalty:SetText("")
	end
	TTG_ScoreFrame.Score:SetText(L["Score:"])
	TTG_ScoreFrame.ScoreTotal:SetText(total)
	TTG_ScoreFrame.Completion.text:SetText((L["Completion: %s"]):format(completion))
	TTG_ScoreFrame.Bonuses:SetText( (L["Bonuses: %s"]):format(bonus) )
	--TTG_ScoreFrame.Timer:Reset()
	TTG_ScoreFrame.TimerBonus:SetText("("..timeBonus..")")


	TTG_ScoreFrame.Gem1:SetState(total >= 40)
	TTG_ScoreFrame.Gem2:SetState(total >= 80)
	TTG_ScoreFrame.Gem3:SetState(total >= 120)
	TTG_ScoreFrame.Gem4:SetState(total >= 160)
	TTG_ScoreFrame.Gem5:SetState(total >= 200)
end


function addon.UpdateBonusList()
	TTG_BonusList.name = TTG_BonusList.name or {}
	TTG_BonusList.points = TTG_BonusList.points or {}
	TTG_BonusList.overlay = TTG_BonusList.overlay or {}
	--addon.GetWidgetBonuses()

	for i, name in ipairs(bonusList) do
		if (Bonuses[name]) then
			local status = Bonuses[name][2]
			local pts = Bonuses[name][3]
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
			if Bonuses[name][4] then
				outputName = name.."*"
				color = ORANGE_FONT_COLOR
			end

			bonusName:SetText(color..outputName..":")
			bonusPoints:SetText("+"..pts)
		end
	end

	TTG_BonusList.BottomBG:SetPoint("BOTTOMLEFT", TTG_BonusList.name[#bonusList], "BOTTOMLEFT", -15, -15)
end

function addon:ResetScoreLocation()
	addon.db.profile.customScorePosition = false
	addon:SetScoreLocation()

end

function addon:SetScoreLocation()
	if addon.db.profile.customScorePosition then return end

	local position = addon.db.profile.ScorePosition
	TTG_ScoreFrame:ClearAllPoints()
	if position == "LEFT" then

		TTG_ScoreFrame:SetPoint("TOPRIGHT" , ScenarioStageBlock, "TOPLEFT", 10, 0 )
	else
		TTG_ScoreFrame:SetPoint("TOPLEFT" , ScenarioStageBlock, "TOPRIGHT", 40, 0 )
	end
end



function addon:ResetBonusLocation()
	local position = addon.db.profile.BonusPosition
	TTG_BonusList:ClearAllPoints()
	if position == "LEFT" then
		TTG_BonusList:SetPoint("TOPRIGHT" , TTG_ScoreFrame, "TOPLEFT", 25,5 )
	elseif position == "RIGHT" then
		TTG_BonusList:SetPoint("TOPLEFT" , TTG_ScoreFrame, "TOPRIGHT", 0, 5)
	else
		TTG_BonusList:SetPoint("TOPLEFT" , TTG_ScoreFrame, "BOTTOMLEFT", 0, 0 )
	end
end

--{3366, 3392} 
function addon.GetWidgetBonuses()
	local widgetTypeInfo = UIWidgetManager:GetWidgetTypeInfo(21);
	local current = addon.Statsdb.profile.current  
	current.FloorCompletion = current.FloorCompletion or {}
	local FloorCompletion = current.FloorCompletion
	for name, data in pairs(Bonuses) do
		local ids = data[1]
		local Info = widgetTypeInfo.visInfoDataFunction(ids);

		if Info and Info.entries then 
			--[[if name == "Completion" then
												local totals = 0
												local counter = 1
												for i, data in pairs(FloorCompletion) do
													local comp = string.gsub(data, "%%", "")
													--print(comp)
													totals = totals + comp
													counter = counter + 1
												end
												--print(totals)
												totals = (counter* 100)/ totals
												data[3] = floor(totals)
							
											else]]
				--name = Info.entries[1].text
				local score = Info.entries[3].text
				local tooltip = Info.tooltip
				L[name.."_Desc"] = tooltip

				score = string.gsub(score, "+", "")
				score = tonumber(score)

				data[3] = score
				data[2] = score > 0
			--end
			--return 	score
		end
	end
end

--ScenarioStageBlock
--function EventToastManagerFrame::DisplayToast(true) 
--EventToastManagerFrame.currentDisplayingToast.SubTitle
--/run for i,d in ipairs(EventToastManagerFrame.currentDisplayingToast.SubTitle) do print(i) end


-- set 503 - completion summary
	--set 520 - floor 4 summary
	--set 519 - floor 3 summary
		--set 518 - floor 2 summary
			--set 509  - floor 1 summary
--Deaths 3373

local TimeID = {3394,3404,3405,3406}
local CompletionID = {3393, 3396,3397,3398}

local function GetLayer(current_floor)
	return ceil(current_floor/7)								
end

function addon.SetParTime()
	if true then return end
			local use_estimate = true
			local current = addon.Statsdb.profile.current

			local mapID = C_Map.GetBestMapForUnit("player")
			local par_data = TorghastTourgiudeDB.Floor_Par_Estimate[mapID]
			local current_floor = GetJailersTowerLevel()
			local current_layer = GetLayer(current_floor)
			local party_size = 1

			if par_data then 
				local floor_data = par_data[current_layer]
				floor_data = floor_data and floor_data[party_size]

				if floor_data and use_estimate then
					local par_hour = min(floor(floor_data*SEC_TO_HOUR_FACTOR), 99) ;
					local par_minute = floor(mod(floor_data*SEC_TO_MINUTE_FACTOR, 60));
					local par_second = floor(mod(floor_data, 60));	
					TTG_ScoreFrame.Timer.par:SetText(("Est Par: %s:%s:%s"):format(par_hour, par_minute, par_second))
				end
			else
				----print("No par")
			end
end

function addon.GetFloorSummary()
--3396 Floor Completion
-- 3404 floor time
	local current = addon.Statsdb.profile.current
	current.FloorPar =  {}
	current.FloorTime =  {}
	current.TotalPar =  0
	current.FloorCompletion =  {}
	local cur_floor = 1--addon:CurrentFloor() - 1
	local CombinedTime = 0 

	--FloorTime
	for i, id in ipairs(TimeID) do
		cur_floor = i
		local TimeInfo = UIWidgetManager:GetWidgetTypeInfo(21).visInfoDataFunction(id);
		if TimeInfo and TimeInfo.entries then 
		  --name = Info.entries[1].text
			local floor_time = TimeInfo.entries[3].text
			current.FloorTime[cur_floor] = floor_time
			local floor_par = TimeInfo.tooltip
			local time_hr, time_min, time_sec = strsplit(":", floor_time)
			local totalTime = (time_hr *360 ) + (time_min *60) + time_sec
			local use_estimate = true

			--current.TotalPar = 0

			CombinedTime = CombinedTime + totalTime

			--fixes timer to match blizz's time
			TTG_ScoreFrame.Timer.timer = CombinedTime

			local _,par_time = strsplit(":", floor_par, 2)
			current.FloorPar[cur_floor] = par_time

			local par_hr, par_min, par_sec = strsplit(":", par_time)

			local totalPar = (par_hr *360 ) + (par_min *60) + par_sec

			--current.TotalPar = 0

			current.TotalPar = current.TotalPar + totalPar

			--local bonus = 

			--print(current.TotalPar)
			local CompletionInfo = UIWidgetManager:GetWidgetTypeInfo(21).visInfoDataFunction(CompletionID[i]);
			if CompletionInfo and CompletionInfo.entries then 
				local floor_completion = CompletionInfo.entries[3].text
				current.FloorCompletion[cur_floor] = floor_completion
			end
		end
	end

	local hour = min(floor(current.TotalPar*SEC_TO_HOUR_FACTOR), 99);
	local minute = floor(mod(current.TotalPar*SEC_TO_MINUTE_FACTOR, 60));
	local second = floor(mod(current.TotalPar, 60));

	TTG_ScoreFrame.Timer.par:SetText(("Par: %s:%s:%s"):format(hour,minute, second))

	--[[local mapID = C_Map.GetBestMapForUnit("player")
			local par_data = TorghastTourgiudeDB.Floor_Par_Estimate[mapID]
			local current_floor = GetJailersTowerLevel()
			local current_layer = GetLayer(current_floor)
			local party_size = 1
		
			if par_data then 
				local floor_data = par_data[current_layer]
				floor_data = floor_data and floor_data[party_size]
		
				if floor_data and use_estimate then
					local par_hour = min(floor(floor_data*SEC_TO_HOUR_FACTOR), 99) + hour;
					local par_minute = floor(mod(floor_data*SEC_TO_MINUTE_FACTOR, 60)) + minute;
					local par_second = floor(mod(floor_data, 60)) + second;	
					hour = hour + par_hour
					minute = minute + par_minute
					second = second + par_second
					TTG_ScoreFrame.Timer.par:SetText(("Est Par: %s:%s:%s (Est Floor: %s:%s:%s)"):format(hour, minute, second,par_hour, par_minute, par_second))
				end
			end]]


	--[[TorghastTourgiudeDB.Floor_Par_Estimate[mapID] = TorghastTourgiudeDB.Floor_Par_Estimate[mapID] or {}
			TorghastTourgiudeDB.Floor_Par_Estimate[mapID][current_layer] = TorghastTourgiudeDB.Floor_Par_Estimate[mapID][current_layer] or {}
			--current.Floor_Par_Estimate[mapID][current_layer][party_size] = current.Floor_Par_Estimate[mapID][current_layer][party_size] = {}
		
			local saved_par = TorghastTourgiudeDB.Floor_Par_Estimate[mapID][current_layer][party_size] 
			if saved_par then
				TorghastTourgiudeDB.Floor_Par_Estimate[mapID][current_layer][party_size] = (tonumber(saved_par) + tonumber(totalPar))/2
				print(("Diff: %s"):format(saved_par-totalTime))
			else
				TorghastTourgiudeDB.Floor_Par_Estimate[mapID][current_layer][party_size] = tonumber(totalPar)
			end]]

end