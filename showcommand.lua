PLUGIN.name = "Show Commands"
PLUGIN.author = "Blank"
PLUGIN.desc = "Shows commands when typing them in the chat."

if (CLIENT) then
	function PLUGIN:ChatTextChanged(text)
		if (!string.sub(text, 1, 1) == "/") then return end

		Options = {}

		local Explode = string.Explode(" ", string.sub(text, 2))

		if (!Explode[1]) then return end

		local Command = string.lower(Explode[1])

		for k, v in pairs(nut.command.buffer) do
			if (string.sub(text, 1, 1) == "/") then 
				if (string.sub(string.lower(k), 1, string.len(Command)) == Command) then
			 		if (string.len(Command) > 0) then
			 			local commandTable = nut.command.buffer[k]

			 			if (commandTable) then
							if (commandTable.onRun) then
								if (commandTable.hasPermission) then
									if (commandTable.hasPermission(LocalPlayer()) == false) then
										return
									end
								elseif (commandTable.superAdminOnly) then
									if (!LocalPlayer():IsSuperAdmin()) then
										return
									end
								elseif (commandTable.adminOnly) then
									if (!LocalPlayer():IsAdmin()) then
										return
									end
								end

								if (!commandTable.allowDead and !LocalPlayer():Alive()) then
									return
								end
							end
						end

						Options[k] = v.syntax
					end
				end
			end
		end

		table.sort(Options)
	end

	function PLUGIN:OnChatTab(text)
		print("TAB!!!")
	end

	function PLUGIN:FinishChat()
		Options = {}
	end

	function PLUGIN:HUDPaint()
		if (!Options) then return end

		local ChatBoxPosX, ChatBoxPosY = chat.GetChatBoxPos()

		local count = 1
		for option, syntax in pairs(Options) do
			if (count <= 13) then
				draw.SimpleText("/"..option.." "..syntax, "nut_ChatFont", ChatBoxPosX + 522, ChatBoxPosY - 76 + count*20, Color(255,255,255,255))

				count = count + 1
			else
				draw.SimpleText("...", "nut_ChatFont", ChatBoxPosX + 522, ChatBoxPosY - 76 + 280, Color(255,255,255,255))
				break
			end
		end
	end
end


