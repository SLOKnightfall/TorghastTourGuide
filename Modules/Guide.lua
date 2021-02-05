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
local frames = {} 


local function CreatePowerFrame(powerID, parent, name, index)
	local spell = Spell:CreateFromSpellID(powerID)

	local infoHeader = CreateFrame("FRAME", name..index, parent, "TorghastTourGuideInfoTemplate")
	infoHeader:SetPoint("TOPLEFT", 25, -50)
	infoHeader:SetPoint("TOPRIGHT", 25, -50)
	infoHeader.button.icon1:Hide()
	infoHeader.button.icon2:Hide()
	infoHeader.button.icon3:Hide()
	infoHeader.button.icon4:Hide()
	infoHeader.overviewIndex = index
	
	local textRightAnchor = infoHeader.button.icon1
	infoHeader.button.title:SetPoint("RIGHT", textRightAnchor, "LEFT", -5, 0)
	infoHeader:Show()

	infoHeader.button.title:Show()
	spell:ContinueOnSpellLoad(function()
		local name = spell:GetSpellName()
		local desc = spell:GetSpellDescription()
		local texture = spell:GetSpellTexture()
		infoHeader.button.abilityIcon:SetTexture(texture)
		infoHeader.button.abilityIcon:Show()
		infoHeader.button.title:SetText(name)
		infoHeader.description:SetText(desc)
		infoHeader.description:SetWidth(infoHeader:GetWidth() - 30)
		infoHeader:SetHeight(infoHeader.description:GetHeight() + 55)
	end)


	infoHeader:Show()
	return infoHeader
end


local function CreateUpgradeFrame(parent, id, index)
	local upgradeInfo = addon.Upgrades[id]
	local item = Item:CreateFromItemID(id)
	local known = C_QuestLog.IsQuestFlaggedCompleted(upgradeInfo[2])
	local spell = Spell:CreateFromSpellID(upgradeInfo[1])
	local infoHeader = CreateFrame("FRAME", "TTG_Upgrades"..index, parent, "TorghastTourGuideInfoTemplate")
	infoHeader:SetPoint("TOPLEFT", 25, -50)
	infoHeader:SetPoint("TOPRIGHT", 25, -50)

	infoHeader.button.icon1:Hide()
	infoHeader.button.icon2:Hide()
	infoHeader.button.icon3:Hide()
	infoHeader.button.icon4:Hide()
	
	local textRightAnchor = infoHeader.button.icon1
	infoHeader.button.title:SetPoint("RIGHT", textRightAnchor, "LEFT", -5, 0)
	infoHeader:Show()
	infoHeader.button.title:Show()

	item:ContinueOnItemLoad(function()
		local name = item:GetItemName() 
		local icon = item:GetItemIcon()
		infoHeader.button.title:SetText(name)
		if known then
			infoHeader.button.title:SetTextColor(0,1,0)
		else
			infoHeader.button.title:SetTextColor(1,0,0)

		end
		infoHeader.button.abilityIcon:SetTexture(icon)
		infoHeader.button.abilityIcon:Show()
		infoHeader.button.title:SetText(name)
	end)

	spell:ContinueOnSpellLoad(function()
		local desc = spell:GetSpellDescription()
		infoHeader.description:SetText(desc)
		infoHeader.description:SetWidth(infoHeader:GetWidth() - 30)
		infoHeader:SetHeight(infoHeader.description:GetHeight() + 55)
	end)

	infoHeader:Show()
	return infoHeader
end

local function CreateStatsFrame(parent)
	local f = CreateFrame("Frame", nil, frames.tg.info.statsScroll.child) 
	local current = addon.Statsdb.profile.current
	local total = addon.Statsdb.profile.total
	frames.tg.info.stats = f
	addon.Stats.Frame = f
	f:SetPoint("TOPLEFT")
	f:SetPoint("BOTTOMRIGHT")
	f:Show()

	f.banner = f:CreateTexture(nil, "OVERLAY")
	f.banner:SetAtlas("bonusobjectives-title-bg")
	f.banner:SetPoint("TOPLEFT", 25, -3)
	f.banner:SetPoint("TOPRIGHT", 25, 3)
	f.banner:SetHeight(30)

	f.desc = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.desc:SetText(L["STATS"])
	f.desc:SetPoint("CENTER", f.banner, 0, 3)
	f.desc:SetJustifyH("CENTER")

	f.currentBG = CreateFrame("FRAME", "TTTG_CurrentStats", frames.tg.info.statsScroll.child, "TorghastTourGuideInfoTemplate")
	f.currentBG:ClearAllPoints()
	f.currentBG:SetPoint("TOPLEFT", 25, -50)
	f.currentBG:SetPoint("TOPRIGHT", 25, -50)

	f.currentBG.button.icon1:Hide()
	f.currentBG.button.icon2:Hide()
	f.currentBG.button.icon3:Hide()
	f.currentBG.button.icon4:Hide()
	local textRightAnchor = f.currentBG.button.icon1
	f.currentBG.button.title:SetPoint("LEFT", 15, 0)
	f.currentBG.button.title:SetPoint("RIGHT", textRightAnchor, "LEFT", -5, 0)

	f.currentBG.button.title:SetText(L["CURRENT RUN:"])
	f.currentBG.description:SetPoint("TOPRIGHT", -15, 0)
	f.currentBG.description:SetPoint("BOTTOMLEFT", -5, 0)

	f.currentTimeCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.currentTimeCount:SetPoint("TOPLEFT", 45, -78)
	f.currentTimeCount:SetJustifyH("CENTER")

	f.currentCompleteCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.currentCompleteCount:SetPoint("TOPLEFT", f.currentTimeCount, "BOTTOMLEFT", 0, -5)
	f.currentCompleteCount:SetJustifyH("CENTER")

	f.currentFloorCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.currentFloorCount:SetPoint("TOPLEFT", f.currentCompleteCount, "BOTTOMLEFT", 0, -5)
	f.currentFloorCount:SetJustifyH("CENTER")

	f.currentPhantasmaCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.currentPhantasmaCount:SetPoint("TOPLEFT", f.currentFloorCount, "BOTTOMLEFT", 0, -5)
	f.currentPhantasmaCount:SetJustifyH("CENTER")

	f.currentAnimaCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.currentAnimaCount:SetPoint("TOPLEFT", f.currentPhantasmaCount, "BOTTOMLEFT", 0, -5)
	f.currentAnimaCount:SetJustifyH("CENTER")

	f.currentSoulsCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.currentSoulsCount:SetPoint("TOPLEFT", f.currentAnimaCount, "BOTTOMLEFT", 0, -5)
	f.currentSoulsCount:SetJustifyH("CENTER")

	f.currentChestCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.currentChestCount:SetPoint("TOPLEFT", f.currentSoulsCount, "BOTTOMLEFT", 0, -5)
	f.currentChestCount:SetJustifyH("CENTER")

	f.currentQuestCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.currentQuestCount:SetPoint("TOPLEFT", f.currentChestCount, "BOTTOMLEFT", 0, -5)
	f.currentQuestCount:SetJustifyH("CENTER")

	f.currentDeathCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.currentDeathCount:SetPoint("TOPLEFT", f.currentQuestCount, "BOTTOMLEFT", 0, -5)
	f.currentDeathCount:SetJustifyH("CENTER")

	f.currentTrapsCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.currentTrapsCount:SetPoint("TOPLEFT", f.currentDeathCount, "BOTTOMLEFT", 0, -5)
	f.currentTrapsCount:SetJustifyH("CENTER")

	f.currentgrueCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.currentgrueCount:SetPoint("TOPLEFT", f.currentTrapsCount, "BOTTOMLEFT", 0, -5)
	f.currentgrueCount:SetJustifyH("CENTER")

	f.currentkillCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.currentkillCount:SetPoint("TOPLEFT", f.currentgrueCount, "BOTTOMLEFT", 0, -5)
	f.currentkillCount:SetJustifyH("CENTER")

	f.currentKillBreakdown = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.currentKillBreakdown:SetPoint("TOPLEFT", f.currentkillCount, "BOTTOMLEFT", 0, -5)
	f.currentKillBreakdown:SetJustifyH("CENTER")

	f.currentpotsCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.currentpotsCount:SetPoint("TOPLEFT", f.currentKillBreakdown, "BOTTOMLEFT", 0, -5)
	f.currentpotsCount:SetJustifyH("CENTER")

	f.currentBG:SetPoint("BOTTOMLEFT", f.currentpotsCount,"BOTTOMLEFT",  25, 0)
	f.currentBG:SetPoint("BOTTOMRIGHT", f.currentpotsCount,"BOTTOMRIGHT",  25, 0)

	f.totalsBG = CreateFrame("FRAME", "TTTG_TotalStats", frames.tg.info.statsScroll.child, "TorghastTourGuideInfoTemplate")
	f.totalsBG:ClearAllPoints()
	f.totalsBG:SetPoint("TOPLEFT", f.currentBG, "BOTTOMLEFT", 0 ,-25)
	f.totalsBG:SetPoint("TOPRIGHT", f.currentBG, "BOTTOMRIGHT", 0 ,-25)

	f.totalsBG.button.icon1:Hide()
	f.totalsBG.button.icon2:Hide()
	f.totalsBG.button.icon3:Hide()
	f.totalsBG.button.icon4:Hide()
	local textRightAnchor = f.totalsBG.button.icon1
	f.totalsBG.button.title:SetPoint("LEFT", 15, 0)
	f.totalsBG.button.title:SetPoint("RIGHT", textRightAnchor, "LEFT", -5, 0)

	f.totalsBG.button.title:SetText(L["TOTALS:"])
	f.totalsBG.description:SetPoint("TOPRIGHT", -15, 0)
	f.totalsBG.description:SetPoint("BOTTOMLEFT", -5, 0)

	f.totalTimeCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.totalTimeCount:SetPoint("TOPLEFT", f.currentBG, "BOTTOMLEFT", 20, -55)
	f.totalTimeCount:SetJustifyH("CENTER")

	f.totalCompleteCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.totalCompleteCount:SetPoint("TOPLEFT", f.totalTimeCount, "BOTTOMLEFT", 0, -5)
	f.totalCompleteCount:SetJustifyH("CENTER")

	f.totalFloorCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.totalFloorCount:SetPoint("TOPLEFT", f.totalCompleteCount, "BOTTOMLEFT", 0, -5)
	f.totalFloorCount:SetJustifyH("CENTER")

	f.totalPhantasmaCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.totalPhantasmaCount:SetPoint("TOPLEFT", f.totalFloorCount, "BOTTOMLEFT", 0, -5)
	f.totalPhantasmaCount:SetJustifyH("CENTER")

	f.totalAnimaCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.totalAnimaCount:SetPoint("TOPLEFT", f.totalPhantasmaCount, "BOTTOMLEFT", 0, -5)
	f.totalAnimaCount:SetJustifyH("CENTER")

	f.totalSoulsCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.totalSoulsCount:SetPoint("TOPLEFT", f.totalAnimaCount, "BOTTOMLEFT", 0, -5)
	f.totalSoulsCount:SetJustifyH("CENTER")

	f.totalChestCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.totalChestCount:SetPoint("TOPLEFT", f.totalSoulsCount, "BOTTOMLEFT", 0, -5)
	f.totalChestCount:SetJustifyH("CENTER")

	f.totalQuestCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.totalQuestCount:SetPoint("TOPLEFT", f.totalChestCount, "BOTTOMLEFT", 0, -5)
	f.totalQuestCount:SetJustifyH("CENTER")

	f.totalDeathCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.totalDeathCount:SetPoint("TOPLEFT", f.totalQuestCount, "BOTTOMLEFT", 0, -5)
	f.totalDeathCount:SetJustifyH("CENTER")

	f.totalTrapsCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.totalTrapsCount:SetPoint("TOPLEFT", f.totalDeathCount, "BOTTOMLEFT", 0, -5)
	f.totalTrapsCount:SetJustifyH("CENTER")

	f.totalgrueCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.totalgrueCount:SetPoint("TOPLEFT", f.totalTrapsCount, "BOTTOMLEFT", 0, -5)
	f.totalgrueCount:SetJustifyH("CENTER")

	f.totalkillCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.totalkillCount:SetPoint("TOPLEFT", f.totalgrueCount, "BOTTOMLEFT", 0, -5)
	f.totalkillCount:SetJustifyH("CENTER")

	f.totalKillBreakdown = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.totalKillBreakdown:SetPoint("TOPLEFT", f.totalkillCount, "BOTTOMLEFT", 0, -5)
	f.totalKillBreakdown:SetJustifyH("CENTER")

	f.totalpotsCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	f.totalpotsCount:SetPoint("TOPLEFT", f.totalKillBreakdown, "BOTTOMLEFT", 0, -5)
	f.totalpotsCount:SetJustifyH("CENTER")

	f.totalsBG:SetPoint("BOTTOMLEFT", f.totalpotsCount,"BOTTOMLEFT",  25, 0)
	f.totalsBG:SetPoint("BOTTOMRIGHT", f.totalpotsCount,"BOTTOMRIGHT",  25, 0)

	addon.Stats:UpdateStats()
end 


local function CreateUpgradeListFrame(parent)
	local f = CreateFrame("Frame", nil, frames.tg.info.upgradesScroll.child) 
	local current = addon.Statsdb.profile.current
	local total = addon.Statsdb.profile.total
	f:SetPoint("TOPLEFT")
	f:SetPoint("BOTTOMRIGHT")
	f:Show()

	f.banner = f:CreateTexture(nil, "OVERLAY")
	f.banner:SetAtlas("bonusobjectives-title-bg")
	f.banner:SetPoint("TOPLEFT", 25, -3)
	f.banner:SetPoint("TOPRIGHT", 25, 3)
	f.banner:SetHeight(30)

	f.desc = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.desc:SetText(L["Torghast Upgrades"])
	f.desc:SetPoint("CENTER", f.banner, 0, 3)
	f.desc:SetJustifyH("CENTER")

	local index = 1
	for id in pairs(addon.Upgrades) do
		f[index] = CreateUpgradeFrame(f, id, index)

		if index == 1 then 
			f[index]:SetPoint("TOPLEFT", 25, -45)
			f[index]:SetPoint("TOPRIGHT", 25, -45)
		else
			f[index]:SetPoint("TOPLEFT", f[index - 1], "BOTTOMLEFT" )
			f[index]:SetPoint("TOPRIGHT", f[index - 1], "BOTTOMRIGHT" )
		end

		index = index + 1
	end
end


local function CreateRavinousPowerListFrame()
	local f = frames.tg.info.ravPowerScroll.child

	f.banner = f:CreateTexture(nil, "OVERLAY")
	f.banner:SetAtlas("bonusobjectives-title-bg")
	f.banner:SetPoint("TOPLEFT", 25, -3)
	f.banner:SetPoint("TOPRIGHT", 25, 3)
	f.banner:SetHeight(30)

	f.desc = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.desc:SetText(L["Ravenous Anima Cell Powers"])
	f.desc:SetPoint("CENTER", f.banner, 0, 3)
	f.desc:SetJustifyH("CENTER")

	local index = 1

	local note = f:CreateFontString(nil, "OVERLAY", "GameFontBlack")
	note:SetPoint("TOPLEFT", f.desc, "BOTTOMLEFT" , -15, -8)
	note:SetPoint("TOPRIGHT", f.desc,15, 0)
	note:SetText(L["Rav_Note"])

	for name, powerID in pairs(addon.PowerNames) do
		f[index] = CreatePowerFrame(powerID, f, "TTTG_Powers", index)
		f[index]:ClearAllPoints()
		if index == 1 then 
			f[index]:SetPoint("TOPLEFT", 25, -65)
			f[index]:SetPoint("TOPRIGHT", 25, -65)
		else
			f[index]:SetPoint("TOPLEFT", f[index - 1], "BOTTOMLEFT")
			f[index]:SetPoint("TOPRIGHT", f[index - 1], "BOTTOMRIGHT")
		end
		index = index + 1
	end
end


local function CreateMobInfoFrame(mobID)
	local mobPower = addon.mobs[mobID]
	local f = CreateFrame("Frame", nil, frames.tg.info.ravMobScroll.child) 
	f:SetSize(100, 20)
	f:Show()

	f.name = f:CreateFontString(nil, "OVERLAY", "GameFontBlack")
	f.name:SetPoint("LEFT", 9, -3)
	f.name:SetText(L[tostring(mobID)]..":")
	f.icon = f:CreateTexture(nil, "OVERLAY")
	f.icon:SetSize(15,15)
	f.icon:SetPoint("LEFT",f.name, "RIGHT", 5, 0)
	f.power = f:CreateFontString(nil, "OVERLAY", "GameFontBlack")
	f.power:SetPoint("LEFT",f.icon, "RIGHT", 2, 0)

	if mobPower then 
		local spell = Spell:CreateFromSpellID(mobPower)
		spell:ContinueOnSpellLoad(function()
			local name = spell:GetSpellName() 
			local icon = spell:GetSpellTexture()
			--local description = spell:GetSpellDescription()
			f.icon:SetTexture(icon)
			f.power:SetText(name)
		end)
	end

	return f
end


local function CreateRavinousMobListFrame()
	local f = frames.tg.info.ravMobScroll.child
	local zoneIndex = 1

	f.banner = f:CreateTexture(nil, "OVERLAY")
	f.banner:SetAtlas("bonusobjectives-title-bg")
	f.banner:SetPoint("TOPLEFT", 25, -3)
	f.banner:SetPoint("TOPRIGHT", 25, 3)
	f.banner:SetHeight(30)

	f.desc = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.desc:SetText(L["Torghast Mobs"])
	f.desc:SetPoint("CENTER", f.banner, 0, 3)
	f.desc:SetJustifyH("CENTER")

	local lastIndex
	for zoneIndex, data in ipairs(addon.ZoneList) do
		local infoHeader = CreateFrame("FRAME", "TTG_MobZone"..zoneIndex, f, "TorghastTourGuideInfoTemplate")
		infoHeader:SetPoint("TOPLEFT", 25, -50)
		infoHeader:SetPoint("TOPRIGHT", 25, -50)

		infoHeader.button.icon1:Hide()
		infoHeader.button.icon2:Hide()
		infoHeader.button.icon3:Hide()
		infoHeader.button.icon4:Hide()
		
		local textRightAnchor = infoHeader.button.icon1
		infoHeader.button.title:SetPoint("RIGHT", textRightAnchor, "LEFT", -5, 0)
		infoHeader.button.title:SetText(data[1])
		infoHeader:Show()

		infoHeader.button.title:Show()

		infoHeader.description:SetText(" ")
		infoHeader.description:SetWidth(infoHeader:GetWidth() - 30)
		infoHeader:SetHeight(infoHeader.description:GetHeight() + 55)

		infoHeader:Show()
	
		if zoneIndex == 1 then 
			infoHeader:SetPoint("TOPLEFT", 25, -45)
			infoHeader:SetPoint("TOPRIGHT", 25, -55)
		else
			infoHeader:SetPoint("TOPLEFT", lastIndex, "BOTTOMLEFT",0,-25 )
		end

		for index, mobID in ipairs(data[2]) do
			f[index] = CreateMobInfoFrame(mobID)
			if index == 1 then 
				f[index]:SetPoint("TOPLEFT", infoHeader.button, "BOTTOMLEFT",0, -3)
				f[index]:SetPoint("TOPRIGHT", 0, 0)
			else
				f[index]:SetPoint("TOPLEFT", f[index - 1], "BOTTOMLEFT" )
			end
			lastIndex = f[index]
		end


		infoHeader.description:SetPoint("BOTTOM", lastIndex, "BOTTOM")
		--infoHeader:SetHeight(infoHeader.description:GetHeight() + 55)
	end
end


TorghastTourGuideTabMixin = {}
function TorghastTourGuideTabMixin:OnLoad()
	local tab = self:GetID()

	if tab == 1 then 
		self.tooltip = L["Stats"]
	elseif tab == 2 then 
		self.tooltip = L["Upgrades"]
	elseif tab == 3 then 
		self.tooltip = L["Ravenous Anima Cell Powers"]
	elseif tab == 4 then 
		self.tooltip = L["Rares"]
	elseif tab == 5 then 
		self.tooltip = L["Bosses"]
	elseif tab == 6 then 
		self.tooltip = L["Bosses Ability"]
	end
end


function TorghastTourGuideTabMixin:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT");
	GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true);
end


local function TorghastTourGuide_TabClicked(self, button)
	local tabType = self:GetID()
	addon.SetTab(tabType)
	PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN)
end


function TorghastTourGuideTabMixin:OnClick()
	TorghastTourGuide_TabClicked(self, button)
end


TorghastTourGuideScrollBarMixin = {};
function TorghastTourGuideScrollBarMixin:OnLoad()
	self.trackBG:SetVertexColor(ENCOUNTER_JOURNAL_SCROLL_BAR_BACKGROUND_COLOR:GetRGBA());
end

function addon.initTourGuide()
	local f = CreateFrame("Frame", "TorghastTourGuide", UIParent, "TorghastTourGuideTemplate")
	frames.tg = f
	tinsert(UISpecialFrames,"TorghastTourGuide")

	CreateStatsFrame(f)
	CreateUpgradeListFrame(f)
	CreateRavinousPowerListFrame()
	CreateRavinousMobListFrame()
	addon.CreateRareButtons()
	addon.CreateBossButtons()
	addon.DisplayCreature(152253)

	addon.SetTab(1)

	f.info.LinkButton:SetScript("OnEnter", function(self) addon.ShowTooltip(self, L["WoWHead Links"]) end)
	f.info.LinkButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	f.info.LinkButton:SetScript("OnClick", function(self) addon.ToggleLinkWindow() end)
end
	

--PlayerChoiceFrame.Option1
--CONFIRM_PURCHASE_NONREFUNDABLE_ITEM

local TTG_Tabs = {}
TTG_Tabs[1] = {frame = "statsScroll", button = "statsTab"}
TTG_Tabs[2] = {frame = "upgradesScroll", button = "upgradesTab"}
TTG_Tabs[3] = {frame = "ravPowerScroll", button = "ravenousTab"}
TTG_Tabs[4] = {frame = "rareScroll", button = "rareTab"}
TTG_Tabs[5] = {frame = "bossesScroll", button = "bossTab"}
TTG_Tabs[6] = {frame = "detailsScroll", button = "bossDetailsTab"}

local creatureDisplayID
local rareCreatureDisplayID
local function SetDefaultModel(tabType)
	if tabType == 1 then 
		addon.DisplayCreature(152253)
	elseif tabType == 2 then 
		addon.DisplayCreature(95004)
		elseif tabType == 4 then 

		addon.DisplayCreature(rareCreatureDisplayID.encounterID)

	else
		addon.DisplayCreature(creatureDisplayID.encounterID)
	end
end


function addon.SetTab(tabType)
	local info = frames.tg.info
	for key, data in pairs(TTG_Tabs) do
		if key == tabType then
			info[data.frame]:Show()
			info[data.button].selected:Show()
			info[data.button].unselected:Hide()
			info[data.button]:LockHighlight()
		else
			info[data.frame]:Hide()
			info[data.button].selected:Hide()
			info[data.button].unselected:Show()
			info[data.button]:UnlockHighlight()
		end
	end

	if tabType == 2 then
		--info.upgrades:Show()
		info.model:Hide()
	else
		--info.upgrades:Hide()
		info.model:Show()
	end

	if tabType == 3 then
		info.ravMobScroll:Show()
		info.model:Hide()
	else
		info.ravMobScroll:Hide()
		info.model:Show()
	end

	if tabType == 6 then
		info.LinkButton:Show()
	else
		info.LinkButton:Hide()
	end

	SetDefaultModel(tabType)
end


local defaultsDisplay = {
	[95004] = {95004, {}, 362} ,
	[152253] = {99060, {}, 65} ,
}
 
function addon.DisplayCreature(UnitID)
	local data = defaultsDisplay[UnitID] or addon.Bosses[UnitID] or addon.RareIDs[UnitID]
	local modelScene = frames.tg.info.model
	if data then -- and (EncounterJournal.creatureDisplayID ~= self.displayInfo or forceUpdate) then
		local scene = addon.BossCamera[UnitID] or 9
		modelScene:SetFromModelSceneID(scene, true)
		local creature = modelScene:GetActorByTag("creature")
		if creature then
			creature:SetModelByCreatureDisplayID(data[1], true)
		end
	end

	modelScene.imageTitle:SetText(L[tostring(UnitID)])
end


function addon.CreateBossButtons()
	local f = frames.tg.info.bossesScroll.child
	f.banner = f:CreateTexture(nil, "OVERLAY")
	f.banner:SetAtlas("bonusobjectives-title-bg")
	f.banner:SetPoint("TOPLEFT", 25, -3)
	f.banner:SetPoint("TOPRIGHT", 25, 3)
	f.banner:SetHeight(30)

	f.desc = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.desc:SetText(L["Bosses"])
	f.desc:SetPoint("CENTER", f.banner, 0, 3)
	f.desc:SetJustifyH("CENTER")
	local bossIndex = 1
	--local name, description, bossID, rootSectionID, link = EJ_GetEncounterInfoByIndex(bossIndex)
	for bossID, data in pairs(addon.Bosses) do
		local name = L[tostring(bossID)]
		local bossButton = _G["TorgastTourGuideBossButton"..bossIndex]
		local hasBossAbilities = false

		if not bossButton then
			bossButton = CreateFrame("BUTTON", "TorgastTourGuideBossButton"..bossIndex, f, "TorghastTourGuideBossButtonTemplate")
			if bossIndex > 1 then
				bossButton:SetPoint("TOPLEFT", _G["TorgastTourGuideBossButton"..(bossIndex - 1)], "BOTTOMLEFT", 0, -15)
				bossButton:UnlockHighlight()
			else
				
				bossButton:SetPoint("TOPRIGHT", f, "TOPRIGHT", 10, -40)
				bossButton:LockHighlight()

			end
		end

		bossButton:SetText(name)
		bossButton:Show()
		bossButton.encounterID = bossID
		if bossIndex == 1 then 
			creatureDisplayID = bossButton
			addon.BossClick(bossButton)
		end
		bossButton:SetScript("OnClick", function() addon.BossClick(bossButton) end)
		--Use the boss' first creature as the button ico
		local bossImage = data[1] or "Interface\\EncounterJournal\\UI-EJ-BOSS-Default"
		SetPortraitTextureFromCreatureDisplayID(bossButton.creature, bossImage)

		bossIndex = bossIndex + 1
	end
end



function addon.CreateRareButtons()
	local lastIndex

	local f = frames.tg.info.rareScroll.child
	f.banner = f:CreateTexture(nil, "OVERLAY")
	f.banner:SetAtlas("bonusobjectives-title-bg")
	f.banner:SetPoint("TOPLEFT", 25, -3)
	f.banner:SetPoint("TOPRIGHT", 25, 3)
	f.banner:SetHeight(30)

	f.desc = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.desc:SetText(L["Rares"])
	f.desc:SetPoint("CENTER", f.banner, 0, 3)
	f.desc:SetJustifyH("CENTER")

	local note = f:CreateFontString(nil, "OVERLAY", "GameFontBlack")
	note:SetPoint("TOPLEFT", f.banner, "BOTTOMLEFT" , -15, -8)
	note:SetPoint("TOPRIGHT", f.banner,15, 0)
	note:SetText(L["Rare_Note"])
	local rareIndex = 1
	--local name, description, bossID, rootSectionID, link = EJ_GetEncounterInfoByIndex(bossIndex)
	for rareID, data in pairs(addon.RareIDs) do
		local name = L[tostring(rareID)]
		local rareButton = _G["TorgastTourGuideRareButton"..rareIndex]
		local hasBossAbilities = false

		if not rareButton then
			rareButton = CreateFrame("BUTTON", "TorgastTourGuideRareButton"..rareIndex, frames.tg.info.rareScroll.child, "TorghastTourGuideBossButtonTemplate")
			if rareIndex > 1 then
				rareButton:SetPoint("TOPLEFT", lastIndex, "BOTTOMLEFT", 0, -4)
								--rareButton:SetPoint("TOPLEFT", _G["TorgastTourGuideRareButton"..(rareIndex - 1)], "BOTTOMLEFT", 0, -15)

				rareButton:UnlockHighlight()
			else
				rareButton:ClearAllPoints()
				rareButton:SetPoint("TOPRIGHT", frames.tg.info.rareScroll.child, "TOPRIGHT", 10, -70)
				rareButton:LockHighlight()
			end
		end

		rareButton:SetText(name)
		rareButton:Show()
		rareButton.encounterID = rareID
		if rareIndex == 1 then 
			rareCreatureDisplayID = rareButton
			addon.RareClick(rareButton)
		end
		rareButton:SetScript("OnClick", function() addon.RareClick(rareButton) end)
		--Use the boss' first creature as the button ico
		local bossImage = data[1] or "Interface\\EncounterJournal\\UI-EJ-BOSS-Default"
		SetPortraitTextureFromCreatureDisplayID(rareButton.creature, bossImage)

		lastIndex = rareButton
		local frameindex = {}
		for index, powerID in pairs(data[2]) do
			frameindex[index] = CreatePowerFrame(powerID, f, "TTTG_RarePowers"..rareIndex..powerID, index)

			if index == 1 then 
				frameindex[index]:SetPoint("TOPLEFT", rareButton, "BOTTOMLEFT", 0,-10)

			else
				frameindex[index]:SetPoint("TOPLEFT", frameindex[index-1], "BOTTOMLEFT" )

			end
			frameindex[index]:SetFrameLevel(rareButton:GetFrameLevel() +1)
			lastIndex = frameindex[index]
		end

		rareIndex = rareIndex + 1
	end
end


function addon.ToggleTourGuide()
	if TorghastTourGuide:IsShown() then
		TorghastTourGuide:Hide()
	else
		TorghastTourGuide:Show()
		addon.Stats:UpdateStats()
	end
end


function TorghastTourGuide_Toggle()
	addon.ToggleTourGuide()
end


function addon.BossClick(bossButton)
	creatureDisplayID:UnlockHighlight()
	creatureDisplayID = bossButton
	addon.DisplayCreature(creatureDisplayID.encounterID)
	bossButton:LockHighlight()
	addon.ClearOverview()
	for i, spellID in ipairs(addon.Bosses[creatureDisplayID.encounterID][2]) do
		addon.SetUpOverview(spellID, i)
	end

	addon.SetUpTips(addon.BossTips[creatureDisplayID.encounterID], frames.tg.info.detailsScroll.child.overviews[#(addon.Bosses[creatureDisplayID.encounterID][2])])
end


function addon.RareClick(button)
	rareCreatureDisplayID:UnlockHighlight()
	rareCreatureDisplayID = button
	addon.DisplayCreature(rareCreatureDisplayID.encounterID)
	button:LockHighlight()
end


function addon.SetUpTips(tipdata, anchor)
	local parent = frames.tg.info.detailsScroll.child
	if not parent.tips then 
		local infoHeader = CreateFrame("FRAME", nil, parent, "TorghastTourGuideInfoTemplate")
		infoHeader.descriptionBG:ClearAllPoints()
		infoHeader.descriptionBG:SetPoint("TOPLEFT", infoHeader, "BOTTOMLEFT" , 8, 0)
		infoHeader.descriptionBG:SetPoint("TOPRIGHT", infoHeader, "BOTTOMRIGHT", -8, 0)

		infoHeader.button.abilityIcon:Hide()
		infoHeader.button.icon1:Hide()
		infoHeader.button.icon2:Hide()
		infoHeader.button.icon3:Hide()
		infoHeader.button.icon4:Hide()
		infoHeader.button.title:SetText(L["Tips & Tricks"])
		local textRightAnchor = infoHeader.button.icon1
		--infoHeader.button.title:SetPoint("LEFT", 5, 0)
		infoHeader.button.title:SetPoint("RIGHT", -5, 0)
		parent.tips = infoHeader
	end

	parent.tips:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT" , 0, -15 )
	parent.tips:SetPoint("TOPRIGHT", anchor, "BOTTOMRIGHT", 0, -15)
	parent.tips:Show()
	parent.bullets = parent.bullets or {}

	for index, data in ipairs(parent.bullets) do
		data:Hide()
	end

	for index, data in ipairs(tipdata) do
		local infoBullet
		if not parent.bullets[index] then
			infoBullet = CreateFrame("Frame", nil, parent, "TorghastTourGuideOverviewBulletTemplate")
			parent.bullets[index] = infoBullet
		else
			infoBullet = parent.bullets[index]
			infoBullet:Show()
		end

		if (index == 1) then
			infoBullet:SetPoint("TOPLEFT", parent.tips, "BOTTOMLEFT" , 4, -10 )
			infoBullet:SetPoint("TOPRIGHT", parent.tips, "BOTTOMRIGHT", -4, -10)

		else
			infoBullet:SetPoint("TOPLEFT", parent.bullets[index - 1], "BOTTOMLEFT", 0, -9)
			infoBullet:SetPoint("TOPRIGHT", parent.bullets[index - 1], "BOTTOMRIGHT", 0, -9)
		end

		infoBullet.Text:SetPoint("TOPLEFT", 20, 0)
		infoBullet.Text:SetPoint("TOPRIGHT", -20, 0)
		infoBullet.Text:SetWordWrap(true)
		infoBullet.Text:SetText(data)
		infoBullet.Text:SetHeight(200)
	--	infoBullet:SetWidth(parent:GetWidth() - 13)
		infoBullet.Text:SetWidth(parent.tips:GetWidth() - 26)
		infoBullet:SetHeight(infoBullet.Text:GetStringHeight() + 5)
		parent.tips.descriptionBG:SetPoint("BOTTOMRIGHT", infoBullet, "BOTTOMRIGHT", 0, -3)
	end
end


function addon.ClearOverview()
	if not frames.tg.info.detailsScroll.child.overviews then return end
	for index, data in ipairs(frames.tg.info.detailsScroll.child.overviews) do
		data:Hide()
	end

end


function addon.SetUpOverview(spellID, index)
	local infoHeader
	local parent = frames.tg.info.detailsScroll.child
	parent.overviews = parent.overviews or {}
	if not parent.overviews[index] then -- create a new header
		infoHeader = CreateFrame("FRAME", "TTTG_InfoHeader"..index, parent, "TorghastTourGuideInfoTemplate")
		infoHeader.button.icon1:Hide()
		infoHeader.button.icon2:Hide()
		infoHeader.button.icon3:Hide()
		infoHeader.button.icon4:Hide()
		infoHeader.overviewIndex = index
		
		local textRightAnchor = infoHeader.button.icon1
		--infoHeader.button.title:SetPoint("LEFT", 5, 0)
		infoHeader.button.title:SetPoint("RIGHT", textRightAnchor, "LEFT", -5, 0)
		parent.overviews[index] = infoHeader
	else
		infoHeader = parent.overviews[index]
	end
	infoHeader:Show()

	infoHeader:ClearAllPoints()
	if (index == 1) then
		infoHeader:SetPoint("TOPLEFT",  0, -15 )
		infoHeader:SetPoint("TOPRIGHT", 0, -15 )
	else
		infoHeader:SetPoint("TOPLEFT", parent.overviews[index-1], "BOTTOMLEFT", 0, -9)
		infoHeader:SetPoint("TOPRIGHT", parent.overviews[index-1], "BOTTOMRIGHT", 0, -9)
	end
	--infoHeader.spellID = sectionInfo.spellID

	infoHeader.button.title:Show()

	--Workarround for undefined abilities
	if spellID == 999999999 then 
		local spell = Spell:CreateFromSpellID(300824)
		spell:ContinueOnSpellLoad(function()
			local name = spell:GetSpellName()
			local texture = spell:GetSpellTexture()
			infoHeader.button.abilityIcon:SetTexture(texture)
			infoHeader.button.abilityIcon:Show()
			infoHeader.button.title:SetText(name)
			infoHeader.description:SetText(L["Split_Desc"])
			infoHeader.description:SetWidth(infoHeader:GetWidth() - 30)
			infoHeader:SetHeight(infoHeader.description:GetHeight() + 45)
		end)
	else
		local spell = Spell:CreateFromSpellID(spellID)
		spell:ContinueOnSpellLoad(function()
			local name = spell:GetSpellName()
			local desc = spell:GetSpellDescription()
			local texture = spell:GetSpellTexture()
			infoHeader.button.abilityIcon:SetTexture(texture)
			infoHeader.button.abilityIcon:Show()
			infoHeader.button.title:SetText(name)
			infoHeader.description:SetText(desc)

			infoHeader.description:SetWidth(infoHeader:GetWidth() - 30)
			infoHeader:SetHeight(infoHeader.description:GetHeight() + 45)

		end)
	end

	infoHeader:Show()
end


local LISTWINDOW
function addon.ToggleLinkWindow()
	if LISTWINDOW then LISTWINDOW:Hide() end

	local f = AceGUI:Create("Window")
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	--f:SetTitle("Wardrobe Export")
	f:SetLayout("Fill")
	f:EnableResize(false)
	f:SetHeight(150)
	f:SetWidth(350)
	LISTWINDOW = f

	_G["TTG_LinkWindow"] = f.frame
	tinsert(UISpecialFrames, "TTG_LinkWindow")

	local MultiLineEditBox = AceGUI:Create("MultiLineEditBox")
	MultiLineEditBox:SetFullHeight(true)
	MultiLineEditBox:SetFullWidth(true)
	MultiLineEditBox:SetLabel("")
	MultiLineEditBox:DisableButton(button)
	MultiLineEditBox.button:Hide()
	MultiLineEditBox:SetText((L["BOSSLINK"]):format(creatureDisplayID.encounterID).."\n"..L["GUIDELINK"])
	f:AddChild(MultiLineEditBox)
end