--STARTUP
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()


function scene:create(event)

			local startUp = self.view



			local scribe = display.newImageRect(startUp, "frontpagelogo.png",250,125)
			scribe.x = display.contentCenterX
			scribe.y = display.contentCenterY-120
			scribe:toFront();

			local function viewNotes( event )

				    if ( "ended" == event.phase ) then
				        print( "viewNotes was pressed and released" )
				    	   composer.gotoScene("home2","zoomOutInFade")

				    end

				end

				-- sign up button
				local viewNotes = widget.newButton(
				    {
				    	shape = "roundedRect",
				        height = 40,
				     	id = "viewNotes",
				        label = "VIEW  NOTES",
				        onRelease = viewNotes,
				        font = composer.getVariable("defaultFont"),
				        fontSize=13,
				        fillColor = { default={ 1,0,0,0.3}, over={ 0, 0, 0, 0 } },
				        labelColor = {  default={ 1,1,1,1 } , over={1,0,0,0.3}},
				        strokeColor = { default={0,0,0,0}, over= {1,0,0,0.3}},
       					strokeWidth = 1

				    }

				)

				-- positioning sign up button
				viewNotes.x = display.contentCenterX
				viewNotes.y = scribe.y + scribe.height + 150
				startUp:insert(viewNotes)


				local function scribe( event )

				    if ( "ended" == event.phase ) then
				        print( "Button scribe nwas pressed and released" )


				       composer.gotoScene("scribe","slideDown")
				        --composer.removeScene("startUp",true)


				   	 end
				end


				--creating log in button

				local scribe = widget.newButton(
				    {
				    	shape = "roundedRect",
				        height = 40,
				        id = "scribe",
				        label = "SCRIBE  MORE",
				        fontSize = 13,
     			     	font = composer.getVariable("defaultFont"),
				        onEvent = scribe,
				        fillColor = { default={ 0.9,0,1,0.4 } , over={ 0, 0, 0, 0 }},
				        labelColor = {  default={ 1,1,1,1 }, over= {0.9,0,1,0.4}},
				        strokeColor = { default={0,0,0,0}, over= {0.9,0,1,0.4}},
       					strokeWidth = 1
				    }

				)

				--positioning log in buttom


				scribe.x = display.contentCenterX
				scribe.y = viewNotes.y + viewNotes.height + 15
				startUp:insert(scribe)

	end




function scene:show( event )
	startUp = self.view;


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
	startUp = self.view;
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
	startUp = self.view
	startUp:removeSelf();
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
