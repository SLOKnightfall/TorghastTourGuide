--  ///////////////////////////////////////////////////////////////////////////////////////////
--
--   
--  Author: SLOKnightfall

--  

--

--  ///////////////////////////////////////////////////////////////////////////////////////////

if not IsAddOnLoaded("!KalielsTracker") then return end

local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local KT = LibStub("AceAddon-3.0"):GetAddon("!KalielsTracker")
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local InCombat = false

local retry = false


--addon:Hook(KT, "MoveTracker", function() addon.PositionFrame() end)

local f = CreateFrame("Frame", nil, UIParent)
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_LOGIN")



--addon:Hook(KT, "MoveTracker",  function()  C_Timer.After(0.005, function() addon.PositionFrame() end) end)
--addon:Hook(KT, "OnEnable",  function()  C_Timer.After(1, function() addon:HookScript(KT.frame.Scroll, "OnMouseWheel",  function()  C_Timer.After(0.005, function() addon.PositionFrame() end) end) end) end)



addon:HookScript(ScenarioStageBlock, "OnShow", function()
if not addon.frames.f then return end 
addon.frames.f:SetAlpha(1) 
	if InCombatLockdown() then
	else
		addon.frames.f:Show()
		--C_Timer.After(01, function() addon.PositionFrame() 
		--end) 
	end
end)

addon:HookScript(ScenarioStageBlock, "OnHide", function() 
	if not addon.frames.f then return end  
	if InCombatLockdown() then
		addon.frames.f:SetAlpha(0)
	else
 		addon.frames.f:Hide()
		end
end)



f:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_REGEN_DISABLED" then 
		InCombat = true;
		addon.PositionFrame()
	elseif event == "PLAYER_REGEN_ENABLED" then
		if retry then 
			retry = false
			InCombat = false

		end
		local f = addon.frames.f
		if not f then return end
		f:SetParent(ScenarioStageBlock)
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", ScenarioStageBlock, "TOPLEFT" )
	elseif event == "PLAYER_LOGIN" then 
	--	ScenarioStageBlock:
	--	addon.PositionFrame()
			--f--:SetParent(KT.frame.Scroll.child)
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", ScenarioStageBlock, "TOPLEFT" )
	end
end)


