--editNote

local composer = require( "composer" )
local widget = require( "widget" )
local sqlite3 = require( "sqlite3" )

local path = system.pathForFile( "Notes.db", system.DocumentsDirectory )
local db = sqlite3.open( path )


local scene = composer.newScene()

composer.recycleOnSceneChange = true

function scene:create(event)

			local editNote = self.view
			local y = 5, title, content
			local titleChanged, contentChanged  = false, false
			local oldTitle, oldContent

			


			local t = display.newText(editNote, "Title: ", display.contentCenterX, y,composer.getVariable("defaultFont"),12)
			t:setFillColor(0)
			local ttf = native.newTextField( display.contentCenterX, t.y+30, 240, 30 )

			if (tostring(composer.getVariable("title")) ~= "nil") then
				ttf.placeholder = tostring(composer.getVariable("title"));
			else
				ttf.placeholder= "What is this about?"

			end
			editNote:insert(ttf)
			editNote:insert(t)



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
			local c = display.newText(editNote, "Content: ", display.contentCenterX, ttf.y+30,composer.getVariable("defaultFont"),12)
			c:setFillColor(0)
			ctextBox = native.newTextBox( display.contentCenterX, c. y+155, 240, 270 )



			if (tostring(composer.getVariable("content")) ~= "nil") then
					ctextBox.text = tostring(composer.getVariable("content"));
				else
				ctextBox.text = "Write your heart out!"
			end
			ctextBox.isEditable = true
			editNote:insert(ctextBox)
			editNote:insert(c)

			
			local function onCom( event)  

			end    			
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------
			local function editDeadline( event )

					title = ttf.text
					content = ctextBox.text


					oldTitle = tostring( composer.getVariable("title") )
					oldContent = tostring( composer.getVariable("content")) 

					if(tostring(title) ~= "") then
						composer.setVariable("title", title  ) 
					elseif(tostring(content) ~= "")then
					 composer.setVariable("content", content) 
					end


					 if(oldTitle ~= tostring( composer.getVariable("title") ) ) then
					 	titleChanged = true
					 end



 					if(oldContent ~= tostring( composer.getVariable("content") ) ) then
					 	contentChanged = true
					 end


					 print("NEW TITLE AND CONTENT"..tostring( title) )


				    if ( "ended" == event.phase ) then
				        print( "editDeadline was pressed and released" )

					       		composer.setVariable("prevScene", "editNote")
					    	   composer.gotoScene("setdeadline","slideUp")
					    	
				    	  
				    end

			end
		
				local editDeadline = widget.newButton(
				    {
				    	shape = "roundedRect",
				        height = 25,
				        width = 140,
				     	id = "editDeadline",
				     	label = "ADD or EDIT DEADLINE",
				        onRelease = editDeadline,
				        font = composer.getVariable("defaultFont"),
				        fontSize=12,
				        fillColor = { default={ 0, 0, 0, 0 }, over={ 1,0,0,0.3} },
				        labelColor = {  default={1,0,0,0.3}, over={ 1,1,1,1 } },
				        strokeColor = { default={1,0,0,0.3}, over={0,0,0,0} },
       					strokeWidth = 1

				    }

				)

				editDeadline.x = display.contentCenterX
				editDeadline.y = ctextBox.y + ctextBox.height-110
				editNote:insert(editDeadline)

				local function editNotes( event )


					title = tostring(ttf.text)
					content = ctextBox.text

					 

				    if ( "ended" == event.phase ) then
				        print( "Button editNote nwas pressed and released" )

				        if(tostring(ctextBox.text) == "") then
							local alert = native.showAlert( "Scribe", "You have to at least write the content of a note for it to be saved!", { "OK"}, onCom  )
					end


					if(string.len(title) > 140) then
								local alert = native.showAlert( "editNote", "Your title is too long. Keep it shorter than 140 characters!", { "OK"}, onCom  )
					end

					
					composer.setVariable("prevScene", "editNote")

					oldTitle = tostring( composer.getVariable("title") )
					oldContent = tostring( composer.getVariable("content"))

					if(tostring(title) ~= "") then
							composer.setVariable("title", title  ) 
					elseif(tostring(content) ~= "")then
					 composer.setVariable("content", content) 
					end

					 if(oldTitle ~= tostring( composer.getVariable("title") ) ) then
					 	titleChanged = true
					 end

 					if(oldContent ~= tostring( composer.getVariable("content") ) ) then
					 	contentChanged = true
					 end

						        				


				        local function onComplete( event )
						    if ( event.action == "clicked" ) then
						        local i = event.index
								        if ( i == 1 ) then

								        			display.remove(ttf)
								          	      	 composer.gotoScene("home2","slideDown")
								        elseif(i == 2) then
								        			display.remove(ttf)
							          	     	 	composer.gotoScene("viewNote","slideDown")

								        end
						    end
						end
						  
						  		  			local tD = tostring( composer.getVariable("title" ) )
						        			local cD = tostring( composer.getVariable("content" ) )
						        			local dD = tostring(composer.getVariable("end_date") )	
						        			print("TITLE:"..tD.."  CONTENT"..cD.."   END DATE: "..dD) 


					if(titleChanged == true) then

						print("changing titles yo")        			
						local q = [[UPDATE ENTRIES SET title=']] ..tD..[[' WHERE id=]]..tonumber(composer.getVariable("ID"))..[[;]]
						db:exec( q )

					end
					
					if(contentChanged == true) then
						print("changing content yo")        				
						local q = [[UPDATE ENTRIES SET content=']] ..cD..[[' WHERE id=]]..tonumber(composer.getVariable("ID"))..[[;]]
						db:exec( q )
						
					end

					if(tostring(composer.getVariable("dateChanged") == "t")) then
						print("changing dates yo")        			
						local q = [[UPDATE ENTRIES SET content=']] ..cD..[[' WHERE id=]]..tonumber(composer.getVariable("ID"))..[[;]]
						db:exec( q )

					end


		    			-- local thisID = db:last_insert_rowid()
		    			-- composer.setVariable("ID", tonumber( thisID ) )
		    			-- print("THIS IS THE CURRENT ID: "..tostring( composer.getVariable("ID" ) ) )


		  
		    				

								local alert = native.showAlert( "editNote", "Your note has been successfully edited.", { "OK", "View Note"}, onComplete )

				        --composer.removeScene("startUp",true)


				   	
				end
			end



					local editNotes = widget.newButton(
				    {
				    	shape = "roundedRect",
				        height = 35,
				        id = "editNotes",
				        label = "EDIT NOTE",
				        fontSize = 13,
     			     	font = composer.getVariable("defaultFont"),
				        onEvent = editNotes,
				        fillColor = { default={ 0.9,0,1,0.4 }, over={ 1,1,1,1 } },
				        labelColor = {  default={1,1,1,1}, over={ 0.9,0,1,0.4} },
				        strokeColor = { default={0,0,0,0}, over={0.9,0,1,0.4} },
       					strokeWidth = 1
				    }

				)

				--positioning log in buttom


				editNotes.x = display.contentCenterX
				editNotes.y = editDeadline.y + editDeadline.height + 40
				editNote:insert(editNotes)


			local function backListener(event)
				if ( "ended" == event.phase ) then

						    print( "Back was pressed and released" )
						    composer.gotoScene( tostring( composer.getVariable("prevScene")),"zoomOutInFade")
						   
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
							backbutton.y = editNote.y + editNote.height + 5
							editNote:insert(backbutton)




end




function scene:show( event )
	editNote = self.view;


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
	editNote = self.view;
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
	editNote = self.view;
	display.remove(ttf)
	editNote:removeSelf();
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
