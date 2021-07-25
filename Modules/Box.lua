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


local isThemed = false

local TalentUnavailableReasons = {};
TalentUnavailableReasons[Enum.GarrisonTalentAvailability.UnavailableAnotherIsResearching] = ORDER_HALL_TALENT_UNAVAILABLE_ANOTHER_IS_RESEARCHING;
TalentUnavailableReasons[Enum.GarrisonTalentAvailability.UnavailableNotEnoughGold] = ORDER_HALL_TALENT_UNAVAILABLE_NOT_ENOUGH_GOLD;
TalentUnavailableReasons[Enum.GarrisonTalentAvailability.UnavailableTierUnavailable] = ORDER_HALL_TALENT_UNAVAILABLE_TIER_UNAVAILABLE;
TalentUnavailableReasons[Enum.GarrisonTalentAvailability.UnavailableRequiresPrerequisiteTalent] = ORDER_HALL_TALENT_UNAVAILABLE_REQUIRES_PREREQUISITE_TALENT;

local CHOICE_BACKGROUND_OFFSET_Y = 10;
local BACKGROUND_WITH_INSET_OFFSET_Y = 0;
local BACKGROUND_NO_INSET_OFFSET_Y = 44;

local BORDER_ATLAS_NONE = nil;
local BORDER_ATLAS_UNAVAILABLE = "orderhalltalents-spellborder";
local BORDER_ATLAS_AVAILABLE = "orderhalltalents-spellborder-green";
local BORDER_ATLAS_SELECTED = "orderhalltalents-spellborder-yellow";

local TORGHAST_TALENT_SELECTED_SCRIPTED_ANIMATION_EFFECT_ID = 132;

local function CustomTorghastTalentErrorCallback(talent)
	if (talent.talentAvailability == Enum.GarrisonTalentAvailability.UnavailableNotEnoughResources) then
		return ERR_TORGHAST_TALENT_CANT_AFFORD_TALENT;
	end
end

local TORGHAST_TALENT_TREE_ID = 461;
local TORGHAST_GARRISON_ID = 111

local Torghast_TalentTreeLayoutOptions = 
{
	buttonInfo = {
		[Enum.GarrTalentType.Standard] = { size = 39, spacingX = 21, spacingY = 29 },
		[Enum.GarrTalentType.Major] = { size = 46, spacingX = 21, spacingY = 29 },
	},
	spacingTop = 97,
	spacingBottom = 49,
	spacingHorizontal = 144,
	minimumWidth = 336,
	canHaveBackButton = false,
	singleCost = false,
	showUnffordableAsAvailable = true,
	talentSelectedEffect = TORGHAST_TALENT_SELECTED_SCRIPTED_ANIMATION_EFFECT_ID,
	customUnavailableTalentErrorCallback = CustomTorghastTalentErrorCallback,
	researchSoundStandard = SOUNDKIT.UI_ORDERHALL_TITAN_MINOR_TALENT_SELECT,
	researchSoundMajor = SOUNDKIT.UI_ORDERHALL_TITAN_MAJOR_TALENT_SELECT,
};

local function FramePool_HideAndClearAnchorsWithResetCallback(pool, frame)
	FramePool_HideAndClearAnchors(pool, frame);
	frame:OnFramePoolReset();
end

local function GetTalentTreeLayoutOptions(garrTalentTreeID)
	return Torghast_TalentTreeLayoutOptions;
end

local function GetResearchSoundForTalentType(talentType)
	local garrTalentTreeID = TORGHAST_TALENT_TREE_ID	
	local layoutOptions = GetTalentTreeLayoutOptions(garrTalentTreeID);
	if talentType == Enum.GarrTalentType.Major then
		return layoutOptions.researchSoundMajor;
	else
		return layoutOptions.researchSoundStandard;
	end
	return SOUNDKIT.UI_ORDERHALL_TALENT_SELECT;
end


TTG_OrderHallTalentFrameMixin = { }

function TTG_OrderHallTalentFrameMixin:OnLoad()
	self.buttonPool = CreateFramePool("BUTTON", self, "TTG_GarrisonTalentButtonTemplate", FramePool_HideAndClearAnchorsWithResetCallback);
	self.prerequisiteArrowPool = CreateFramePool("FRAME", self, "TTG_GarrisonTalentPrerequisiteArrowTemplate");	
	self.talentRankPool = CreateFramePool("FRAME", self, "TalentRankDisplayTemplate");
	self.choiceTexturePool = CreateTexturePool(self, "BACKGROUND", 1, "TTG_GarrisonTalentChoiceTemplate");
	self.arrowTexturePool = CreateTexturePool(self, "BACKGROUND", 2, "TTG_GarrisonTalentArrowTemplate");
	self.buttonAnimationPool = CreateFramePool("FRAME", self, "TTG_GarrisonTalentButtonAnimationTemplate", FramePool_HideAndClearAnchorsWithResetCallback);
	self.researchingTalentID = 0;
	self.garrisonType = TORGHAST_GARRISON_ID;
	self.garrTalentTreeID = TORGHAST_TALENT_TREE_ID;
	self.currency = C_Garrison.GetGarrisonTalentTreeCurrencyTypes(461);

	self:RefreshAllData()
end

function TTG_OrderHallTalentFrameMixin:OnShow()
	self:RefreshAllData();
	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
	self:RegisterEvent("GARRISON_TALENT_UPDATE");
    self:RegisterEvent("GARRISON_TALENT_COMPLETE");
	self:RegisterEvent("GARRISON_TALENT_NPC_CLOSED");
	self:RegisterEvent("SPELL_TEXT_UPDATE");
	PlaySound(SOUNDKIT.UI_ORDERHALL_TALENT_WINDOW_OPEN);
end

function TTG_OrderHallTalentFrameMixin:OnHide()
	self:UnregisterEvent("CURRENCY_DISPLAY_UPDATE");
	self:UnregisterEvent("GARRISON_TALENT_UPDATE");
    self:UnregisterEvent("GARRISON_TALENT_COMPLETE");
	self:UnregisterEvent("GARRISON_TALENT_NPC_CLOSED");
	self:UnregisterEvent("SPELL_TEXT_UPDATE");

	self:ReleaseAllPools();
	PlaySound(SOUNDKIT.UI_ORDERHALL_TALENT_WINDOW_CLOSE);
end

function TTG_OrderHallTalentFrameMixin:OnEvent(event, ...)
	if (event == "CURRENCY_DISPLAY_UPDATE" or event == "GARRISON_TALENT_UPDATE" or event == "GARRISON_TALENT_COMPLETE") then
		self:RefreshAllData();
	elseif event == "SPELL_TEXT_UPDATE" then
		self:RefreshAllData();
	end
end

function TTG_OrderHallTalentFrameMixin:EscapePressed()
end

function TTG_OrderHallTalentFrameMixin:OnUpdate()
	if (self.triedRefreshing and not self.refreshing) then
		self:RefreshAllData();
	end
end

function TTG_OrderHallTalentFrameMixin:ReleaseAllBasePools()
	self.buttonPool:ReleaseAll();
	self.talentRankPool:ReleaseAll();
	self.choiceTexturePool:ReleaseAll();
	self.arrowTexturePool:ReleaseAll();
	self.prerequisiteArrowPool:ReleaseAll();
end

function TTG_OrderHallTalentFrameMixin:ReleaseAllPools()
	self:ReleaseAllBasePools();
	self.buttonAnimationPool:ReleaseAll();
end

function TTG_OrderHallTalentFrameMixin:GetFormattedCurrencyTooltipText(tooltipFormat)
	return tooltipFormat:format(C_CurrencyInfo.GetCurrencyInfo(self.currency).name);
end

function TTG_OrderHallTalentFrameMixin:CheckSpendTutorial()
end

function TTG_OrderHallTalentFrameMixin:GetActiveAnimationFrame(talentID)
	for buttonAnimationFrame in self.buttonAnimationPool:EnumerateActive() do
		if buttonAnimationFrame:GetTalentID() == talentID then
			return buttonAnimationFrame;
		end
	end

	return nil;
end

function TTG_OrderHallTalentFrameMixin:AcquireAnimationFrame(talentID)
	local activeAnimationFrame = self:GetActiveAnimationFrame(talentID);
	if activeAnimationFrame ~= nil then
		return activeAnimationFrame;
	end

	local buttonAnimationFrame = self.buttonAnimationPool:Acquire();
	buttonAnimationFrame:SetTalentID(talentID);
	return buttonAnimationFrame;
end

function TTG_OrderHallTalentFrameMixin:RefreshCurrency()
	local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(self.currency);
	local amount = BreakUpLargeNumbers(currencyInfo.quantity);
	self.Currency.Text:SetText(amount);
	self.Currency.Icon:SetTexture(currencyInfo.iconFileID);
	self.Currency:MarkDirty();
end

local function SortTree(talentA, talentB)
	if talentA.tier ~= talentB.tier then
		return talentA.tier < talentB.tier;
	end
	-- want to process dependencies last on a tier
	local hasPrereqA = (talentA.prerequisiteTalentID ~= nil);
	local hasPrereqB = (talentB.prerequisiteTalentID ~= nil);
	if hasPrereqA ~= hasPrereqB then
		return not hasPrereqA;
	end	
	if talentA.uiOrder ~= talentB.uiOrder then
		return talentA.uiOrder < talentB.uiOrder;
	end
	return talentA.id < talentB.id;
end

function TTG_OrderHallTalentFrameMixin:RefreshAllData()
	if (self.refreshing) then
		if (not self.triedRefreshing) then
			self.triedRefreshing = true;
			self:SetScript("OnUpdate", self.OnUpdate);
		end
		return;
	end

	self.refreshing = true;
	self.triedRefreshing = false;
	self:SetScript("OnUpdate", nil);

	self:ReleaseAllBasePools();

	self:RefreshCurrency();
	local garrTalentTreeID = TORGHAST_TALENT_TREE_ID
	TTG_OrderHallTalentFrame.garrisonType = TORGHAST_GARRISON_ID
	if (garrTalentTreeID == nil or garrTalentTreeID == 0) then
		local playerClass = select(3, UnitClass("player"));
		local treeIDs = C_Garrison.GetTalentTreeIDsByClassID(TTG_OrderHallTalentFrame.garrisonType, playerClass);
		if (treeIDs and #treeIDs > 0) then
			garrTalentTreeID = treeIDs[1];
		end
	end

	local treeInfo = C_Garrison.GetTalentTreeInfo(garrTalentTreeID);
	local talents = treeInfo.talents;
	if #talents == 0 then
		self.refreshing = false;
		return;
	end

	table.sort(talents, SortTree);

	local talentTreeType = C_Garrison.GetGarrisonTalentTreeType(garrTalentTreeID);
	local layoutOptions = GetTalentTreeLayoutOptions(garrTalentTreeID);

	local showSingleCost = false;
	if layoutOptions.singleCost then
		local costString = GetGarrisonTalentCostString(talents[1]);
		if costString then
			self.SingleCost:SetFormattedText(RESEARCH_COST, costString);
			showSingleCost = true;
		end
	end
	self.SingleCost:SetShown(showSingleCost);

	self.Inset:Show();
	self.Currency:ClearAllPoints();

	local layoutName;
	self.Currency:SetPoint("TOPRIGHT", self, "TOPRIGHT", -12, -70);
	self.Currency.Icon:SetSize(27, 26);
	self.Background:SetPoint("TOPLEFT", self.Inset, 0, BACKGROUND_WITH_INSET_OFFSET_Y);

	local isClassAgnostic = treeInfo.isClassAgnostic;
	local isThemed = treeInfo.isThemed;
	local title = treeInfo.title;

	local textureKit = treeInfo.textureKit;
	self.Background:SetAtlas(textureKit.."-background");
	local atlas = textureKit.."-logo";

	if NPCFriendshipStatusBar:GetParent() == self then
		NPCFriendshipStatusBar:Hide();
	end
	self.Currency:Show();
	self.CurrencyHitTest:Show();


	-- ticks: these are the roman numerals on the left side of each tier
	local maxTierIndex = talents[#talents].tier + 1;
	for i = 1, #self.FrameTick do
		local shown = not isClassAgnostic and i <= maxTierIndex;
		self.FrameTick[i]:SetShown(shown);
	end

    local completeTalent = C_Garrison.GetCompleteTalent(self.garrisonType);
	local researchingTalentID = self:GetResearchingTalentID();
	local researchingTalentTier = 0;

	local currentTier = nil;
	local currentTierTotalTalentCount, currentTierBaseTalentCount, currentTierDependentTalentCount, currentTierResearchableTalentCount, currentTierTalentIndex, currentTierWidth, currentTierHeight;
	local contentOffsetY = layoutOptions.spacingTop;
	local maxContentWidth = 0;
	
	local function EvaluateCurrentTier(startingIndex)
		currentTierTotalTalentCount = 0;
		currentTierDependentTalentCount = 0;
		currentTierResearchableTalentCount = 0;
		currentTierTalentIndex = 0;
		currentTierWidth = 0;
		currentTierHeight = 0;
		
		for i = startingIndex, #talents do
			local talent = talents[i];
			if talent.tier ~= currentTier then
				break;
			end
			currentTierTotalTalentCount = currentTierTotalTalentCount + 1;
			if talent.prerequisiteTalentID then
				currentTierDependentTalentCount = currentTierDependentTalentCount + 1;
			end
			-- research stuff
			if talent.talentAvailability == Enum.GarrisonTalentAvailability.Available then
				currentTierResearchableTalentCount = currentTierResearchableTalentCount + 1;
			end
			talent.hasInstantResearch = talent.researchDuration == 0;
			if talent.id == researchingTalentID and talent.hasInstantResearch then
				if not talent.selected then
					talent.selected = true;
				end
				researchingTalentTier = talent.tier;
			end
		end
		currentTierBaseTalentCount = currentTierTotalTalentCount - currentTierDependentTalentCount;
	end

	-- position talent buttons
	for talentIndex, talent in ipairs(talents) do
		local buttonInfo = layoutOptions.buttonInfo[talent.type];

		if talent.tier ~= currentTier then
			maxContentWidth = math.max(maxContentWidth, currentTierWidth or 0);
			if currentTier then
				contentOffsetY = contentOffsetY + (currentTierHeight or 0) + buttonInfo.spacingY;
			end
			currentTier = talent.tier;
			EvaluateCurrentTier(talentIndex);
		end
		currentTierTalentIndex = currentTierTalentIndex + 1;
		currentTierWidth = currentTierWidth + buttonInfo.size;
		currentTierHeight = math.max(currentTierHeight, buttonInfo.size);
		if currentTierTalentIndex > 1 then
			currentTierWidth = currentTierWidth + buttonInfo.spacingX;	-- need a solve if a row has mixed talent types
		end

		local talentFrame = self.buttonPool:Acquire();
		talentFrame:SetSize(buttonInfo.size, buttonInfo.size);
		talentFrame.Icon:SetTexture(talent.icon);

		talentFrame:SetTalent(talent, layoutOptions.talentSelectedEffect, layoutOptions.customUnavailableTalentErrorCallback);

		if (talent.isBeingResearched and not talent.hasInstantResearch) then
			talentFrame.Cooldown:SetCooldownUNIX(talent.startTime, talent.researchDuration);
			talentFrame.Cooldown:Show();
			talentFrame.AlphaIconOverlay:Show();
			talentFrame.AlphaIconOverlay:SetAlpha(0.7);
			talentFrame.CooldownTimerBackground:Show();
			if (not talentFrame.timer) then
				talentFrame.timer = C_Timer.NewTicker(1, function() talentFrame:Refresh(); end);
			end
		end
		local selectionAvailableInstantResearch = true;
		if (researchingTalentID ~= 0 and researchingTalentTier == talent.tier and researchingTalentID ~= talent.id) then
			selectionAvailableInstantResearch = false;
		end

		-- Clear "Research Talent" status if the talent is not isBeingResearched
		if (talent.id == researchingTalentID and not talent.isBeingResearched) then
			self:ClearResearchingTalentID();
		end

		local isAvailable = talent.talentAvailability == Enum.GarrisonTalentAvailability.Available;
		local overrideDisplayAsAvailable = layoutOptions.showUnffordableAsAvailable and (talent.talentAvailability == Enum.GarrisonTalentAvailability.UnavailableNotEnoughResources);
		local isZeroRank = talent.talentRank == 0;

		local borderAtlas = BORDER_ATLAS_NONE;
		if (talent.isBeingResearched) then
			borderAtlas = BORDER_ATLAS_SELECTED;
		elseif (talentTreeType == Enum.GarrTalentTreeType.Tiers and talent.selected and selectionAvailableInstantResearch) then
			borderAtlas = BORDER_ATLAS_SELECTED;
		elseif (talentTreeType == Enum.GarrTalentTreeType.Classic and talent.researched) then
			borderAtlas = BORDER_ATLAS_SELECTED;
		else
			-- We check for Enum.GarrisonTalentAvailability.UnavailableAlreadyHave to avoid a bug with
			-- the Chromie UI (talents would flash grey when you switched to another talent in the same row).
			local canDisplayAsAvailable = talent.talentAvailability == Enum.GarrisonTalentAvailability.UnavailableAnotherIsResearching or talent.talentAvailability == Enum.GarrisonTalentAvailability.UnavailableAlreadyHave;
			local shouldDisplayAsAvailable = (canDisplayAsAvailable or overrideDisplayAsAvailable) and talent.hasInstantResearch;
			-- Show as available: this is a new tier which you don't have any talents from or and old tier that you could change.
			-- Note: For instant talents, to support the Chromie UI, we display as available even when another talent is researching (Jeff wants it this way).
			if (isAvailable or shouldDisplayAsAvailable) then
				if ( currentTierResearchableTalentCount < currentTierTotalTalentCount and talentTreeType == Enum.GarrTalentTreeType.Tiers ) then
					talentFrame.AlphaIconOverlay:Show();
					talentFrame.AlphaIconOverlay:SetAlpha(0.5);
				else
					borderAtlas = BORDER_ATLAS_AVAILABLE;
				end

			-- Show as unavailable: You have not unlocked this tier yet or you have unlocked it but another research is already in progress.
			else
				borderAtlas = BORDER_ATLAS_UNAVAILABLE;
				talentFrame.Icon:SetDesaturated(isZeroRank);
			end
		end
		talentFrame:SetBorder(borderAtlas);
		talentFrame.MajorGlow:SetShown(borderAtlas == BORDER_ATLAS_AVAILABLE and talent.type == Enum.GarrTalentType.Major);

		-- Show the current talent rank if the talent had multiple ranks
		if talent.talentMaxRank > 1 then
			local isDisabled = (isZeroRank and not isAvailable and not overrideDisplayAsAvailable);
			local talentRankFrame = self.talentRankPool:Acquire();
			talentRankFrame:SetPoint("BOTTOMRIGHT", talentFrame, 15, -12);
			talentRankFrame:SetFrameLevel(10);
			talentRankFrame:SetValues(talent.talentRank, talent.talentMaxRank, isDisabled, isAvailable or overrideDisplayAsAvailable);
			talentRankFrame:Show();
		end

		if talent.prerequisiteTalentID then
			local prereqTalentButton = self:FindTalentButton(talent.prerequisiteTalentID);
			if prereqTalentButton then
				if prereqTalentButton.talent.uiOrder < talent.uiOrder then
					talentFrame:SetPoint("LEFT", prereqTalentButton, "RIGHT", buttonInfo.spacingX, 0);
				else
					talentFrame:SetPoint("RIGHT", prereqTalentButton, "LEFT", -buttonInfo.spacingX, 0);
				end
				self:AddPrerequisiteArrow(talentFrame, prereqTalentButton);
			end
		else
			local middleTalentIndex = math.ceil(currentTierBaseTalentCount / 2);
			-- there should only be a talent in the center spot if the count is odd
			if mod(currentTierBaseTalentCount, 2) == 0 then
				middleTalentIndex = middleTalentIndex + 0.5;
			end
			local offsetX = currentTierTalentIndex - middleTalentIndex;
			offsetX = offsetX * (buttonInfo.size + buttonInfo.spacingX);
			talentFrame:SetPoint("TOP", offsetX, -contentOffsetY);
		end

		talentFrame:Show();

		-- arrows for rows with 2 talents of tiered trees
		if talentTreeType == Enum.GarrTalentTreeType.Tiers and currentTierTalentIndex == 2 then
			local choiceBackground = self.choiceTexturePool:Acquire();
			if (currentTierResearchableTalentCount == 2) then
				choiceBackground:SetAtlas("orderhalltalents-choice-background-on", true);
				choiceBackground:SetDesaturated(false);
				local pulsingArrows = self.arrowTexturePool:Acquire();
				pulsingArrows:SetPoint("CENTER", choiceBackground);
				pulsingArrows.Pulse:Play();
				pulsingArrows:Show();
			elseif (currentTierResearchableTalentCount == 1) then
				choiceBackground:SetAtlas("orderhalltalents-choice-background", true);
				choiceBackground:SetDesaturated(false);
			else
				choiceBackground:SetAtlas("orderhalltalents-choice-background", true);
				choiceBackground:SetDesaturated(true);
			end
			choiceBackground:SetPoint("TOP", 0, - contentOffsetY + CHOICE_BACKGROUND_OFFSET_Y);
			choiceBackground:Show();
		end

        if (talent.id == completeTalent) then
            if (talent.selected and not talent.hasInstantResearch) then
				PlaySound(SOUNDKIT.UI_ORDERHALL_TALENT_READY_CHECK);
				talentFrame.TalentDoneAnim:Play();
			end
            C_Garrison.ClearCompleteTalent(self.garrisonType);
        end
	end

	-- size window
	local frameWidth = math.max(layoutOptions.minimumWidth, maxContentWidth + layoutOptions.spacingHorizontal);
	local frameHeight = contentOffsetY + currentTierHeight + layoutOptions.spacingBottom;	-- add currentTierHeight to account for the last tier
	self:SetSize(frameWidth, frameHeight- 20);

	self.refreshing = false;
end

function TTG_OrderHallTalentFrameMixin:FindTalentButton(talentID)
	for talentFrame in self.buttonPool:EnumerateActive() do
		if talentFrame.talent.id == talentID then
			return talentFrame;
		end
	end
	return nil;
end

function TTG_OrderHallTalentFrameMixin:AddPrerequisiteArrow(talentButton, prerequisiteTalentButton)
	local arrowFrame = self.prerequisiteArrowPool:Acquire();
	if talentButton.talent.uiOrder > prerequisiteTalentButton.talent.uiOrder then
		arrowFrame:SetPoint("LEFT", prerequisiteTalentButton, "RIGHT", 1, 0);
		arrowFrame.Arrow:SetTexCoord(1, 0, 0, 1);
	else
		arrowFrame:SetPoint("RIGHT", prerequisiteTalentButton, "LEFT", -1, 0);
		arrowFrame.Arrow:SetTexCoord(0, 1, 0, 1);
	end
	if talentButton.talent.talentAvailability == Enum.GarrisonTalentAvailability.Available or talentButton.talent.talentAvailability == Enum.GarrisonTalentAvailability.UnavailableAlreadyHave then
		arrowFrame.Arrow:SetDesaturated(false);
		arrowFrame.Arrow:SetVertexColor(1, 1, 1);
	else
		arrowFrame.Arrow:SetDesaturated(true);
		arrowFrame.Arrow:SetVertexColor(0.6, 0.6, 0.6);
	end
	arrowFrame:Show();
	talentButton:SetFrameLevel(2);
	arrowFrame:SetFrameLevel(3);
	prerequisiteTalentButton:SetFrameLevel(4);
end

function TTG_OrderHallTalentFrameMixin:SetResearchingTalentID(talentID)
end

function TTG_OrderHallTalentFrameMixin:ClearResearchingTalentID()
	self.researchingTalentID = 0;
end

function TTG_OrderHallTalentFrameMixin:GetResearchingTalentID()
	return self.researchingTalentID;
end

TTG_GarrisonTalentButtonMixin = { }

function TTG_GarrisonTalentButtonMixin:SetTalent(talent, talentSelectedEffect, customUnavailableTalentErrorCallback)
	self.talent = talent;
	self.talentSelectedEffect = talentSelectedEffect;
	self.customUnavailableTalentErrorCallback = customUnavailableTalentErrorCallback;

	self:ReacquireAnimationFrame();
end

function TTG_GarrisonTalentButtonMixin:SetBorder(borderAtlas)
	if borderAtlas then
		if self.talent.type == Enum.GarrTalentType.Major then
			borderAtlas = borderAtlas.."-large";
		end
		local useAtlasSize = true;
		self.Border:SetAtlas(borderAtlas, useAtlasSize);
		self.Border:Show();
	else
		self.Border:Hide();
	end
end

function TTG_GarrisonTalentButtonMixin:OnEnter()
	local researchingTalentID = self:GetParent():GetResearchingTalentID();

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");

	local talent			= self.talent;
	local garrTalentTreeID	= TORGHAST_TALENT_TREE_ID-- C_Garrison.GetCurrentGarrTalentTreeID();
	local talentTreeType	= C_Garrison.GetGarrisonTalentTreeType(garrTalentTreeID);

	-- Multi-Rank Talents
	if talent.talentMaxRank > 1 then
		local talentRank = math.max(0, talent.talentRank);

		GameTooltip:AddLine(talent.name, 1, 1, 1);
		GameTooltip_AddColoredLine(GameTooltip, TOOLTIP_TALENT_RANK:format(talentRank, talent.talentMaxRank), HIGHLIGHT_FONT_COLOR);
		GameTooltip:AddLine(talent.description, nil, nil, nil, true);

		-- Next Rank (show research description)
		if talent.talentRank > 0 and talent.talentRank < talent.talentMaxRank then
			GameTooltip:AddLine(" ");
			GameTooltip_AddColoredLine(GameTooltip, TOOLTIP_TALENT_NEXT_RANK, HIGHLIGHT_FONT_COLOR);
			GameTooltip:AddLine(talent.researchDescription, nil, nil, nil, true);
		end
	else 
		GameTooltip:AddLine(talent.name, 1, 1, 1);
		GameTooltip:AddLine(talent.description, nil, nil, nil, true);
	end

	if talent.isBeingResearched and not talent.hasInstantResearch then
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine(NORMAL_FONT_COLOR_CODE..TIME_REMAINING..FONT_COLOR_CODE_CLOSE.." "..SecondsToTime(talent.timeRemaining), 1, 1, 1);
	elseif (talentTreeType == Enum.GarrTalentTreeType.Tiers and not talent.selected) or (talentTreeType == Enum.GarrTalentTreeType.Classic and not talent.researched) then
		GameTooltip:AddLine(" ");

		if (talent.researchDuration and talent.researchDuration > 0) then
			GameTooltip:AddLine(RESEARCH_TIME_LABEL.." "..HIGHLIGHT_FONT_COLOR_CODE..SecondsToTime(talent.researchDuration)..FONT_COLOR_CODE_CLOSE);
		end

		local costString = GetGarrisonTalentCostString(talent);
		if costString then
			GameTooltip:AddLine(costString, 1, 1, 1);
		end

		if talent.talentAvailability == Enum.GarrisonTalentAvailability.Available or ((researchingTalentID and researchingTalentID ~= 0) and talent.talentAvailability == Enum.GarrisonTalentAvailability.UnavailableAnotherIsResearching) then
			GameTooltip:AddLine(ORDER_HALL_TALENT_RESEARCH, 0, 1, 0);
			self.Highlight:Show();
		else
			if (talent.talentAvailability == Enum.GarrisonTalentAvailability.UnavailablePlayerCondition and talent.playerConditionReason) then
				GameTooltip:AddLine(talent.playerConditionReason, 1, 0, 0);
			elseif (talent.talentAvailability == Enum.GarrisonTalentAvailability.UnavailableRequiresPrerequisiteTalent) then
				local prereqTalentButton = self:GetParent():FindTalentButton(talent.prerequisiteTalentID);
				local preReqTalent = prereqTalentButton and prereqTalentButton.talent;
				if (preReqTalent) then
					GameTooltip:AddLine(TOOLTIP_TALENT_PREREQ:format(preReqTalent.talentMaxRank, preReqTalent.name), 1, 0, 0);
				else
					GameTooltip:AddLine(TalentUnavailableReasons[Enum.GarrisonTalentAvailability.UnavailableRequiresPrerequisiteTalent], 1, 0, 0);
				end
			elseif (TalentUnavailableReasons[talent.talentAvailability]) then
				GameTooltip:AddLine(TalentUnavailableReasons[talent.talentAvailability], 1, 0, 0);
			end
			self.Highlight:Hide();
		end
	end
	self.tooltip = GameTooltip;
	GameTooltip:Show();
	EventRegistry:TriggerEvent("TTG_GarrisonTalentButtonMixin.TalentTooltipShown", GameTooltip, talent, garrTalentTreeID);
end

function TTG_GarrisonTalentButtonMixin:OnLeave()
	GameTooltip_Hide();
	self.Highlight:Hide();
	self.tooltip = nil;
end

function TTG_GarrisonTalentButtonMixin:OnClick()
end

function TTG_GarrisonTalentButtonMixin:HasResearchTime()
	return self.talent.researchDuration and self.talent.researchDuration > 0;
end

function TTG_GarrisonTalentButtonMixin:ActivateTalent()
end

function TTG_GarrisonTalentButtonMixin:OnFramePoolReset()
	self.Cooldown:SetCooldownDuration(0);
	self.Cooldown:Hide();
	self.Border:Show();
	self.AlphaIconOverlay:Hide();
	self.CooldownTimerBackground:Hide();
	self.Icon:SetDesaturated(false);
	self.talent = nil;
	self.tooltip = nil;
	if (self.timer) then
		self.timer:Cancel();
		self.timer = nil;
	end
	self.TalentDoneAnim:Stop();
	self:ReleaseAnimationFrame();
end

function TTG_GarrisonTalentButtonMixin:Refresh()
	if (self.talent and self.talent.id) then
	    self.talent = C_Garrison.GetTalentInfo(self.talent.id);
	    if (self.tooltip) then
		    self:OnEnter();
	    end
	end
end

function TTG_GarrisonTalentButtonMixin:AcquireAnimationFrame()
	-- Animation frames are separate from talent buttons so that the animation state is preserved
	-- even if the talent button gets released back to the pool and reacquired (i.e. during a refresh).

	local talentFrame = self:GetTalentFrame();
	local animationFrame = talentFrame:AcquireAnimationFrame(self.talent.id);
	animationFrame:Attach(self);
	self.animationFrame = animationFrame;
end

function TTG_GarrisonTalentButtonMixin:ReleaseAnimationFrame()
	if self.animationFrame ~= nil then
		self.animationFrame:Detach();
		self.animationFrame = nil;
	end
end

function TTG_GarrisonTalentButtonMixin:ReacquireAnimationFrame()
	if self.animationFrame ~= nil then
		return;
	end

	local animationFrame = self:GetTalentFrame():GetActiveAnimationFrame(self.talent.id);
	if animationFrame ~= nil then
		animationFrame:Attach(self);
		self.animationFrame = animationFrame;
	end
end

function TTG_GarrisonTalentButtonMixin:StartSelectedAnimation()
	self:AcquireAnimationFrame();

	if not self.animationFrame:IsPlayingSelectedAnimation() then
		self.animationFrame:PlaySelectedAnimation(self.talentSelectedEffect);
	end
end

function TTG_GarrisonTalentButtonMixin:GetTalentFrame()
	return self:GetParent();
end

TTG_GarrisonTalentButtonAnimationMixin = {};

function TTG_GarrisonTalentButtonAnimationMixin:Attach(talentButton)
	self:SetPoint("CENTER", talentButton, "CENTER");
	self:Show();
end

function TTG_GarrisonTalentButtonAnimationMixin:Detach()
	self:ClearAllPoints();
	self:Hide();
end

function TTG_GarrisonTalentButtonAnimationMixin:PlaySelectedAnimation(scriptedAnimationEffectID)
	self:CancelEffects();

	self.SwirlContainer:Show();
	self.SwirlContainer.SelectedAnim:Play();

	self.selectedEffectController = GlobalFXDialogModelScene:AddEffect(scriptedAnimationEffectID, self);
end

function TTG_GarrisonTalentButtonAnimationMixin:IsPlayingSelectedAnimation()
	return self.SwirlContainer.SelectedAnim:IsPlaying() or ((self.selectedEffectController ~= nil) and self.selectedEffectController:IsActive());
end

function TTG_GarrisonTalentButtonAnimationMixin:CancelEffects()
	if self.selectedEffectController then
		self.selectedEffectController:CancelEffect();
		self.selectedEffectController = nil;
	end
end

function TTG_GarrisonTalentButtonAnimationMixin:SetTalentID(talentID)
	self.talentID = talentID;
end

function TTG_GarrisonTalentButtonAnimationMixin:GetTalentID()
	return self.talentID;
end

function TTG_GarrisonTalentButtonAnimationMixin:OnFramePoolReset()
	self.talentID = nil;
	self:CancelEffects();
end