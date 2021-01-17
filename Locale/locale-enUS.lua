local addonName, addon = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName,"enUS",true)




L["Anima Cell"] = true
L["Dropped Anima Cell"] = true
L["Ravenous Anima Cell"] = true
L["%s Count"] = true
L["%s - \n%s:\n%s"] = true
L["%s - %s%s"] = true
L["Torghast Upgrades"] = true
L["Tips & Tricks"] = true
L["Toggle Guide"] = true
L["WoWHead Links"] = true


--Options
L["General Options"] = true
L["Tooltip Options"] = true
L["Show Rare Ability Drop Tooltips"] = true
L["Show Ravenous Anima Cell Tooltips"] = true
L["Settings"]=true
L["Options"]=true
L["Always"] = true



L["BOSSLINK"] = "Boss Link: https://www.wowhead.com/npc=%s"
L["GUIDELINK"] = "Guide Link: https://www.wowhead.com/guides/torghast-floor-boss-strategies-abilities-tips-tricks"

_G["BINDING_NAME_TOGGLE_TORGHASTTOURGUIDE"] = "Toggle Guide"
_G["BINDING_HEADER_TORGHASTTOURGUIDE"] = addonName

--Bosses
L["156239"] = "Dark Ascended Corrus"
L["170418"] = "Goxul the Devourer"
L["153165"] = "Custodian Thonar"
L["156015"] = "Writhing Soulmass"
L["153382"] = "Maw of the Maw"
L["159755"] = "The Grand Malleare"
L["151331"] = "Cellblock Sentinel"
L["153011"] = "Binder Baritas"
L["159190"] = "Synod"
L["153174"] = "Watchers of Death"
L["155250"] = "Decayspeaker"
L["171422"] = "Arch-Suppressor Laguas"
L["169859"] = "Observer Zelgar"
L["151329"] = "Warden Skoldus"
L["153451"] = "Kosarus the Fallen"
L["155945"] = "Gherus the Chained"
L["152995"] = "Warden of Souls"
L["157122"] = "Patrician Cromwell"
L["155251"] = "Elder Longbranch"
--https://www.wowhead.com/guides/torghast-floor-boss-strategies-abilities-tips-tricks

L["Split_Desc"] = "Writhing Soulmass splits into smaller units."

L["Corrus_Tip1"] = "Blinding Smoke Capsules can be used to completely avoid Shadow Rip, if you have them available from any vendors. If not, you can interrupt Shadow Swipe if you're having issues with it, but it should not be your first priority. The DOT from Shadow Rip is very weak."
L["Corrus_Tip2"] = "Stygian Shield is interruptible and the 30% damage reduction is significant, so make sure to interrupt Stygian Shield whenever possible. If you have an offensive dispel, dispel Stygian Shield once its applied and save the interrupts for Shadow Rip."	

L["Goxul_Tip1"] = "The biggest priority for Goxul the Devourer is to interrupt Mass Devour with any CCs you have. Speccing into extra CCs or lowering the cooldown of any CCs you might have with talent changes on the boss floor is not a bad idea."
L["Goxul_Tip2"] = "Shatter Essence's orbs have very low health and can be easily cleaved down."

L["Thonar_Tip1"] = "Blinding Smoke Capsules are incredibly strong against Custodian Thonar, as his melee damage is very high. If you see these sold by any vendors, purchase them!"
L["Thonar_Tip2"] = "Make sure to keep Custodian Thonar at the corners of the room you're fighting him in, to reduce the spread of Noxious Cloud."
L["Thonar_Tip3"] = "Meat Hook is interruptible - Make sure to interrupt the cast whenever you have an interrupt up. If you don't have an interrupt available, use a CC ability to stop the cast or position yourself so you don't end up within a Noxious Cloud."
L["Thonar_Tip4"] = "Thorned Shell is a Thorns effect - Do not attack Custodian Thonar while it is up (which is not worth doing anyway as he takes 75% damage reduction while under its effects). Use this time to disengage from Thonar to heal, as he also moves slower while under the effects of Thorned Shell."

L["Soulmass_Tip1"] = "Put a marker on the Writhing Soulmass before starting the fight - Only damage done towards the main boss will count. Smaller masses will explode on death and not detract from the boss's actual health."
L["Soulmass_Tip2"] = "You can use slows and CCs to stop the smaller adds from exploding on you. Blinding Smoke Capsuless also work well to avoid massive explosion damage."

L["Maw_Tip1"] = "Each time Maw of the Maw uses Devour Obleron Armaments, he will gain 10% increased damage while devouring one of your Obleron Anima Powers. Easiest way to stop this from happening is simply getting as few Obleron Powers as possible through Torghast. If you could not avoid getting many Obleron Powers, make sure to stun or CC Maw of the Maw as much as you can to avoid Devour from reaching high stacks."
L["Maw_Tip2"] = "Gunk is interruptible and has an annoying slow attached to it, so it should be interrupted at all times if possible. Make sure to save hard CCs for Devour Obleron Armaments."

L["Malleare_Tip1"] = "Withering Roar is the main cast to interrupt here, as each stack of Withering Roar will reduce your health by 10%. Interrupt Withering Roar at all costs."
L["Malleare_Tip2"] = "Both Ground Crush and Inferno! can be interrupted with stuns, and you can choose which one should be interrupted, although both abilities are easy to dodge - Ground Crush stuns and damages all targets 15 yards again from Malleare (so just run away), while Inferno! is even easier, simply dodge the swirlies on the ground."

L["Sentinel_Tip1"] = "This fight is all about having a little bit of patience - Stop attacking and kite Cellblock Sentinel around during Crumbling Walls (to avoid add spawns) and Lumbering Might (you can keep attacking if you have ranged abilities, but his melee attacks will hurt a lot)."
L["Sentinel_Tip2"] = "Cellblock Sentinel's 2 stun abilities are easily avoidable - Run away from Ground Crush (its a short 15-yard range so not too bad) and run behind the boss for Shockwave (as it stuns in a cone in front of the boss). Shockwave in special is a long cast and easily avoidable, so use this time to freely deal damage."

L["Baritas_Tip1"] = "The adds spawned by Bind Souls have a lot of health, but you can easily get rid of them - Any sort of CC that works on Undead mobs will instantly despawn the add, so CC them as soon as you can!"
L["Baritas_Tip2"] = "Soul Echo is easy enough to dodge, so sidestep out of the missiles and save your interrupts for Shadow Bolt, which will hurt more as the fight progresses."

L["Synod_Tip1"] = "Synod is considered one of the hardest fights in Torghast as you need to beat him fast enough to avoid being overpowered by Intimidating Presence and Solidify, so use any outside help you can like Drums here."
L["Synod_Tip2"] = "Intimidating Presence is by far his most dangerous cast, as it reduces your Haste and healing taken. Interrupt this at all costs, as the effects of Intimidating Presence stack if left unchecked. Bring all CC abilities you have at your disposal for this boss."
L["Synod_Tip3"] = "Interrupting Slam is more dangerous for casters players, but it still deals Shadow damage, so if you can interrupt it, you should."
L["Synod_Tip4"] = "Solidify is another nasty stack effect that increases Shadow damage taken, and can be dangerous if you let Synod cast many Interrupting Slams. However, Solidify is a Magic effect, so if you have any means of dispelling yourself, take them for this fight."

L["Watchers_Tip1"] = "Although Steal Vitality is very strong, you must save at least one interrupt for every Fearsome Howl, as being feared will leave you vulnerable to both Steal Vitality and Prophecy of Death hits. You can interrupt as many Steal Vitalities as you can, but be aware to have an interrupt up for every Fearsome Howl."
L["Watchers_Tip2"] = "Prophecy of Death spawns swirlies on the floor that are easily avoidable, so you can let this cast pass - Just be mindful that Watchers of Death does not channel Prophecies of Death, instantly going back to its other two casts once Prophecies of Death starts."

L["Decayspeaker_Tip1"] = "Hardened Shell is Decayspeaker's main mechanic. As Decayspeaker starts the fight with 9 stacks of Hardened Power (which means 90% reduced damage taken), you do not want to pop all your cooldowns at the start of the fight. Use fast casts and instant abilities to reduce or outright remove all stacks of Hardened Shell, then go wild with your cooldowns!"
L["Decayspeaker_Tip2"] = "Acid Bomb shoots poison bombs around Decayspeaker's targets and are easily avoidable, so make sure to not get hit by them. If you get hit by Acid Bomb, you can mitigate part of the damage done if you have any abilities that remove Poison."

L["Laguas_Tip1"] = "Arch-Suppressor Laguas is a caster boss with many interruptible casts. The main cast that should be interrupted is Curse of Frailty, as it will increase the damage taken from all his other abilities. If you have any means of removing Curses from you, you can let this cast go through, but make sure to immediately remove the Curse." 
L["Laguas_Tip2"] = "Deaden Magic is also interruptible and gives Laguas a big magic shield. If you're a melee class you might be able to just let this pass, but as a caster you might want to get this interrupt. Otherwise, this is dispellable, so if you have any offensive dispels you can simply let the boss cast Deaden Magic and remove it off him."
L["Laguas_Tip3"] = "Soul Bolt is Laguas' filler ability. Interrupt these as much as you can, but make sure to have interrupts available for Curse of Frailty and/or Deaden Magic, depending on what tools your class has. You will likely not be able to interrupt all Soul Bolts."
L["Laguas_Tip4"] = "Suppress cannot be interrupted, but it is easy enough to dodge where it should not be a concern. Be mindful, as Suppress leaves AOE patches on the floor that will silence and pacify you if you step on them."

L["Zelgar_Tip1"] = "Aerial Strikes is a very dangerous ability that needs to be dodged at all costs - Getting hit by even 1 of them will put a massive dent on your health. Stop everything you're doing to ensure you don't get hit by Aerial Strikes."
L["Zelgar_Tip2"] = "Focused Blast is interruptible and you should try to interrupt as many of these as you can. However, as this is Zelgar's filler cast, you will likely not get all of them."
L["Zelgar_Tip3"] = "Ocular Beam deals moderate damage and knocks you back for a few seconds. You can stop this cast by stunning or CCing Zelgar, just be careful to not let him throw off the platform if you're in a wing with a circular arena like The Soulforges."

L["Skoldus_Tip1"] = "Warden Skoldus is considered one of the easiest bosses in Torghast, but his abilities can still put a dent on you if not dealt with. The main ability to watch out for is Rats!, as this will slow you and leave you vulnerable to his other two abilities. Rats! is interruptible, so CC or interrupt Warden Skoldus whenever he casts it."
L["Skoldus_Tip2"] = "Hulking Charge and Rat Traps are both very easy to dodge, so make sure you do not get hit by either. Simply move out of the way for Hulking Charge and run away from the trap spawned by Rat Trap."

L["Kosarus_Tip1"] = "For Kosarus the Fallen, the name of the game is DO NOT MOVE, as Predator's Gaze will enrage him every time you move, stacking and persisting for the entire fight. You should only move to dodge Collapse casts, so make sure you plan your movement according to move as little as possible."
L["Kosarus_Tip2"] = "Abilities that allow you to displace yourself by teleporting from one point to another such as a Mage's Blink, a Night Fae's Soulshape or a Venthyr's Door of Shadows can be used to move around without triggering the enrage effect from Predator's Gaze."

L["Gherus_Tip1"] = "Deafening Howl is Gherus's most dangerous cast and must be interrupted at all costs, as getting feared through the fight will leave you vulnerable to his other spells."
L["Gherus_Tip2"] = "Devour Soul can be CC'd out, but Gherus usually doesn't cast this often enough to be worth worrying about. Make sure to have a stun ready, just in case."
L["Gherus_Tip3"] = "Incorporeal can be interrupted if you have interrupts to spare - Otherwise, use this time to renew abilities or heal yourself up, as Gherus has to channel Incorporeal."

L["Warden_Tip1"] = "Well of Souls creates a void zone under the boss that increases his damage done. You need to keep Warden of Souls out of this AOE at all times."
L["Warden_Tip2"] = "Soul Fragment spawns 3 adds every time, and these adds deal light damage. However, if you do not kill them, Warden of Souls will eventually overpower you with them. Thankfully, the adds spawned by Soul Fragment have low health and can easily be cleaved off."
L["Warden_Tip3"] = "Fearsome Howl is Warden of Souls' only interruptible cast, and as such, interrupting this AOE fear is a no-brainer."

L["Cromwell_Tip1"] = "Patrician Cromwell has a lot of interruptible casts. The cast that should be interrupted at all times is Crippling Burst, as it massively reduces attack speed and primary stats for the duration."
L["Cromwell_Tip2"] = "Dread Plague is cast on Cromwell himself, so you can simply run away from his melee range to not take damage from this if you are lacking interrupts, or if you want to interrupt Dark Bolt Volley instead."
L["Cromwell_Tip3"] = "Creeping Sins drops void zones around Cromwell, just avoid them and they won't be of any issue."

L["Longbranch_Tip1"] = "Hardened Shell is Elder Longbranch's main mechanic. As Elder Longbranch starts the fight with 9 stacks of Hardened Power (which means 90% reduced damage taken), you do not want to pop all your cooldowns at the start of the fight. Use fast casts and instant abilities to reduce or outright remove all stacks of Hardened Shell, then go wild with your cooldowns!"
L["Longbranch_Tip2"] = "Bounty of the Forest is a massive heal and Longbranch's only noteworthy ability with a cast time, so interrupt this at all costs. This can also be dispelled if the cast goes off, just make sure Longbranch doesn't get a good heal out of it."
L["Longbranch_Tip3"] = "Crush can be interrupted as well, but as Crush stuns in a cone in front of Longbranch, you can simply sidestep it and save interrupts for Bounty of the Forest."