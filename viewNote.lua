--viewNote
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()




function scene:create(event)

			local viewNote = self.view
			local y = 0
----------------------------------------------------------------------------------------------------------------------

			local t = display.newText(viewNote, "Title: ", display.contentCenterX, y,composer.getVariable("defaultFont"),12)
			t:setFillColor(0.6)

			local options = {
			   text = composer.getVariable("title"),
			   x = display.contentCenterX,
			   y = t.y+ t.height+ 40,
			   width = display.contentWidth-60,
			   height = 80,
			   font = composer.getVariable("defaultFont"),
			   fontSize = 13,
			   align = "center"
			}
			 
			local textField = display.newText(options )
			textField:setFillColor( 0, 0, 0 )
			viewNote:insert(textField);


			local myRectangle = display.newRect(viewNote,  display.contentCenterX, textField.y, textField.width, textField.height )
			myRectangle:setFillColor( 1)
			myRectangle:toBack()

			local w = display.newText(viewNote, "Content: ", display.contentCenterX, myRectangle.y+myRectangle.height/2+20,composer.getVariable("defaultFont"),12)
			w:setFillColor(0.6)




local myText= tostring( composer.getVariable("content") )
 
local paragraphs = {}
local paragraph
local tmpString = myText
 
local scrollView = widget.newScrollView
{
    top = w.y + w.height,
    left = 30,
    width = display.contentWidth-60,
    height = 220,
    scrollWidth = display.contentWidth,
    scrollHeight = 8000
}
viewNote:insert(scrollView)
 
local options = {
    text = "",
    width = 250,
    font = composer.getVariable("defaultFont"),
    fontSize = 13,
    align = "left",
    x = scrollView.x,
    y = scrollView.y,

}
 
local yOffset = 10


if( string.find( tmpString, "\n" ) == true  ) then
	
		repeat
		    paragraph, tmpString = string.match( tmpString, "([^\n]*)\n(.*)" )
		    options.text = paragraph
		    paragraphs[#paragraphs+1] = display.newText( options )
		    paragraphs[#paragraphs].anchorX = 0
		    paragraphs[#paragraphs].anchorY = 0
		    paragraphs[#paragraphs].x = 10
		    paragraphs[#paragraphs].y = yOffset
		    paragraphs[#paragraphs]:setFillColor( 0 )
		    scrollView:insert( paragraphs[#paragraphs] )
		    yOffset = yOffset + paragraphs[#paragraphs].height
		until tmpString == nil or string.len( tmpString ) == 0
else
	
	options.text = tmpString
	paragraph = display.newText(options)
	paragraph:setTextColor(0)
	paragraph.anchorX = 0
	paragraph.anchorY = 0
	paragraph.x = 10
	paragraph.y = 10
	scrollView:insert(paragraph)
 

end


	local d = display.newText(viewNote, "Deadline Date and Time: ", display.contentCenterX, scrollView.y+scrollView.height-80,composer.getVariable("defaultFont"),12)
	d:setFillColor(0.6)

		local options2 = {
			   text = tostring( composer.getVariable("end_date") ),
			   x = display.contentCenterX,
			   y = d.y +d.height+10,
			   width = display.contentWidth-60,
			   height = 25,
			   font = composer.getVariable("defaultFont"),
			   fontSize = 15,
			   align = "center"
			}
			 
			local dd = display.newText(options2 )
			dd:setFillColor( 0, 0, 0 )
			viewNote:insert(dd);

	local myRect= display.newRect(viewNote,  display.contentCenterX, dd.y, dd.width, dd.height )
	myRect:setFillColor( 1)
	myRect:toBack()



	local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)

				
				local function delete( event )
					

				    if ( "ended" == event.phase ) then
				        print( "delete was pressed and released" )
				     			composer.setVariable("prevScene", "viewNote")
				    		 composer.gotoScene("delete","slideDown")

				    end

				end

			
				-- sign up button
				local delete = widget.newButton(
				    {
				    	defaultFile = "delete.png",
				        overFile = "delete-over.png",
				     	id = "delete",
				     	label = " ",
				        onRelease = delete,
				        
				    }

				)

				-- positioning sign up button
				delete.x = display.contentWidth*0.3 - ( ( display.contentWidth*0.15 ) - ( delete.width*0.5 ) )
				delete.y = display.contentHeight - (delete.height/2) + oy
				viewNote:insert(delete)

				local function edit( event )
					

				    if ( "ended" == event.phase ) then
				        print( "edit was pressed and released" )
				        composer.setVariable("prevScene","viewNote")
				    	 composer.gotoScene("editNote","slideUp")

				    end

				end

			
				-- sign up button
				local edit = widget.newButton(
				    {
				    	defaultFile = "edit.png",
				        overFile = "edit-over.png",
				     	id = "edit",
				     	label = " ",
				        onRelease = edit,
				        
				    }

				)

				-- positioning sign up button
				edit.x = delete.x + display.contentWidth*0.3
				edit.y = display.contentHeight - (edit.height/2) + oy
				viewNote:insert(edit)

				local function back( event )
					

				    if ( "ended" == event.phase ) then
				        print( "back was pressed and released" )
				    	  	    composer.gotoScene( "home2" ,"zoomOutInFade")

				    end

				end

			
				-- sign up button
				local back = widget.newButton(
				    {
				    	defaultFile = "back.png",
				        overFile = "back-over.png",
				     	id = "back",
				     	label = " ",
				        onRelease = back,
				        
				    }

				)

				-- positioning sign up button
				back.x = edit.x + display.contentWidth*0.3
				back.y = display.contentHeight - (back.height/2) + oy
				viewNote:insert(back)
-----------------------------------------------------------------------------------------------------------------------




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
