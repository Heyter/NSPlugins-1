PLUGIN.name = "Roll Gain"
PLUGIN.author = "Qemist"
PLUGIN.desc = "Boosts your rolls depending on your faction, class and equiped weapon."

nut.util.Include("sh_config.lua")

nut.command.Register({
	onRun = function(client, arguments)
		local weapon = client:GetActiveWeapon():GetClass()
		local faction = client:Team()
		local roll_max = 100
		local gain = 0

		-- Checks to see if the client faction is MPF, if it is then move onto the next line.
		if (faction == FACTION_CP) then
			for k,v in pairs(nut.config.CPGains ) do
				if (client:IsCombineRank(v[1])) then
					roll_max = roll_max + v[2]
					break
		  		end	
			end
		end

		-- If clients faction is OTA then give him one of these gains.
		if (faction == FACTION_OW) then
			for k,v in pairs(nut.config.OWGains) do
				if (client:IsCombineRank(v[1])) then
					roll_max = roll_max + v[2]
					break
		  		end	
			end
		end

		-- If clients faction is CWU then give him gain of 5.
		if (faction == FACTION_UNCE) then
			roll_max = roll_max + 5	
		end

		-- This should be pretty self explanatory if you followed the rest. This adds a gain based on the weapon EQUIPPED.
		for k,v in pairs(nut.config.weaponGains) do
			if (weapon == v[1]) then
				gain = gain + v[2]
				break
	  		end	
		end

		-- Again hopefully pretty self explanatory. Based on your attributes what gain you would get.
		if client:GetAttrib(ATTRIB_STR, 0) >= 20 then
			gain = gain + 10
		end
		
		if client:GetAttrib(ATTRIB_ACR, 0) >= 20 then
			gain = gain + 5
		end

		if client:GetAttrib(ATTRIB_SPD, 0) >= 20 then
			gain = gain + 5
		end

		if client:GetAttrib(ATTRIB_END, 0) >= 20 then
			gain = gain + 5
		end

		math.randomseed(CurTime())

		local base = math.random(0, roll_max)
		local roll = base + gain

		-- Makes sure the roll doesn't go over 100
		if roll > roll_max then
			roll = roll_max
		end

		-- Notifys the client of the roll and their gain.
		nut.chat.Send(client, "roll", client:Name().." has rolled "..roll.." out of "..roll_max.." with a gain of "..gain.." for a total of "..(roll + gain <= roll_max and roll + gain or roll_max)..".")
	end
}, "roll")


