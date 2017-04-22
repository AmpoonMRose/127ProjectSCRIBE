--scribe

local composer = require( "composer" )
local widget = require( "widget" )
local sqlite3 = require( "sqlite3" )

local path = system.pathForFile( "Notes.db", system.DocumentsDirectory )
local db = sqlite3.open( path )


local scene = composer.newScene()

composer.recycleOnSceneChange = true

function scene:create(event)

			local scribe = self.view
			local y = 5, title, content
			local dbpushed = false

			


			local t = display.newText(scribe, "Title: ", display.contentCenterX, y,composer.getVariable("defaultFont"),12)
			t:setFillColor(0)
			local ttf = native.newTextField( display.contentCenterX, t.y+30, 240, 30 )

		if(tostring(composer.getVariable("title")) ~= "home2") then
			print("PLS COME HERE")
			if (tostring(composer.getVariable("title")) ~= "nil" ) then
				ttf.placeholder = tostring(composer.getVariable("title"));
			end
		else
				ttf.placeholder= "What is this about?"
		end
			scribe:insert(ttf)
			scribe:insert(t)



			local function textListener( event )
 
			    if ( event.phase == "began" ) then
			        -- User begins editing "ctextBox"
			        ctextBox.text = ""
			 
			    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
			        -- Output resulting text from "ctextBox"
			        content = event.target.text;
			    elseif ( event.phase == "editing" ) then
			        print( event.newCharacters )
			        print( event.oldText )
			        print( event.startPosition )
			        print( event.text )
			    end
			end
			 
			-- Create text box
			local c = display.newText(scribe, "Content: ", display.contentCenterX, ttf.y+30,composer.getVariable("defaultFont"),12)
			c:setFillColor(0)
			ctextBox = native.newTextBox( display.contentCenterX, c. y+155, 240, 270 )
			if (tostring(composer.getVariable("content")) ~= "nil") then
				ctextBox.text = tostring(composer.getVariable("content"));
			end
			ctextBox.isEditable = true
			scribe:insert(ctextBox)
			scribe:insert(c)

			
			local function onCom( event)  

			end    			
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------
			local function addDeadline( event )

					 title = ttf.text
					content = ctextBox.text

					local function onCom( event )
						-- body
					end

					dbpushed = true

					composer.setVariable("title", title  ) 
					 composer.setVariable("content", content) 

				    if ( "ended" == event.phase ) then
				        print( "addDeadline was pressed and released" )

				        if(tostring(ctextBox.text) == "" and tostring(title) == "") then
							local alert = native.showAlert( "Scribe", "You have to at least write the content of a note for it to be saved!", { "OK"}, onCom  )
						else

				        	composer.setVariable("prevScene", "scribe")
				    	   composer.gotoScene("setDeadline","slideUp")
				    	 end

				    end

				end

				local addDeadline = widget.newButton(
				    {
				    	shape = "roundedRect",
				        height = 25,
				        width = 140,
				     	id = "addDeadline",
				     	label = "ADD or EDIT DEADLINE",
				        onRelease = addDeadline,
				        font = composer.getVariable("defaultFont"),
				        fontSize=12,
				        fillColor = { default={ 0, 0, 0, 0 }, over={ 1,0,0,0.3} },
				        labelColor = {  default={1,0,0,0.3}, over={ 1,1,1,1 } },
				        strokeColor = { default={1,0,0,0.3}, over={0,0,0,0} },
       					strokeWidth = 1

				    }

				)

				-- positioning sign up button
				addDeadline.x = display.contentCenterX
				addDeadline.y = ctextBox.y + ctextBox.height-110
				scribe:insert(addDeadline)

				local function addNote( event )


					title = ttf.text
					content = ctextBox.text



				    if ( "ended" == event.phase ) then
				        print( "Button scribe nwas pressed and released" )


			        if(tostring(ctextBox.text) == "" and tostring(ttf.text) == "") then
							local alert = native.showAlert( "Scribe", "You have to at least write the content of a note for it to be saved!", { "OK"}, onCom  )
					end

					if(string.len(title) > 140) then
								local alert = native.showAlert( "Scribe", "Your title is too long. Keep it shorter than 140 characters!", { "OK"}, onCom  )
					end

					

					if(tostring(composer.getVariable("prevScene") )  ~= "setDeadline") then
						composer.setVariable("title", title) 
					end

					 composer.setVariable("content", content) 
					composer.setVariable("prevScene", "scribe")
						        				

				        local function onComplete( event )
						    if ( event.action == "clicked" ) then
						        local i = event.index
						        if ( i == 1 ) then

						        			display.remove(ttf)
						          	       composer.gotoScene("home2","zoomOutInFade")
						        elseif(i == 2) then
						        		display.remove(ttf)
					          	     	  composer.gotoScene("viewNote","slideDown")

						        end
						    end
						end
						  
						  		  			local tD = tostring( composer.getVariable("title" ) )
						        			local cD = tostring( composer.getVariable("content" ) )
						        			local dD = tostring(composer.getVariable("end_date") )	
						        			print("TITLE:"..tD.."CONTENT"..cD.."END DATE: "..dD) 
						        			
						
					local q = [[INSERT INTO Entries VALUES (NULL, ']] .. tD .. [[',']] .. cD .. [[', datetime('now', 'localtime'),']] ..dD.. [[');]]
    				db:exec( q )

    				local thisID = db:last_insert_rowid()
    				composer.setVariable("ID", tonumber( thisID ) )
    				print("THIS IS THE CURRENT ID: "..tonumber(composer.getVariable("ID" )  ) )



    				local k = [[INSERT INTO Position VALUES (]]..display.contentCenterX..[[,]]..display.contentCenterY.. [[,]]..tonumber(composer.getVariable("ID" ))..[[,]]..tonumber(composer.getVariable("ID" ))..[[);]]
    				db:exec( k )

   				 	composer.setVariable("dateChanged","f")


    				
  
    				

						local alert = native.showAlert( "Scribe", "Your note has been added to your collection. Place it where you want to!", { "OK", "View Note"}, onComplete )

				        --composer.removeScene("startUp",true)


				   	 end
				end



					local addNote = widget.newButton(
				    {
				    	shape = "roundedRect",
				        height = 35,
				        id = "addNote",
				        label = "ADD NOTE",
				        fontSize = 13,
     			     	font = composer.getVariable("defaultFont"),
				        onEvent = addNote,
				        fillColor = { default={ 0.9,0,1,0.4 }, over={ 1,1,1,1 } },
				        labelColor = {  default={1,1,1,1}, over={ 0.9,0,1,0.4} },
				        strokeColor = { default={0,0,0,0}, over={0.9,0,1,0.4} },
       					strokeWidth = 1
				    }

				)

				--positioning log in buttom


				addNote.x = display.contentCenterX
				addNote.y = addDeadline.y + addDeadline.height + 40
				scribe:insert(addNote)


			local function backListener(event)
				if ( "ended" == event.phase ) then

						    print( "Back was pressed and released" )
						    composer.gotoScene("home2","slideDown")
						   
				end
			end
		
		
			local backbutton = widget.newButton(
						  {
						  		shape = "roundedRect",
							   	height = 10,
							   	width= 120,
						  		id = "backButton",
								label = " back ",
								fontSize = 10,
								onEvent = backListener,
								labelColor = { default={ 0.0, 0.0, 0.0, 0.5 }, over={ 0, 0.5, 0.5, 0.5 } },
							    fillColor = { default={ 0, 0, 0, 0 }, over={ 0, 0, 0, 0 } },
							}
						)

						--positioning back button

							backbutton.x = display.contentCenterX
							backbutton.y = addNote.y + addNote.height 
							scribe:insert(backbutton)




			
	end




function scene:show( event )
	scribe = self.view;


	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	--local sceneGroup = self.view
	scribe = self.view;
	local phase = event.phase
	
	if event.phase == "will" then

		-- Called when the scene is on screen and is about to move off screen
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	scribe = self.view;
	display.remove(ttf)
	scribe:removeSelf();
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- teamDescriptiontf:removeSelf();
	-- projNametf:removeSelf();
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
