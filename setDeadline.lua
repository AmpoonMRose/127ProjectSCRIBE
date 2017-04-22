
--*********************************************************************************************

local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

-- Create scene
function scene:create( event )
	local setDeadline = self.view
			local y= 20
			local oldDate

		

		local d = display.newText(scribe, "Choose the deadline date (mm-dd-yyyy): ", display.contentCenterX, y,composer.getVariable("defaultFont"),12)
		local d2 = display.newText(scribe, "and time (hh-mm): ", display.contentCenterX, d.y+ 20,composer.getVariable("defaultFont"),12)
		d:setFillColor(0)
		d2:setFillColor(0)
		setDeadline:insert(d)
		setDeadline:insert(d2)


	--print("msi: "..msi.." dsi: "..dsi.." ysi: "..ysi);
-- Create two tables to hold data for days and years      
	local days = {}
	local months = {}
	local years = {}
	local hours = {}
	local minutes = {}

	-- Populate the "days" table
	for d = 1, 31 do
	    days[d] = d
	end

	--Populate the "months" table
	for m = 1, 12 do
		months[m] = m;
	end

	-- Populate the "years" table
	for y = 1, 48 do
	    years[y] = 2016 + y
	end

	for h = 1, 24 do
	    hours[h] = h - 1
	end

	for m = 1, 60 do
	    minutes[m] = m - 1
	end

	-- Configure the picker wheel columns

	local cM, cD, cY = os.date("%m"), os.date("%d"), os.date("%Y")
		local cH, cMin = os.date("%H"), os.date("%M")

		local min = tonumber(cMin)
		local hr = tonumber(cH)
		local day = tonumber(cD)
		local mo = tonumber(cM)


	local columnData = 
	{
	    -- Months
	    { 
	        align = "center",
	        width = 40,
	        startIndex = mo,
	        labels = months,
	    },
	    -- Days
	    {
	        align = "center",
	        width = 40,
	        startIndex = day,
	        labels = days,
	    },
	    -- Years
	    {
	        align = "center",
	        width = 40,
	        startIndex = 1, --tonumber(os.date("%Y")),
	        labels = years,
	    },
	    {
			align = "right",
	        width = 80,
	        startIndex = hr+1,--tonumber(os.date("%m")),
	        labels = hours,
		},
		{
			align = "right",
	        width = 40,
	        startIndex = min+1,--tonumber(os.date("%m")),
	        labels = minutes,
		}
	}

	-- Create the widget
	local datePickerWheel = widget.newPickerWheel(
	    {
	    	top = 100,
	    	fontSize = 13,
	    	font = composer.getVariable("defaultFont"),
	        columns = columnData
	    }
	)
	datePickerWheel.x = display.contentCenterX;
	setDeadline:insert(datePickerWheel)

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------

	local function dateValidation( )

		print("here at date validatation")
		values = datePickerWheel:getValues();

		currentMonth = tonumber(values[1].value);
		currentDay = tonumber(values[2].value);
		currentYear = tonumber(values[3].value);
		currentHour = tonumber(values[4].value);
		currentMinute= tonumber(values[5].value);

		dateIsValid = true;
		timeValid = true;




		if( tonumber(currentYear) == tonumber(cY) and tonumber(currentDay) == day and tonumber(currentMonth) == mo ) then

					 if( tonumber(currentHour) == hr ) then
							 	if( tonumber(currentMinute) <= min ) then
							 			timeValid = false;	
							 							print("TIME VALID IS FALSE")

							 	end
					 elseif(tonumber(currentHour) < hr) then
					 		timeValid = false
					 						print("TIME VALID IS FALSE")

					end
		
			end
					
					
		---CHECK MONTHS
		if(currentDay > 30) then
			if(currentMonth == 4 or currentMonth == 6 or currentMonth == 9 or currentMonth == 11) then
				print("DATE IS VALID IS FALSE")
				dateIsValid = false;
			end
		end


		if(currentMonth == 2) then
			if(currentDay >= 29) then
				local mod = (tonumber(currentYear)%3);
								print("DATE IS VALID IS FALSE")

				dateIsValid = false;
				if(currentDay == 29 and (mod == 1)) then
					
					dateIsValid = true;
				end
				
			end
		end


		if( tonumber(currentYear) == tonumber(cY)) then
			if(tonumber(currentMonth) < mo) then
								print("DATE IS VALID IS FALSE")

				dateIsValid = false;
			end
			if(tonumber(currentDay) < day and tonumber(currentMonth) < mo) then
								print("DATE IS VALID IS FALSE")

				dateIsValid = false;
			end
		end


end


	local function onCom (event)
			
				-- do nothing
		end

										       dateValidation()


	local function addDeadline( event )


				        local function onComplete( event )
						    if ( event.action == "clicked" ) then
						        local i = event.index
								        if ( i == 1 ) then
								            -- Do nothing; dialog will simply dismiss
								            		local thisPrev = tostring( composer.getVariable("prevScene"))
								            			composer.setVariable("prevScene","setDeadline")

						 						    composer.gotoScene(  thisPrev ,"slideDown")


								        elseif(i == 2) then
							          	     	  

								        end
						    end
						end


										        if(dateIsValid == false) then
								local alert = native.showAlert( "Scribe", "The deadline date is invalid. Please choose today or later.", { "OK"}, onCom )

						elseif(timeValid == false) then
								local alert = native.showAlert( "Scribe", "The deadline time is invalid. Please choose an hour and minute later than this very moment.", { "OK"}, onCom )
						elseif(dateIsValid == false) then
								local alert = native.showAlert( "Scribe", "The deadline date is invalid. Please choose today or later.", { "OK"}, onCom )

						end


				    if ( "ended" == event.phase ) then
				        print( "Button  add Deadline was pressed and released" )

						  
						-- Show alert with two buttons
						oldDate = tostring( composer.getVariable("end_date") )

						composer.setVariable("end_date", tostring(currentYear.."-"..currentMonth.."-"..currentDay.." "..currentHour..":"..currentMinute..":00"))
						
						if(oldDate ~= tostring( composer.getVariable("end_date") ) ) then
						 	composer.setVariable("dateChanged","t")
						 end

						



						end



						local alert = native.showAlert( "Scribe", "Your deadline has been set.", { "OK", "Edit Deadline"}, onComplete )

				        --composer.removeScene("startUp",true)


		 end




					local addDeadline = widget.newButton(
				    {
				    	shape = "roundedRect",
				        height = 30,
				        id = "addDeadline",
				        label = "ADD DEADLINE",
				        fontSize = 13,
     			     	font = composer.getVariable("defaultFont"),
				        onEvent = addDeadline,
				        fillColor = { default={ 0.9,0,1,0.4 }, over={ 1,1,1,1 } },
				        labelColor = {  default={1,1,1,1}, over={ 0.9,0,1,0.4} },
				        strokeColor = { default={0,0,0,0}, over={0.9,0,1,0.4} },
       					strokeWidth = 1
				    }

				)

				--positioning log in buttom


				addDeadline.x = display.contentCenterX
				addDeadline.y = datePickerWheel.y + datePickerWheel.height 
				setDeadline:insert(addDeadline)

local function backListener(event)
				if ( "ended" == event.phase ) then

						    print( "Back was pressed and released" )
							local thisPrev = tostring( composer.getVariable("prevScene"))
						            			composer.setVariable("prevScene","setDeadline")

				 						    composer.gotoScene(  thisPrev ,"slideDown")
						   
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
							backbutton.y = addDeadline.y + addDeadline.height + 15
							setDeadline:insert(backbutton)


end

scene:addEventListener( "create" )

return scene
