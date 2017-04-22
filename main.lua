-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require "composer"
local sqlite3 = require( "sqlite3" )
local json = require( "json")
local widget = require( "widget" )


 
local path = system.pathForFile( "Notes.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

local tablesetup = [[CREATE TABLE IF NOT EXISTS Entries ( `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, `title` TEXT, 
						`content` TEXT NOT NULL, `start_date` TEXT NOT NULL,
						`end_date` TEXT );]]
db:exec( tablesetup )

 local ts = [[CREATE TABLE `Position` ( `x` INTEGER NOT NULL, `y` INTEGER NOT NULL, `order` INTEGER NOT NULL, `pid` INTEGER NOT NULL UNIQUE, FOREIGN KEY(pid) REFERENCES Entries(id) )]]
db:exec( ts )


local function onSystemEvent( event )
	    if ( event.type == "applicationStart" ) then

	    elseif(event.type == "applicationSuspend") then

	    elseif( event.type == "applicationResume") then	

    	elseif( event.type == "applicationExit" ) then

	        if ( db and db:isopen() ) then
	            db:close()
        end
    end
end

Runtime:addEventListener( "system", onSystemEvent )


composer.setVariable("defaultFont", "Raleway-Regular.ttf" )

local themeIDs = {
					"widget_theme_android_holo_dark",
					"widget_theme_android_holo_light",
					"widget_theme_android",
					--"widget_theme_ios7",
					--"widget_theme_ios", 
				}
local themeNames = {
					"Android Holo Dark",
					"Android Holo Light",
					"Android 2.x",
					--"iOS7+",
					--"iOS6"
				}
local function showWidgets( widgetThemeNum )

	local halfW = display.contentCenterX
	local halfH = display.contentCenterY
	local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)


	--local titleText = display.newText( "Widget Demo - "..themeNames[widgetThemeNum], halfW, 100, native.systemFont, 14 )

	if ( themeIDs[widgetThemeNum] ~= auto ) then
		-- Set theme based on user selection
		widget.setTheme( themeIDs[widgetThemeNum] )

		-- Store theme in Composer variable for use elsewhere
		composer.setVariable( "themeID", themeIDs[widgetThemeNum] )

		
		-- Change background color depending on theme


	if ( themeIDs[widgetThemeNum] == "widget_theme_ios" or themeIDs[widgetThemeNum] == "widget_theme_android" ) then
			display.setDefault( "background", 231/255, 224/255, 212/255, 0.54  )
		elseif ( themeIDs[widgetThemeNum] == "widget_theme_android_holo_light" ) then
			display.setDefault("background",243/255, 247/255, 255/255)
		elseif ( themeIDs[widgetThemeNum] == "widget_theme_android_holo_dark" ) then
			display.setDefault( "background",  0.725, 0.725, 0.725, 0.9 )
		end
	end

	composer.setVariable("themeID", themeIDs[widgetThemeNum])

	-- Create buttons table for the tabBar

end
local function themeChooser( event )
	--print( "themeChooser: "..json.encode(event) )
	

	local chosenTheme = event.index
	if chosenTheme < 1 then
		-- Default to the first theme choice if one wasn't made (event.index == 0).
		chosenTheme = 1
	end
	showWidgets( chosenTheme )

	local options = {
    effect = "zoomInOutFade",
    time = 500
}

	composer.gotoScene("startup",options);

end

native.showAlert( "Choose Theme", "Widgets can be skinned to look like different device OS versions.", themeNames, themeChooser )






