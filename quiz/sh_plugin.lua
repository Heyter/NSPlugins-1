PLUGIN.name = "Quiz"
PLUGIN.author = "Qemist"
PLUGIN.desc = "A quiz which will be shown the first time a player joins your server which they will have to answer correctly to gain access to the server."
PLUGIN.players = {}

nut.util.Include("sh_config.lua")
nut.util.Include("sh_lang.lua")

function PLUGIN:PlayerInitialSpawn(client)
	local steamid = client:SteamID64()
	local condition = "steamid = "..steamid.." AND rpschema = '"..SCHEMA.uniqueID.."'"
	local tables = "passedQuiz, steamid"

	timer.Simple(5, function()
		nut.db.FetchTable(condition, tables, function(data)
			self.players[data.steamid] = data.passedQuiz
		end, nut.config.dbPlyTable)

		local passed = tobool(self.players[steamid])

		if (!passed) then
			netstream.Start(client, "nut_Quiz")
		end
	end)
end


if (SERVER) then
	nut.db.Query("ALTER TABLE "..nut.config.dbPlyTable.." ADD passedQuiz boolean DEFAULT false")

	netstream.Hook("nut_QuizFailed", function(client)
		if (!client) then return end

		client:Kick(nut.config.quiz.kickMessage)
	end)

	netstream.Hook("nut_QuizPassed", function(client)
		if (!client) then return end

		local steamid = client:SteamID64()
		local condition = "steamid = "..steamid.." AND rpschema = '"..SCHEMA.uniqueID.."'"
		local data = {}

		data.passedQuiz = "true"

		nut.db.UpdateTable(condition, data, nut.config.dbPlyTable)

		netstream.Start(client, "nut_CharMenu", true)
	end)	
else
	local PANEL = {}
		function PANEL:Init()
			self:SetPos(ScrW() * 0.250, ScrH() * 0.125)
			self:SetSize(ScrW() * nut.config.quiz.menuWidth, ScrH() * nut.config.quiz.menuHeight)
			self:MakePopup()
			self:ShowCloseButton(false)
			self:SetDraggable(false)
			self:SetDrawOnTop(true)
			self:SetTitle(nut.lang.Get("quiz_title"))

			local noticePanel = self:Add( "nut_NoticePanel" )
			noticePanel:Dock(TOP)
			noticePanel:DockMargin(0, 0, 0, 5)
			noticePanel:SetType(1)
			noticePanel:SetText(nut.lang.Get("quiz_tip", "Qemist"))
			
			self.list = self:Add("DScrollPanel")
			self.list:Dock(FILL)
			self.list:SetDrawBackground(true)

			self.questions = {}
			self.options = {}
			self.answers = {}	

			for k, question in ipairs(nut.config.quiz.questions) do
				text = self.list:Add("DLabel")
				text:Dock(TOP)
				text:DockMargin(4, 0, 4, 0)
				text:SetDark(true)
				text:SetText(question.question)

				option = self.list:Add("DComboBox")
				
				for _, v in ipairs(question.options) do
					option:AddChoice(v)
				end

				option.OnSelect = function( panel, index, value )
					self.answers[k] = {["correct"] = question.correct, ["chosen"] = index}
				end

				option:Dock(TOP)
				option:DockMargin( 4, 0, 4, 10 )
				option:SetValue(question.text and question.text or nut.config.quiz.defaultText)

				self.questions[k] = question
				self.options[k] = option
			end

			self.submit = self:Add("DButton")
			self.submit:Dock(BOTTOM)
			self.submit:DockMargin(0, 5, 0, 0)
			self.submit:SetText("Submit answers")
			self.submit.DoClick = function()
				for k,option in pairs(self.options) do
					local question = self.questions[k]

			    	if (option:GetValue() == (question.text and question.text or nut.config.quiz.defaultText)) then
			    		netstream.Start("nut_QuizFailed", LocalPlayer())
			    		return
			    	end
			    end

			    for _,answer in pairs(self.answers) do
			    	if (answer.chosen ~= answer.correct) then
			    		netstream.Start("nut_QuizFailed", LocalPlayer())
			    		return
			    	end			    		
			    end

			    netstream.Start("nut_QuizPassed", LocalPlayer())
			    self:Close()
			end
		end
	vgui.Register("nut_Quiz", PANEL, "DFrame")

	netstream.Hook("nut_Quiz", function(data)
		if (nut.gui.charMenu) then
			nut.gui.charMenu:Remove()
		end

		nut.gui.data = vgui.Create("nut_Quiz")
	end)
end