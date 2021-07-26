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

function addon.CheckAnimaPowers(spellID)


return true


end


function addon.CheckAnimaRarity(spellRarity)
	return spellRarity >= Enum.PlayerChoiceRarity.Epic
end