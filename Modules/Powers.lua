local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local NotesDB
local WeightsDB

local function GetSpec()
	local currentSpec = GetSpecialization()
	local currentSpecID = currentSpec and select(1, GetSpecializationInfo(currentSpec))
	return currentSpecID
end


function addon.InitPowers()
	local spec = GetSpec()
	addon.Notesdb.profile[spec] = addon.Notesdb.profile[spec] or {}
	NotesDB = addon.Notesdb.profile[spec]
	addon.Weightsdb.profile[spec] = addon.Weightsdb.profile[spec] or {}
	WeightsDB = addon.Weightsdb.profile[spec]
end


local LISTWINDOW
function EditWeight(self, frame)
	if LISTWINDOW then LISTWINDOW:Hide() end

	local f = AceGUI:Create("Window")
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	f:SetTitle(L["Set Power Weight & Note"])
	f:SetLayout("Flow")
	f:EnableResize(false)
	f:SetHeight(235)
	f:SetWidth(350)
	LISTWINDOW = f

	local spellID = frame.spellID
	_G["TTG_NoteWindow"] = f.frame
	tinsert(UISpecialFrames, "TTG_NoteWindow")
	local EditBox = AceGUI:Create("EditBox")
	EditBox.frame:SetWidth(200)
	EditBox.editbox:ClearAllPoints()
	EditBox.editbox:SetPoint("BOTTOMLEFT", 6, 0)
	EditBox.editbox:SetWidth(80)
	EditBox.button:ClearAllPoints()
	EditBox.button:SetPoint("LEFT",EditBox.editbox, "RIGHT")
	EditBox:SetLabel(L["Power Weight"])
	EditBox:SetText(WeightsDB[spellID] or "")
	EditBox:SetCallback("OnEnterPressed" , function() WeightsDB[spellID] = EditBox:GetText(); frame.weight.Text:SetText(WeightsDB[spellID]) end)
	f:AddChild(EditBox)

	local MultiLineEditBox = AceGUI:Create("MultiLineEditBox")
	MultiLineEditBox:SetFullWidth(true)
	MultiLineEditBox:SetLabel(L["Power Notes"])
	MultiLineEditBox:SetCallback("OnEnterPressed" , function() NotesDB[spellID] = MultiLineEditBox:GetText(); frame.notes.Text:SetText(NotesDB[spellID])  end)
	MultiLineEditBox:SetText(NotesDB[spellID] or "")
	f:AddChild(MultiLineEditBox)
	
	local Button = AceGUI:Create("Button")
	Button:SetText(CLOSE)
	Button:SetCallback("OnClick", function() f:Hide() end)
	f:AddChild(Button)
end



function addon.PowerShow()
	for i, frame in ipairs(PlayerChoiceFrame.Options) do
		local weight, notes
		if not frame.weight then 
			local notes = CreateFrame("Frame", nil, frame, "TorghastTourGuideNoteTemplate")
			notes:SetScript("OnMouseDown", function(self) EditWeight(self, frame) end)

			local weight = CreateFrame("Frame", nil, frame, "TorghastTourGuidePowerTemplate")
			--	weight:SetScript("OnEnter", function(self) self:GetParent().MouseOverOverride:EnableMouse(false);  addon.ShowTooltip(self, "This Is a Note")  end)
			--	weight:SetScript("OnLeave", function(self) GameTooltip:Hide(); self:GetParent().MouseOverOverride:EnableMouse(true); end)
			weight:SetScript("OnMouseDown", function(self) EditWeight(self, frame) end)
			weight:SetFrameLevel(15)
			frame.weight = weight
			frame.notes = notes
			--addon:Hook(frame, "UpdateMouseOverStateOnOption", function(self) C_Timer.After(0.2, mouseover(self)) end, true)
		end

		local spellID = frame.spellID
		if spellID then 
			frame.weight.Text:SetText(WeightsDB[spellID] or "")
			frame.notes.Text:SetText(NotesDB[spellID] or "")
		end
	end
end