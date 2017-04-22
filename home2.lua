local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()
local sqlite3 = require( "sqlite3" )

local path = system.pathForFile( "Notes.db", system.DocumentsDirectory )
local db = sqlite3.open( path )
composer.setVariable("title"," ")

composer.recycleOnSceneChange = true

-- Create scene
function scene:create( event )
	local home = self.view
	local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)
	local tabBarHeight = display.contentHeight
	local themeID = composer.getVariable( "themeID" )

----------------------------------------------------------------------------------------------------------

local i = 0
	local entry = {}
	local arrayOfID = {}
	local nametag = " "



----------------------------------------------------------------------------------------------------------


	-- Set color variables depending on theme
	local tableViewColors = {
		rowColor = { default = { 1 }, over = { 30/255, 144/255, 1 } },
		lineColor = { 220/255 },
		catColor = { default = { 150/255, 160/255, 180/255, 200/255 }, over = { 150/255, 160/255, 180/255, 200/255 } },
		defaultLabelColor = { 0, 0, 0, 0.6 },
		catLabelColor = { 0 }
	}
	if ( themeID == "widget_theme_android_holo_dark" ) then
		tableViewColors.rowColor.default = { 48/255 }
		tableViewColors.rowColor.over = { 72/255 }
		tableViewColors.lineColor = { 36/255 }
		tableViewColors.catColor.default = { 80/255, 80/255, 80/255, 0.9 }
		tableViewColors.catColor.over = { 80/255, 80/255, 80/255, 0.9 }
		tableViewColors.defaultLabelColor = { 1, 1, 1, 0.6 }
		tableViewColors.catLabelColor = { 1 }
	elseif ( themeID == "widget_theme_android_holo_light" ) then
		tableViewColors.rowColor.default = { 250/255 }
		tableViewColors.rowColor.over = { 240/255 }
		tableViewColors.lineColor = { 215/255 }
		tableViewColors.catColor.default = { 220/255, 220/255, 220/255, 0.9 }
		tableViewColors.catColor.over = { 220/255, 220/255, 220/255, 0.9 }
		tableViewColors.defaultLabelColor = { 0, 0, 0, 0.6 }
		tableViewColors.catLabelColor = { 0 }
	end
	
	-- Forward reference for the tableView
	local tableView
	
	-- Text to show which item we selected
	local itemSelected = display.newText( "User selected row ", 0, 0, native.systemFont, 16 )
	itemSelected:setFillColor( unpack(tableViewColors.catLabelColor) )
	itemSelected.x = display.contentWidth+itemSelected.contentWidth
	itemSelected.y = display.contentCenterY
	home:insert( itemSelected )
	
	-- Function to return to the tableView
	local function goBack( event )
		transition.to( tableView, { x=display.contentWidth*0.5, time=600, transition=easing.outQuint } )
		transition.to( itemSelected, { x=display.contentWidth+itemSelected.contentWidth, time=600, transition=easing.outQuint } )
		transition.to( event.target, { x=display.contentWidth+event.target.contentWidth, time=480, transition=easing.outQuint } )
	end
	
	-- Back button
	local backButton = widget.newButton {
		width = 128,
		height = 32,
		label = "back",
		onRelease = goBack
	}
	backButton.x = display.contentWidth+backButton.contentWidth
	backButton.y = itemSelected.y+itemSelected.contentHeight+16
	home:insert( backButton )
	
	-- Listen for tableView events
	local function tableViewListener( event )
		local phase = event.phase
		--print( "Event.phase is:", event.phase )
	end


	-- Handle row rendering
	local function onRowRender( event )
		local phase = event.phase
		local row = event.row


		local groupContentHeight = row.contentHeight
		

		local rowTitle = display.newText( row, nametag, 0, 0, nil, 14 )
		rowTitle.x = 10
		rowTitle.anchorX = 0
		rowTitle.y = groupContentHeight * 0.5
		if ( row.isCategory ) then
			rowTitle:setFillColor( unpack(row.params.catLabelColor) )
			rowTitle.text = rowTitle.text.." (category)"
		else
			rowTitle:setFillColor( unpack(row.params.defaultLabelColor) )
		end
	end
	
	-- Handle row updates
	local function onRowUpdate( event )
		local phase = event.phase
		local row = event.row
		--print( row.index, ": is now onscreen" )
	end
	
	-- Handle touches on the row
	local function onRowTouch( event )


		local phase = event.phase
		local row = event.target
		if ( "release" == phase ) then

						local this = row.index
						print("WHAT ROW IS THIS: "..this)
						local index = arrayOfID[this]
						print("THE ID IM LOOKING FOR: "..index)

						i = 0

				       for row in db:nrows( [[SELECT * FROM Entries WHERE id =]]..index..[[;")]]) do

					    print( "Row " .. row.id )

					    i = i+1

					    entry =
					    {
					    	id = row.id,
					        title = row.title,
					        content = row.content,
					        end_date = row.end_date,
					        x = row.x,
					        y = row.y,
					     }


				       	local z = tonumber(entry.id)
					     local t = tostring(entry.title)
					     local c
					     if(tostring(entry.content) ~= "nil") then
					     c  =tostring(entry.content)
					 	else
					 	 c = "nothing is written here"
					 	end
					     local  e = tostring(entry.end_date)
					     local x = tonumber(entry.x)
					     local y = tonumber(entry.y)

					     composer.setVariable("ID",z)
					     composer.setVariable("title",t)
					     composer.setVariable("content",c)
					     composer.setVariable("end_date",e)

					 end
					   
					   	composer.setVariable("prevScene","home2")
				        composer.gotoScene( "viewNote", { effect = "fade", time = 300 } )

			
		end
	end
	
	-- Create a tableView
	tableView = widget.newTableView
	{
		top = 32-oy,
		left = -ox,
		width = display.contentWidth+ox+ox, 
		height = display.contentHeight-50,
		hideBackground = true,
		listener = tableViewListener,
		onRowRender = onRowRender,
		onRowUpdate = onRowUpdate,
		onRowTouch = onRowTouch,
	}
	home:insert( tableView )

	-- Create 75 rows



	for row in db:nrows("SELECT id,title FROM Entries;") do
    print( "Row " .. row.id )

    i = i+1
    	isFirst = false;

    entry[#entry+1] =
    {
    	id = row.id,
        title = row.title,
     }

     local z = tonumber(entry[i].id)
     local t = tostring(entry[i].title)

     print("THIS IS Z: "..z)
     print("THIS IS T: "..t)
     
     composer.setVariable("ID",z)
     composer.setVariable("title",t)
     
     nametag = tostring(composer.getVariable("title") )

     arrayOfID[i] = z

		local isCategory = false
		local rowHeight = 32
		local rowColor = { 
			default = tableViewColors.rowColor.default,
			over = tableViewColors.rowColor.over,
		}

		-- Insert the row into the tableView
		tableView:insertRow
		{
			isCategory = isCategory,
			rowHeight = rowHeight,
			rowColor = rowColor,
			lineColor = tableViewColors.lineColor,
			params = { defaultLabelColor=tableViewColors.defaultLabelColor, catLabelColor=tableViewColors.catLabelColor }
		}
	end



local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)
-----------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
				
				local function delete( event )
					

				    if ( "ended" == event.phase ) then
				        print( "delete was pressed and released" )
				     			composer.setVariable("prevScene", "home2")
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
				        composer.setVariable("prevScene","home2")
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
				        composer.setVariable("prevScene","home2")
				    	  	    composer.gotoScene( "home" ,"zoomOutInFade")

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

function scene:hide( event )
	--local sceneGroup = self.view
	home = self.view;
	local phase = event.phase
	
	if event.phase == "will" then
			home:removeSelf();
			--tableView:removeSelf();


		-- Called when the scene is on screen and is about to move off screen
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	home = self.view
				--tableView:removeSelf();

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

