--viewNote
local composer = require( "composer" )
local widget = require( "widget" )
local sqlite3 = require( "sqlite3" )

local path = system.pathForFile( "Notes.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

local scene = composer.newScene()




function scene:create(event)

			local viewNote = self.view

			local function onCom(event)

			end	

			local function onComplete( event )
						    if ( event.action == "clicked" ) then
						        local i = event.index
						        if ( i == 1 ) then
						      	     	  composer.gotoScene("viewNote","slideDown")
						        elseif(i == 2) then
						        	local q = [[DELETE FROM Entries WHERE id =]]..tonumber (composer.getVariable("ID"))..[[;]]
									db:exec( q )

									local alert = native.showAlert( "Scribe", "Note deleted successfully.", {OK}, onCom )


						          	composer.gotoScene("home2","slideDown")

						        end
						    end
						end
								
			local alert = native.showAlert( "Scribe", "Are you sure you want to delete this note?", { "No", "Yes"}, onComplete )



end


function scene:show( event )
	viewNote = self.view;


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
	viewNote = self.view;
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
	viewNote = self.view
	viewNote:removeSelf();
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
