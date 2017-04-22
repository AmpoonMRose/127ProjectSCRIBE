--home
math.randomseed( os.time() )
local composer = require( "composer" )
local widget = require( "widget" )
local sqlite3 = require( "sqlite3" )
local scene = composer.newScene()


local path = system.pathForFile( "Notes.db", system.DocumentsDirectory )
local db = sqlite3.open( path )



function scene:create(event)

local home = self.view
local entry = {}
local isFirst = false;
-------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
 
-- The "onRowRender" function may go here (see example under "Inserting Rows", above)
 
-- Create the widget
local function onRowRender( event )
 
    -- Get reference to the row group
    local row = event.row
 
    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
 
    local rowTitle = display.newText( row, "Row " .. row.index, 0, 0, nil, 14 )
    rowTitle:setFillColor( 0 )
 
    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 0
    rowTitle.y = rowHeight * 0.5
end

local tableView = widget.newTableView(
    {
        left = 200,
        top = 200,
        height = 330,
        width = 300,
        onRowRender = onRowRender,
        onRowTouch = onRowTouch,
        listener = scrollListener
    }
)
 
-- Insert 40 rows
for i = 1, 40 do
    -- Insert a row into the tableView
    tableView:insertRow{}
end

-------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

local group = display.newGroup() 
home:insert(group)

local t = tostring(composer.getVariable("theme") )
local  entryButton
local paragraph

local function createEntry(a,x,y,title,content,end_date)

local function createText()

local options = {
	text = "",
     width = display.contentWidth/2.3,
     height = display.contentHeight/3.9,
    font = composer.getVariable("defaultFont"),
    fontSize = 13,
    align = "center",
}

paragraph = display.newText(options)

if(a == true) then
		print("turns out a was true waw")
		options.text = title
		paragraph.x = x
		paragraph.y = y
else

	options.text = tostring(composer.getVariable("title") )
	paragraph.x = display.contentCenterX
	paragraph.y = display.contentCenterY
end
paragraph = display.newText(options)
paragraph:setFillColor( 0 )




home:insert(paragraph)
paragraph:setFillColor( 0 )
paragraph:toFront()

end


local entryButton

local function createBox()

local function paragraphPosition(a,b)
	paragraph.x = a
	paragraph.y = b

end
--scrollView:insert(paragraph)



local function onTouch( event )
    local t = event.target
    
  
            if(event.numTaps == 1) then
                   composer.gotoScene( "viewNote", { effect = "fade", time = 300 } )
                   print("TAPPED!")
            end

            local phase = event.phase
            if "began" == phase then
                -- Make target the top-most object
                local parent = t.parent
                parent:insert( t )
                display.getCurrentStage():setFocus( t )
                print("TOUCHED!")

                
                -- Spurious events can be sent to the target, e.g. the user presses 
                -- elsewhere on the screen and then moves the finger over the target.
                -- To prevent this, we add this flag. Only when it's true will "move"
                -- events be sent to the target.
                t.isFocus = true
                
                -- Store initial position
                t.x0 = event.x - t.x
                t.y0 = event.y - t.y

            elseif t.isFocus then
                if "moved" == phase then
                    -- Make object move (we subtract t.x0,t.y0 so that moves are
                    -- relative to initial grab point, rather than object "snapping").
                    t.x = event.x - t.x0
                    t.y = event.y - t.y0
                    paragraphPosition(t.x, t.y)
                    
                    -- Gradually show the shape's stroke depending on how much pressure is applied.
                    if ( event.pressure ) then
                        t:setStrokeColor( 1, 1, 1, event.pressure )
                    end
                elseif "ended" == phase or "cancelled" == phase then
                    display.getCurrentStage():setFocus( nil )
                    t:setStrokeColor( 1, 1, 1, 0 )
                    t.isFocus = false

                    local q = [[UPDATE Position SET x=]]..t.x..[[, y=]]..t.y..[[ WHERE pid = 1;]]
					db:exec( q )

                    print(t.x)
                    print(t.y)

                    

                end
            end
    
    -- Important to return true. This tells the system that the event
    -- should not be propagated to listeners of any objects underneath.
    return true
end

-- Iterate through arguments array and create rounded rects (vector objects) for each item


   		 entryButton = widget.newButton{
        id = "entryButton",
        shape = "roundedRect",
        width = paragraph.width+15,
        height = paragraph.height+15,
        label = "",
        font = tostring( composer.getVariable("defaultFont")),
        fontSize = 14,
        fontColor = 0,
        labelColor = { default={ 0.0, 0.0, 0.0,1 }, over={ 0, 0.5, 0.5, 0.5 } },
       -- fillColor = { default={ 1, 1, 1, 0.9  }, over={ 1,1,1, 0.825 } },
        strokeColor = { default={0,0,0,0}, over={1, 1,1,1} },
        strokeWidth = 1,
        --onEvent = onTouch;
    }
    entryButton:setFillColor( math.random(200,255)/255, math.random(200,255)/255, math.random(200,255)/255,1)
    entryButton.x = paragraph.x;
    entryButton.y = paragraph.y;
    entryButton:addEventListener( "tap", onTouch );
    entryButton:addEventListener( "touch", onTouch );
    entryButton:toBack()
    home:insert(entryButton)
	group:insert(entryButton)


end

createText()
createBox()
end


----------------------------------------------------------------------------------------------------------


local i = 0

for row in db:nrows("SELECT * FROM Entries,Position;") do

    print( "Row " .. row.id )

    i = i+1
    	isFirst = false;

    entry[#entry+1] =
    {
        title = row.title,
        content = row.content,
        end_date = row.end_date,
        x = row.x,
        y = row.y,
     }

     local t = tostring(entry[i].title)
     local c
		     if(tostring(entry[i].content) ~= "nil") then
		     c  =tostring(entry[i].content)
		 	else
		 	 c = "nothing is written here"
 	end
     local  e = tostring(entry[i].end_date)
     local x = tonumber(entry[i].x)
     local y = tonumber(entry[i].y)
print(t..c..e..x..y)
end

if(tostring(composer.getVariable("prevScene")) == "nil") then

	    createEntry( true,x,y,t,c,e )

else
	  createEntry( false,x,y,t,c,e )

end

-----------------------------------------------------------------------------------------------------------------------
	local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)

				
				local function delete( event )
					

				    if ( "ended" == event.phase ) then
				        print( "delete was pressed and released" )
				     			composer.setVariable("prevScene", "home")
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
				home:insert(delete)

				local function edit( event )
					

				    if ( "ended" == event.phase ) then
				        print( "edit was pressed and released" )
				        composer.setVariable("prevScene","home")
				    	 composer.gotoScene("scribe","slideUp")

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
				home:insert(edit)

				local function back( event )
					

				    if ( "ended" == event.phase ) then
				        print( "back was pressed and released" )
				    	  	    composer.gotoScene( tostring(composer.getVariable("prevScene")) ,"zoomOutInFade")

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
				home:insert(back)

end




function scene:show( event )
	home = self.view;


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
	home = self.view;
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
	home = self.view
	home:removeSelf();
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
