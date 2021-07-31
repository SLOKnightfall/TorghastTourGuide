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
	local  infoHeader = parent[index]

	if not infoHeader then infoHeader = CreateFrame("FRAME", name..index, parent, "TorghastTourGuideInfoTemplate") end

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
	if powerID == 0 then 
		infoHeader.button.title:SetText(L["No Data Available"])
		infoHeader.description:SetText(L["No Data Available"])
		infoHeader.description:SetWidth(infoHeader:GetWidth() - 30)
		infoHeader:SetHeight(infoHeader.description:GetHeight() + 55)
		infoHeader.abilitytext = L["No Data Available"]
	else

		local weightText, noteText = addon.GetNotes(powerID)
		--print(weightText)
		if noteText ~= "" then 
			noteText = "\n\n"..L["Notes:"].."\n"..noteText

	end
	if not infoHeader.weight then 
		infoHeader.weight = CreateFrame("FRAME", nil, infoHeader, "TorghastTourGuidePowerTemplate")
		infoHeader.weight:SetPoint("TOPRIGHT", infoHeader.button , "TOPLEFT", 10, 10)
		infoHeader.weight:SetScale(.75, .75)
		infoHeader.button.abilityIcon:SetPoint("LEFT", 5, 0)
		
		infoHeader.weight:SetScript("OnMouseDown", function(self) addon.EditWeight(self, infoHeader) end)
		infoHeader.weight:SetScript("OnEnter", function(self) 	GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT");
									GameTooltip:SetText(L["Click to set weight & note"], nil, nil, nil, nil, true); end)
		infoHeader.weight:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end

	infoHeader.spellID = powerID
	infoHeader.weight.Text:SetText(weightText)
	spell:ContinueOnSpellLoad(function()
		local color = addon.db.profile.Font_Color

		local name = spell:GetSpellName()
		local desc = spell:GetSpellDescription()
		local texture = spell:GetSpellTexture()
		infoHeader.button.abilityIcon:SetTexture(texture)
		infoHeader.button.abilityIcon:Show()
		--infoHeader.button.title:SetText(name.." - "..powerID)
		infoHeader.button.title:SetText(name)
		infoHeader.description:SetText(desc..noteText)
		tinsert(addon.fontStrings,infoHeader.description)

		infoHeader.abilitytext = desc
		infoHeader.description:SetWidth(infoHeader:GetWidth() - 30)
		infoHeader:SetHeight(infoHeader.description:GetHeight() + 55)
	end)
end

	infoHeader:Show()
	return infoHeader
end


local function CreateUpgradeFrame(parent, id, index)
	local upgradeInfo = addon.Upgrades[id]
	local item = Item:CreateFromItemID(id)
	local known = C_QuestLog.IsQuestFlaggedCompleted(upgradeInfo[2])
	local spell = Spell:CreateFromSpellID(upgradeInfo[1])
	local infoHeader = CreateFrame("FRAME", "TTG_Upgrades"..index, parent, "TorghastTourGuideInfoTemplate")
	local color = addon.db.profile.Font_Color

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
		tinsert(addon.fontStrings,infoHeader.description)
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
	local color = addon.db.profile.Font_Color


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
	tinsert(addon.fontStrings, f.currentTimeCount)
	f.currentTimeCount:SetPoint("TOPLEFT", 45, -78)
	f.currentTimeCount:SetJustifyH("CENTER")

	f.currentCompleteCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.currentCompleteCount)
	f.currentCompleteCount:SetPoint("TOPLEFT", f.currentTimeCount, "BOTTOMLEFT", 0, -5)
	f.currentCompleteCount:SetJustifyH("CENTER")

	f.currentFloorCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.currentFloorCount)
	f.currentFloorCount:SetPoint("TOPLEFT", f.currentCompleteCount, "BOTTOMLEFT", 0, -5)
	f.currentFloorCount:SetJustifyH("CENTER")

	f.currentPhantasmaCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.currentPhantasmaCount)
	f.currentPhantasmaCount:SetPoint("TOPLEFT", f.currentFloorCount, "BOTTOMLEFT", 0, -5)
	f.currentPhantasmaCount:SetJustifyH("CENTER")

	f.currentAnimaCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.currentAnimaCount)
	f.currentAnimaCount:SetPoint("TOPLEFT", f.currentPhantasmaCount, "BOTTOMLEFT", 0, -5)
	f.currentAnimaCount:SetJustifyH("CENTER")

	f.currentSoulsCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.currentSoulsCount)
	f.currentSoulsCount:SetPoint("TOPLEFT", f.currentAnimaCount, "BOTTOMLEFT", 0, -5)
	f.currentSoulsCount:SetJustifyH("CENTER")

	f.currentChestCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.currentChestCount)
	f.currentChestCount:SetPoint("TOPLEFT", f.currentSoulsCount, "BOTTOMLEFT", 0, -5)
	f.currentChestCount:SetJustifyH("CENTER")

	f.currentQuestCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.currentQuestCount)
	f.currentQuestCount:SetPoint("TOPLEFT", f.currentChestCount, "BOTTOMLEFT", 0, -5)
	f.currentQuestCount:SetJustifyH("CENTER")

	f.currentDeathCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.currentDeathCount)
	f.currentDeathCount:SetPoint("TOPLEFT", f.currentQuestCount, "BOTTOMLEFT", 0, -5)
	f.currentDeathCount:SetJustifyH("CENTER")

	f.currentTrapsCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.currentTrapsCount)
	f.currentTrapsCount:SetPoint("TOPLEFT", f.currentDeathCount, "BOTTOMLEFT", 0, -5)
	f.currentTrapsCount:SetJustifyH("CENTER")

	f.currentgrueCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.currentgrueCount)
	f.currentgrueCount:SetPoint("TOPLEFT", f.currentTrapsCount, "BOTTOMLEFT", 0, -5)
	f.currentgrueCount:SetJustifyH("CENTER")

	f.currentkillCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.currentkillCount)
	f.currentkillCount:SetPoint("TOPLEFT", f.currentgrueCount, "BOTTOMLEFT", 0, -5)
	f.currentkillCount:SetJustifyH("CENTER")

	f.currentKillBreakdown = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.currentKillBreakdown)
	f.currentKillBreakdown:SetPoint("TOPLEFT", f.currentkillCount, "BOTTOMLEFT", 0, -5)
	f.currentKillBreakdown:SetJustifyH("CENTER")

	f.currentpotsCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.currentpotsCount)
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
	tinsert(addon.fontStrings, f.totalTimeCount)
	f.totalTimeCount:SetPoint("TOPLEFT", f.currentBG, "BOTTOMLEFT", 20, -55)
	f.totalTimeCount:SetJustifyH("CENTER")

	f.totalCompleteCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.totalCompleteCount)
	f.totalCompleteCount:SetPoint("TOPLEFT", f.totalTimeCount, "BOTTOMLEFT", 0, -5)
	f.totalCompleteCount:SetJustifyH("CENTER")

	f.totalFloorCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.totalFloorCount)
	f.totalFloorCount:SetPoint("TOPLEFT", f.totalCompleteCount, "BOTTOMLEFT", 0, -5)
	f.totalFloorCount:SetJustifyH("CENTER")

	f.totalPhantasmaCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.totalPhantasmaCount)
	f.totalPhantasmaCount:SetPoint("TOPLEFT", f.totalFloorCount, "BOTTOMLEFT", 0, -5)
	f.totalPhantasmaCount:SetJustifyH("CENTER")

	f.totalAnimaCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.totalAnimaCount)
	f.totalAnimaCount:SetPoint("TOPLEFT", f.totalPhantasmaCount, "BOTTOMLEFT", 0, -5)
	f.totalAnimaCount:SetJustifyH("CENTER")

	f.totalSoulsCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.totalSoulsCount)
	f.totalSoulsCount:SetPoint("TOPLEFT", f.totalAnimaCount, "BOTTOMLEFT", 0, -5)
	f.totalSoulsCount:SetJustifyH("CENTER")

	f.totalChestCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.totalChestCount)
	f.totalChestCount:SetPoint("TOPLEFT", f.totalSoulsCount, "BOTTOMLEFT", 0, -5)
	f.totalChestCount:SetJustifyH("CENTER")

	f.totalQuestCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.totalQuestCount)
	f.totalQuestCount:SetPoint("TOPLEFT", f.totalChestCount, "BOTTOMLEFT", 0, -5)
	f.totalQuestCount:SetJustifyH("CENTER")

	f.totalDeathCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.totalDeathCount)
	f.totalDeathCount:SetPoint("TOPLEFT", f.totalQuestCount, "BOTTOMLEFT", 0, -5)
	f.totalDeathCount:SetJustifyH("CENTER")

	f.totalTrapsCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.totalTrapsCount)
	f.totalTrapsCount:SetPoint("TOPLEFT", f.totalDeathCount, "BOTTOMLEFT", 0, -5)
	f.totalTrapsCount:SetJustifyH("CENTER")

	f.totalgrueCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.totalgrueCount)
	f.totalgrueCount:SetPoint("TOPLEFT", f.totalTrapsCount, "BOTTOMLEFT", 0, -5)
	f.totalgrueCount:SetJustifyH("CENTER")

	f.totalkillCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.totalkillCount)
	f.totalkillCount:SetPoint("TOPLEFT", f.totalgrueCount, "BOTTOMLEFT", 0, -5)
	f.totalkillCount:SetJustifyH("CENTER")

	f.totalKillBreakdown = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.totalKillBreakdown)
	f.totalKillBreakdown:SetPoint("TOPLEFT", f.totalkillCount, "BOTTOMLEFT", 0, -5)
	f.totalKillBreakdown:SetJustifyH("CENTER")

	f.totalpotsCount = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	tinsert(addon.fontStrings, f.totalpotsCount)
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


function addon.CreateRavinousPowerListFrame()
	local f = frames.tg.info.ravPowerScroll.child
	if not f.banner then 
		f.banner = f:CreateTexture(nil, "OVERLAY")
		f.banner:SetAtlas("bonusobjectives-title-bg")
		f.banner:SetPoint("TOPLEFT", 25, -3)
		f.banner:SetPoint("TOPRIGHT", 25, 3)
		f.banner:SetHeight(30)

		f.desc = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		f.desc:SetText(L["Ravenous Anima Cell Powers"])
		f.desc:SetPoint("CENTER", f.banner, 0, 3)
		f.desc:SetJustifyH("CENTER")

		local note = f:CreateFontString(nil, "OVERLAY", "GameFontBlack")
		note:SetPoint("TOPLEFT", f.desc, "BOTTOMLEFT" , -15, -8)
		note:SetPoint("TOPRIGHT", f.desc,15, 0)
		note:SetText(L["Rav_Note"])
	end
	local index = 1
	for name, powerID in pairs(addon.PowerNames) do
		if not f[index] then 
			f[index] = CreatePowerFrame(powerID, f, "TTTG_Powers", index)
		end
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
	local color = addon.db.profile.Font_Color

	f:SetSize(100, 20)
	f:Show()

	f.name = f:CreateFontString(nil, "OVERLAY", "GameFontBlack")
	f.name:SetPoint("LEFT", 9, -3)
	f.name:SetText(L[tostring(mobID)]..":")
	tinsert(addon.fontStrings, f.name)
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
			tinsert(addon.fontStrings, f.power)

		end)
	end

	return f
end


local function CreateRavinousMobListFrame()
	local f = frames.tg.info.ravMobScroll.child
	local zoneIndex = 1
	if f.banner then return end
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


function addon.CreateAnimaPowerListFrame()
	local f = frames.tg.info.animaPowerScroll.child
	local index = 1

	if not f.banner then 
		f.banner = f:CreateTexture(nil, "OVERLAY")
		f.banner:SetAtlas("bonusobjectives-title-bg")
		f.banner:SetPoint("TOPLEFT", 25, -3)
		f.banner:SetPoint("TOPRIGHT", 25, 3)
		f.banner:SetHeight(30)

		f.desc = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		f.desc:SetText(L["Anima Powers"])
		f.desc:SetPoint("CENTER", f.banner, 0, 3)
		f.desc:SetJustifyH("CENTER")
	end

	local lastIndex

	for i, id in ipairs(addon.sortpowers) do
	--for powerID, data in pairs(addon.AnimaPowers) do
		local powerID = id
		local data = addon.AnimaPowers[id]
		f[index] = CreatePowerFrame(powerID, f, "TTG_AnimaPower", index)
		local rarityColor = ITEM_QUALITY_COLORS[data[2]]
		f[index].button.title:SetTextColor(rarityColor.r,rarityColor.g, rarityColor.b )
		f[index]:ClearAllPoints()
		if index == 1 then 
			f[index]:SetPoint("TOPLEFT", 35, -55)
			f[index]:SetPoint("TOPRIGHT", 35, -55)
		else
			f[index]:SetPoint("TOPLEFT", f[index - 1], "BOTTOMLEFT")
			f[index]:SetPoint("TOPRIGHT", f[index - 1], "BOTTOMRIGHT")
		end
		index = index + 1
	end
end


local function addBullets(parent, tipdata)
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

		infoBullet.Text:SetPoint("TOPLEFT", 20, 0)
		infoBullet.Text:SetPoint("TOPRIGHT", -20, 0)
		infoBullet.Text:SetWordWrap(true)
		infoBullet.Text:SetText(data)
		local color = addon.db.profile.Font_Color
		tinsert(addon.fontStrings, infoBullet.Text)

		infoBullet.Text:SetHeight(400)
	--	infoBullet:SetWidth(parent:GetWidth() - 13)
		infoBullet.Text:SetWidth(parent:GetWidth() - 26)
		local textHeight = (math.ceil(infoBullet.Text:GetStringHeight() ))
		if textHeight > 100 then 
			textHeight = textHeight + 40
		elseif textHeight > 40 then 
			textHeight = textHeight + 30
		else
			textHeight = textHeight + 20
		end

		infoBullet.Text:SetHeight(textHeight)
		infoBullet:SetHeight(math.ceil(textHeight) + 5)
		local parentHeight = math.ceil(parent:GetHeight())
		parent:SetHeight(math.ceil(parentHeight + textHeight))

		if (index == 1) then
			infoBullet:SetPoint("TOPLEFT", parent.description, "BOTTOMLEFT" , 0, -10 )
			infoBullet:SetPoint("TOPRIGHT", parent.description, "BOTTOMRIGHT", -4, -10)

		else
			infoBullet:SetPoint("TOPLEFT", parent.bullets[index - 1], "BOTTOMLEFT", 0, 0)
			infoBullet:SetPoint("TOPRIGHT", parent.bullets[index - 1], "BOTTOMRIGHT", 0, -0)
		end

		parent.descriptionBG:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 5)
	end
end


function addon.CreateTormentListFrame()
	local f = frames.tg.info.tormentScroll.child
	local index = 1

	if not f.banner then 
		f.banner = f:CreateTexture(nil, "OVERLAY")
		f.banner:SetAtlas("bonusobjectives-title-bg")
		f.banner:SetPoint("TOPLEFT", 25, -3)
		f.banner:SetPoint("TOPRIGHT", 25, 3)
		f.banner:SetHeight(30)

		f.desc = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		f.desc:SetText(L["Torments"])
		f.desc:SetPoint("CENTER", f.banner, 0, 3)
		f.desc:SetJustifyH("CENTER")
	end
	local lastIndex

	f[index] = CreatePowerFrame(0, f, "TTG_Torment", index)
		f[index].button.title:SetText(L["Number of Torments Per Layer"])
		f[index].description:SetText(L["Torment_Count"])
				f[index]:SetHeight(f[index].description:GetHeight() + 55)


	for i, spellData in ipairs(addon.TormentNames) do
		local index = i + 1
		local powerID 

		for name, spellID in pairs(spellData) do
			powerID = spellID
		end
		--local data = addon.AnimaPowers[id]
		f[index] = CreatePowerFrame(powerID, f, "TTG_Torment", index)
		f[index].weight:Hide()
		--local rarityColor = ITEM_QUALITY_COLORS[data[2]]
		--f[index].button.title:SetTextColor(rarityColor.r,rarityColor.g, rarityColor.b )
				addon.SetUpOverview(powerID, index)
		addBullets(f[index], addon.TormentTips[powerID])
		f[index]:ClearAllPoints()
		if index == 1 then 
			f[index]:SetPoint("TOPLEFT", 35, -55)
			f[index]:SetPoint("TOPRIGHT", 35, -55)
		else
			f[index]:SetPoint("TOPLEFT", f[index - 1], "BOTTOMLEFT", 0, -10)
			f[index]:SetPoint("TOPRIGHT", f[index - 1], "BOTTOMRIGHT", 0, -10)
		end

		--addon.SetUpTips(addon.TormentTips[spellID], frames.tg.info.detailsScroll.child.overviews[index -1])

		index = index + 1

	end


end


function addon.CreateBlessingListFrame()
	local f = frames.tg.info.blessingsScroll.child
	local index = 1

	if not f.banner then 
		f.banner = f:CreateTexture(nil, "OVERLAY")
		f.banner:SetAtlas("bonusobjectives-title-bg")
		f.banner:SetPoint("TOPLEFT", 25, -3)
		f.banner:SetPoint("TOPRIGHT", 25, 3)
		f.banner:SetHeight(30)

		f.desc = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		f.desc:SetText(L["Blessings"])
		f.desc:SetPoint("CENTER", f.banner, 0, 3)
		f.desc:SetJustifyH("CENTER")
	end

	local lastIndex

	for i, spellData in ipairs(addon.BlessingNames) do
		local indes = i + 1
		local powerID
		for name, spellID in pairs(spellData) do
		 powerID = spellID

		end
		f[index] = CreatePowerFrame(powerID, f, "TTG_Blessings", index)
		f[index].weight:Hide()
		addon.SetUpOverview(powerID, index)
		addBullets(f[index], addon.BlessingTips[powerID])
		f[index]:ClearAllPoints()
		if index == 1 then 
			f[index]:SetPoint("TOPLEFT", 35, -55)
			f[index]:SetPoint("TOPRIGHT", 35, -55)
		else
			f[index]:SetPoint("TOPLEFT", f[index - 1], "BOTTOMLEFT", 0, -10)
			f[index]:SetPoint("TOPRIGHT", f[index - 1], "BOTTOMRIGHT", 0, -10)
		end
		index = index + 1
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
	elseif tab == 7 then 
		self.tooltip = L["Anima Powers"]
	elseif tab == 8 then 
		self.tooltip = L["Torments"]
	elseif tab == 9 then 
		self.tooltip = L["Blessings"]
	elseif tab == 10 then 
		self.tooltip = L["Box of Many Things"]
	elseif tab == 11 then 
		self.tooltip = L["Torghast Scoring"]
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
	local f = TorghastTourGuide --CreateFrame("Frame", "TorghastTourGuide", UIParent, "TorghastTourGuideTemplate")
	frames.tg = f
	tinsert(UISpecialFrames,"TorghastTourGuide")

	CreateStatsFrame(f)
	CreateUpgradeListFrame(f)
	addon.CreateRavinousPowerListFrame()
	CreateRavinousMobListFrame()
	addon.CreateAnimaPowerListFrame()
	addon.CreateBlessingListFrame()
	addon.CreateTormentListFrame()
	addon.CreateRareButtons()
	addon.CreateBossButtons()
	addon.DisplayCreature(152253)
	addon.SetUpBoxFrame()
	--addon.SetUpScoreFrame()
	addon:UpdateFonts()

	addon.SetTab(1)

	f.info.LinkButton:SetScript("OnEnter", function(self) addon.ShowTooltip(self, L["WoWHead Links"]) end)
	f.info.LinkButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	f.info.LinkButton:SetScript("OnClick", function(self) addon.ToggleLinkWindow() end)
	f:SetScript("OnShow", function()
		addon.SortPowersList()
		addon.RefreshConfig()
		f:SetScript("OnShow", function() end)
	end)
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
TTG_Tabs[7] = {frame = "animaPowerScroll", button = "animaTab"}
TTG_Tabs[8] = {frame = "tormentScroll", button = "TormentTab"}
TTG_Tabs[9] = {frame = "blessingsScroll", button = "BlessingsTab"}
TTG_Tabs[10] = {frame = "boxScroll", button = "boxTab"}
TTG_Tabs[11] = {frame = "scoringScroll", button = "scoringTab"}
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

	if  tabType == 7 then
		info.ravMobScroll:Hide()
		info.model:Hide()
	elseif tabType == 3 then
		info.ravMobScroll:Show()
		info.model:Hide()
	elseif tabType == 8  or tabType ==9 or tabType == 10 or tabType== 11 then
		info.ravMobScroll:Hide()
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

		if tabType == 10 then
		TTG_OrderHallTalentFrame:Show()
	else
		TTG_OrderHallTalentFrame:Hide()
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
	note:SetPoint("TOPRIGHT", f.banner,-15, 0)
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

			if frameindex[index].weight then
				frameindex[index].weight:Hide()
			end

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
			infoBullet:SetPoint("TOPLEFT", parent.tips, "BOTTOMLEFT" , 15, -10 )
			infoBullet:SetPoint("TOPRIGHT", parent.tips, "BOTTOMRIGHT", -4, -10)

		else
			infoBullet:SetPoint("TOPLEFT", parent.bullets[index - 1], "BOTTOMLEFT", 0, -9)
			infoBullet:SetPoint("TOPRIGHT", parent.bullets[index - 1], "BOTTOMRIGHT", 0, -9)
		end

		infoBullet.Text:SetPoint("TOPLEFT", 20, 0)
		infoBullet.Text:SetPoint("TOPRIGHT", -20, 0)
		infoBullet.Text:SetWordWrap(true)
		infoBullet.Text:SetText(data)
		local color = addon.db.profile.Font_Color
		tinsert(addon.fontStrings, infoBullet.Text)

		infoBullet.Text:SetHeight(200)
	--	infoBullet:SetWidth(parent:GetWidth() - 13)
		infoBullet.Text:SetWidth(parent.tips:GetWidth() - 26)
		infoBullet:SetHeight(infoBullet.Text:GetStringHeight() + 5)
		parent.tips.descriptionBG:SetPoint("BOTTOMRIGHT", infoBullet, "BOTTOMRIGHT", 0, -3)
	end
end

local BoxTips = {
	{L["Tier1_Tips1"], L["Tier1_Tips2"],L["Tier1_Tips3"]},
	{L["Tier2_Tips1"], L["Tier2_Tips2"],L["Tier2_Tips3"]},
	{L["Tier3_Tips1"], L["Tier3_Tips2"],},
	{L["Tier4_Tips1"], L["Tier4_Tips2"],L["Tier4_Tips3"]},
	{L["Tier5_Tips1"], L["Tier5_Tips2"],L["Tier5_Tips3"]},
	{L["Tier6_Tips1"], L["Tier6_Tips2"],},
}


function addon.SetUpBoxFrame()
	local f = frames.tg.info.boxScroll.child
	if not f.banner then 
		f.banner = f:CreateTexture(nil, "OVERLAY")
		f.banner:SetAtlas("bonusobjectives-title-bg")
		f.banner:SetPoint("TOPLEFT", 25, -3)
		f.banner:SetPoint("TOPRIGHT", 25, 3)
		f.banner:SetHeight(30)

		f.desc = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		f.desc:SetText(L["Box of Many Things"])
		f.desc:SetPoint("CENTER", f.banner, 0, 3)
		f.desc:SetJustifyH("CENTER")
	end

	for index, data in ipairs(BoxTips) do
		f[index] = CreatePowerFrame(0, f, "TTG_BoxInfo", index)
		local frame = f[index]
		frame.button.title:SetText(L["Layer %s:"]:format(index))
		frame.description:SetText("")
		addBullets(frame, data)
		--frame.bullets[1]:ClearAllPoints()
		frame.bullets[1]:SetPoint("TOPLEFT", frame.description, "TOPLEFT" , 0, -2 )

		frame:ClearAllPoints()
		if index == 1 then 
			frame:SetPoint("TOPLEFT", 25, -50)
			frame:SetPoint("TOPRIGHT", 25, -50)
		else
			frame:SetPoint("TOPLEFT", f[index - 1], "BOTTOMLEFT", 0, -10)
			frame:SetPoint("TOPRIGHT", f[index - 1], "BOTTOMRIGHT", 0, -10)
		end
	end
end



local ScoreTable = {
{"Completion","Earned by defeating enemies, freeing Soul Remnants, and destroying Ashen Phylacteries","Up to 100"},
{"Time","Score based on if you are below or above the 'par time' for the Layer","Up to 50"},
{"Empowered Bonus","Bonus Points gained from actions while Empowered","Based on Player Usage"},
}
    function addon:Levels(parent)
        -- log(format("Historia levels"))
        --  Define the container frame for the level frames (MC  = Middle container)
        local Table_MC = CreateFrame("FRAME", nil , parent);
        Table_MC:SetPoint("TOPLEFT" , parent, 0, 0)
        Table_MC:SetPoint("BOTTOMRIGHT" ,parent, 0, 32)
     -- Table_MC:SetPoint("BOTTOM" ,parent, 0, 32)
      --  Table_MC:SetPoint("LEFT" ,parent, 32, 0)
       -- Table_MC:SetPoint("RIGHT" ,parent, -32, 0)

     ---Score Type	Description	Point Value
        --  Define the frame for the first group of levels (ML1 = Middle Level one)            
        local Table_ScoreType = CreateFrame("FRAME", nil, Table_MC);
        Table_ScoreType:SetPoint("TOPLEFT" ,Table_MC, 5, -5)
        Table_ScoreType:SetWidth(200)
        Table_ScoreType:SetHeight(35)
        --Table_ScoreType:SetPoint("BOTTOMRIGHT" ,Table_MC, "LEFT", 80, 0)
       -- Table_ScoreType:SetPoint("LEFT" ,Table_MC, 0, 0)
        --Table_ScoreType:SetPoint("RIGHT" ,Table_MC, "LEFT", 40, 0)

                       
        --  Define the frame for the first group of dates (MD1 = Middle Date one)              
        local Table_Description = CreateFrame("FRAME", nil, Table_MC);
        Table_Description:SetPoint("TOP" ,Table_MC, "TOP", 0, -5)
        Table_Description:SetWidth(200)
        Table_Description:SetHeight(35)


        --Table_Description:SetPoint("TOPLEFT" ,Table_ScoreType, "TOPRIGHT", 0, -0)
        --Table_Description:SetPoint("BOTTOMLEFT" ,Table_ScoreType,"LEFT", 200, 0)
       -- Table_Description:SetPoint("BOTTOMLEFT" ,Table_MC, 36, 0)
        --Table_Description:SetPoint("RIGHT" ,Table_MC, "LEFT", 200, 0)

        --  Define the frame for the first group of dates (MD1 = Middle Date one)              
        local Table_PointValue = CreateFrame("FRAME", nil, Table_MC);
        --Table_PointValue:SetPoint("TOP" ,Table_MC, 0, -0)
       -- Table_PointValue:SetPoint("BOTTOM" ,Table_MC, 0, 0)
        --Table_PointValue:SetPoint("LEFT" ,Table_MC, 36, 0)
        --Table_PointValue:SetPoint("RIGHT" ,Table_MC, "LEFT", 400, 0)
        Table_PointValue:SetPoint("TOPRIGHT" ,Table_MC, -5, -05)
        Table_PointValue:SetWidth(200)
        Table_PointValue:SetHeight(35)
                  
                       
        --  Define the header fontstring for the first group of levels (HLML1 = Historia Level ML1) 
        local Table_ScoreType_FontString = Table_ScoreType:CreateFontString(nil, "ARTWORK", "GameFontWhite")
        Table_ScoreType_FontString:SetPoint("TOP" ,Table_ScoreType, 0, 0)
        Table_ScoreType_FontString:SetText(L["Score type"])

        --  Define the header fontstring for the first group of dates (HLML1 = Historia Date ML1) 
        local Table_Description_FontType = Table_Description:CreateFontString(nil, "ARTWORK", "GameFontWhite")
        Table_Description_FontType:SetPoint("TOP" ,Table_Description, 0, 0)
        Table_Description_FontType:SetText(L["Description"]) 

        local TablePoints_FontType = Table_PointValue:CreateFontString(nil, "ARTWORK", "GameFontWhite")
        TablePoints_FontType:SetPoint("TOP" ,Table_PointValue, 0, 0)
        TablePoints_FontType:SetText(L["Point Value"])  
        --  Set the levels and the date in the UI
        for i, data in ipairs(ScoreTable) do
        	local offset = -(i+1)*20
        	if i == 1 then 
        		offset = -25
        	end

            local HLML1L1 = Table_ScoreType:CreateFontString("HLML1L1", "ARTWORK", "GameFontWhite")
                HLML1L1:SetPoint("TOP", Table_ScoreType, 0, offset)
                --HLML1L1:SetText(tostring(HistoriaLocalDb.Level[i].level))
                HLML1L1:SetText(data[1])
            local HLML1D1 = Table_Description:CreateFontString("HLML1D1", "ARTWORK", "GameFontNormal")
                HLML1D1:SetPoint("TOP" ,Table_Description, "TOP", 0, offset)
                HLML1D1:SetWidth(350)
                HLML1D1:SetWordWrap(true)  

                ---HLML1D1:SetText(format(date("%a, %b %d %Y %H:%M", HistoriaLocalDb.Level[i].time)))  
            HLML1D1:SetText(data[2]) 
            local HLML1D3= Table_PointValue:CreateFontString("HLML1D3", "ARTWORK", "GameFontNormal")
                HLML1D3:SetPoint("TOP" ,Table_PointValue, "TOP", 0, offset)
                ---HLML1D1:SetText(format(date("%a, %b %d %Y %H:%M", HistoriaLocalDb.Level[i].time)))  
            HLML1D3:SetText(data[3])   
        end
    end


function addon.SetUpScoreFrame()
	local f = frames.tg.info.scoringScroll.child
	if not f.banner then 
		f.banner = f:CreateTexture(nil, "OVERLAY")
		f.banner:SetAtlas("bonusobjectives-title-bg")
		f.banner:SetPoint("TOPLEFT", 25, -3)
		f.banner:SetPoint("TOPRIGHT", 25, 3)
		f.banner:SetHeight(30)

		f.desc = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		f.desc:SetText(L["Torghast Scoring"])
		f.desc:SetPoint("CENTER", f.banner, 0, 3)
		f.desc:SetJustifyH("CENTER")
	end

f[1] = CreatePowerFrame(0, f, "TTG_ScoringInfo", 1)
f[1].button.title:SetText("")
	addon:Levels(f[1])

--[[	for index, data in ipairs(BoxTips) do
		f[index] = CreatePowerFrame(0, f, "TTG_BoxInfo", index)
		local frame = f[index]
		frame.button.title:SetText(L["Layer %s:"]:format(index))
		frame.description:SetText("")
		addBullets(frame, data)
		--frame.bullets[1]:ClearAllPoints()
		frame.bullets[1]:SetPoint("TOPLEFT", frame.description, "TOPLEFT" , 0, -2 )

		frame:ClearAllPoints()
		if index == 1 then 
			frame:SetPoint("TOPLEFT", 25, -50)
			frame:SetPoint("TOPRIGHT", 25, -50)
		else
			frame:SetPoint("TOPLEFT", f[index - 1], "BOTTOMLEFT", 0, -10)
			frame:SetPoint("TOPRIGHT", f[index - 1], "BOTTOMRIGHT", 0, -10)
		end
	end]]
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
	tinsert(addon.fontStrings,infoHeader.description)
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



local Media = LibStub("LibSharedMedia-3.0")
function addon:UpdateFonts()
	local fontStrings = addon.fontStrings
	local color = addon.db.profile.Font_Color
	local font = Media:Fetch('font',addon.db.profile.Font_Type)
	local Font_Size = addon.db.profile.Font_Size

	for i, f in ipairs(fontStrings) do
		f:SetTextColor(color.r,color.g, color.b )
		local fon
   		f:SetFont(font, Font_Size)
   		--print(f:GetFont())
    end
end

