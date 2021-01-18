local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--PlayerChoiceFrame.Option1

local LISTWINDOW

local function GetSpec()

	local currentSpec = GetSpecialization()
	local currentSpecID = currentSpec and select(1, GetSpecializationInfo(currentSpec))
	return currentSpecID

end
function EditWeight(self, frame)
	if LISTWINDOW then LISTWINDOW:Hide() end

	local f = AceGUI:Create("Window")
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	f:SetTitle(L["Set Power Weight & Note"])
	f:SetLayout("Flow")
	f:EnableResize(false)
	f:SetHeight(210)
	f:SetWidth(350)
	LISTWINDOW = f

	local spec = GetSpec()
	addon.Notesdb.profile[spec] = addon.Notesdb.profile[spec] or {}
	addon.Weightsdb.profile[spec] = addon.Notesdb.profile[spec] or {}
	local spellID = frame.spellID

	local note = addon.Notesdb.profile[spec]
	local weight = addon.Weightsdb.profile[spec]

	_G["TTG_NoteWindow"] = f.frame
	tinsert(UISpecialFrames, "TTG_NoteWindow")
	local EditBox = AceGUI:Create("EditBox")
	--EditBox:SetFullHeight(true)
	EditBox:SetWidth(100)
	EditBox:SetLabel(L["Power Weight"])
	EditBox:SetText(weight[spellID] or "")

	EditBox:SetCallback("OnEnterPressed" , function() weight[spellID] = EditBox:GetText(); frame.weight.Text:SetText(weight[spellID]) end)

	--MultiLineEditBox:SetText((L["BOSSLINK"]):format(creatureDisplayID.encounterID).."\n"..L["GUIDELINK"])
	f:AddChild(EditBox)
	local MultiLineEditBox = AceGUI:Create("MultiLineEditBox")
	--MultiLineEditBox:SetFullHeight(true)
	MultiLineEditBox:SetFullWidth(true)
	MultiLineEditBox:SetLabel(L["Power Notes"])
	MultiLineEditBox:SetCallback("OnEnterPressed" , function() note[spellID] = MultiLineEditBox:GetText(); frame.notes.Text:SetText(note[spellID])  end)
	MultiLineEditBox:SetText(note[spellID] or "")
	--MultiLineEditBox:SetText((L["BOSSLINK"]):format(creatureDisplayID.encounterID).."\n"..L["GUIDELINK"])
	f:AddChild(MultiLineEditBox)
end



function addon.PowerShow()
	for i, frame in ipairs(PlayerChoiceFrame.Options) do
		local weight, notes
		if not frame.weight then 
			local notes = CreateFrame("Frame", nil, frame, "TorghastTourGuideNoteTemplate")
			local weight = CreateFrame("Frame", nil, frame, "TorghastTourGuidePowerTemplate")
			--b:SetScript("OnEnter", function(self)  addon.ShowTooltip(self, "This Is a Note")  end)
			--b:SetScript("OnLeave", function(self) MyScanningTooltip:Hide() end)
			weight:SetScript("OnMouseDown", function(self) EditWeight(self, frame) end)
			weight:SetFrameLevel(15)
			frame.weight = weight
			frame.notes = notes
			--addon:Hook(frame, "UpdateMouseOverStateOnOption", function(self) C_Timer.After(0.2, mouseover(self)) end, true)
		end

		local spec = GetSpec()
		addon.Notesdb.profile[spec] = addon.Notesdb.profile[spec] or {}
		addon.Weightsdb.profile[spec] = addon.Notesdb.profile[spec] or {}
		local spellID = frame.spellID
		local noteDB = addon.Notesdb.profile[spec]
		local weightDB = addon.Weightsdb.profile[spec]

		if spellID then 
		frame.weight.Text:SetText(weightDB[spellID] or "")
		frame.notes.Text:SetText(noteDB[spellID] or "")
			--print(spellID)
		end
	end
end