
require "menu"
require "snake"


gfx = love.graphics -- cuz shortcuts are awesome.

debug = false -- show the debug information and allow cirtin keypresses

state = "splash" -- the gamestate to display to the player/user

logoY = 0 -- the opacity
logoDirection = 1 -- 1 = positive OR down; -1 = negative OR up
logoYFinal = 255 -- the final opacity state to "fade" to
logoA = logoY -- i dont remember, lol jk its for, um, renaming purpouses, because it was a sliding effect, but now its a fading alpha. and im lazy

fadeColorAlpha = 0 -- the current Alpha Channel for the fadeColor
fadeColor = {0,0,0} -- color to fade into
fadingColor = true -- wether your fading or not
fadeTime = 1 -- fade durration in secconds, 1.5 or so

bgColors = {{0,0,0},{205,37,144},{37,183,205},{78,191,43},{0xff, 0x66, 0x00}} -- list of possible colors for the bord! :D
bgColorIndex = 1 -- currently selected color from the list
bgColorDelay = 10 -- delay between Auto Changing background
bgColorINT = 0	-- its current state in the auto change
autoBackground = false -- wether to auto change or not every so many secconds
pauseAutoBg = false

WinWidth = gfx.getWidth() -- less calls makes more sence to me
WinHeight = gfx.getHeight() -- ^^ what he said ^^

blockSize = 20
blockSpacing = 1
totalBlocksX = 37
totalBlocksY = 27

lvlPopY = 200 -- y position of lvl up popup
lvlPopYD = 150 -- new y position to slide to
lvlPopA = 255 -- alpha of pupop
lvlPopAD = 255 -- new alpha to fade to
showLvlPop = 0 -- state, 0 = none, 1 = in, 2 = out, 3 = back to 0

score = 0 -- wow, your really bad at this game, ya know?

	function love.load()

		-- load images
		main_bg = gfx.newImage("res/s_bord_bg.png")
		main_logo = gfx.newImage("res/s_logo2.png")
		block_glow = gfx.newImage("res/block_glow.png")
		game_over = gfx.newImage("res/gameover.png") -- need to fix this image :/ -- fixed :D

		-- load fonts
		menuFont = gfx.newFont("res/font.ttf", 20)
		lvlFont = gfx.newFont("res/font.ttf", 40)
		defaultFont = gfx.newFont(12)

		-- load sounds
		startOGG = love.audio.newSource("res/start.ogg", "stream") -- way
		selectOGG = love.audio.newSource("res/select2.ogg", "stream") -- to
		nextOGG = love.audio.newSource("res/next2.ogg", "stream") -- many
		hitOGG = love.audio.newSource("res/BlipHit1.ogg", "stream") -- sounds
		collectOGG = love.audio.newSource("res/BlipCollect2.ogg", "stream") -- to
		pauseOGG = love.audio.newSource("res/pause.ogg", "stream") -- load
		unPauseOGG = love.audio.newSource("res/unPause.ogg", "stream") -- !!
		startOGG:setVolume(0.6) -- they were too loud!
		selectOGG:setVolume(0.6) -- and i was to lazy
		nextOGG:setVolume(0.6) -- to remake them..

		-- setup settings
		love.mouse.setVisible(false) -- now you cant see me!! :D
		gfx.setBackgroundColor(0,0,0) -- actually pointless :P
		logoY = -70
		logoYFinal = 255

		-- setup the menu and items
		menu.load(WinWidth/2-100, WinHeight/2+50.5, 200, 33, 8, 10, "left")
		menu.addItem("New Game")
		--menu.addItem("Options")
		menu.addItem("Quit")

		menu.setItemColors({0,0,0,0},{255,255,255,255})
		menu.setSelectedColors({0,0,0,125},{255,255,255})

		love.audio.play(startOGG)
		
		fadeBgColor(bgColors[math.random(#bgColors)])
	end

	function love.update(dt)

		-- fade the logo
		if logoY * logoDirection < logoYFinal * logoDirection then
			logoY = logoY + 500 * dt * logoDirection
		else
			logoY = logoYFinal
		end

		if logoY < 0 then logoA = 0 else logoA = logoY end


		-- background color set fading
		if fadingColor then
			if fadeColorAlpha == 255 then
				gfx.setBackgroundColor(fadeColor)
				fadeColorAlpha = 0
				fadingColor = false

			else
				fadeColorAlpha = fadeColorAlpha + (255 / fadeTime) * dt
				if fadeColorAlpha > 255 then fadeColorAlpha = 255 end
			end
			fadeColor = {fadeColor[1],fadeColor[2],fadeColor[3],fadeColorAlpha}
		end
		
		-- auto switch background
		if autoBackground and not pauseAutoBg then
			if bgColorINT > bgColorDelay then
				bgColorINT = 0
				if bgColorIndex == #bgColors then
					bgColorIndex = 1
				else
					bgColorIndex = bgColorIndex + 1
				end
				fadeBgColor(bgColors[bgColorIndex])
			else
				bgColorINT = bgColorINT + 1 * dt
			end
		end
		
		
		if state == "splash" or state =="gameover" then

			-- do splashy stuff, yeaaa
			menu.update(dt)

		elseif state == "game"  then

			-- do epic game stuff
			snake.move(dt)
			food.update(dt)
			
			-- way more than i thought to make the neet lvl up popup :( oh well
			if showLvlPop > 1 and showLvlPop <= 2 then
				
				showLvlPop = showLvlPop + 1 * dt
				
				-- move popup up
				if lvlPopY ~= lvlPopYD then
					lvlPopY = lvlPopY - 150 * dt
					if lvlPopY < lvlPopYD then lvlPopY = lvlPopYD end
				end
				
				-- fade popup
				if lvlPopA ~= lvlPopAD then
					lvlPopA = lvlPopA + 550 * dt
					if lvlPopA > lvlPopAD then lvlPopA = lvlPopAD end
				end
				
			elseif showLvlPop >= 2 and showLvlPop < 3 then
				
				
				lvlPopYD = 0
				lvlPopY = 150
				lvlPopA = 255
				lvlPopAD = 0
				showLvlPop = 3
				
				
			elseif showLvlPop >= 3 and showLvlPop < 4 then
			
				showLvlPop = showLvlPop + .1 * dt
			
				-- move popup up
				if lvlPopY ~= lvlPopYD then
					lvlPopY = lvlPopY - 150 * dt
					if lvlPopY < lvlPopYD then lvlPopY = lvlPopYD end
				end
				
				-- fade popup
				if lvlPopA ~= lvlPopAD then
					lvlPopA = lvlPopA - 550 * dt
					if lvlPopA < lvlPopAD then lvlPopA = lvlPopAD end
				end
				
			elseif showLvlPop >= 4 then
				showLvlPop = 0
			end

		elseif state == "paused" then

			--do paused stuff, lame..

		elseif state == "gameover" then
		
			-- aw man! you lost :(
		
		end

	end
	

	function fadeBgColor(color)
		fadeColor = color
		fadeColorAlpha = 0
		fadingColor = true
	end
	
	function gameStart()
		
		bgColorINT = 0
		logoYFinal = 0
		logoDirection = -1
		state = "game"
		score = 0

		bgColorIndex = 1
		fadeBgColor({0,0,0})
		
		snake.setup()
	end
	
	function drawScore()
	
		if state == "gameover" then
			--score
			gfx.setFont(lvlFont)
			gfx.setColor(0,0,0,100)
			gfx.printf("Score: " ..tostring(score * 25) .. " - Level: " ..tostring(multiplyer), 10, 256, WinWidth-20, "center")
			gfx.setColor(255,255,255)
			gfx.printf("Score: " ..tostring(score * 25) .. " - Level: " ..tostring(multiplyer), 8, 254, WinWidth-19, "center")
			
		else
			-- score
			gfx.setFont(menuFont)
			gfx.setColor(0,0,0,100)
			gfx.printf("Score: " ..tostring(score * 25), 10, 6, WinWidth-20, "left")
			gfx.setColor(255,255,255)
			gfx.printf("Score: " ..tostring(score * 25), 8, 4, WinWidth-16, "left")
			
			-- lvl
			gfx.setColor(0,0,0,100)
			gfx.printf("Level: " ..tostring(multiplyer), 10, 6, WinWidth-18, "right")
			gfx.setColor(255,255,255)
			gfx.printf("Level: " ..tostring(multiplyer), 8, 4, WinWidth-18, "right")
		end
		
		
		
		-- draw lvl popup
		if showLvlPop > 0 then
			gfx.setFont(lvlFont)
			a1 = 0
			if lvlPopA - 155 > 0 then a1 = lvlPopA - 155 end
			gfx.setColor(0,0,0, a1)
			gfx.printf("Level Up!", 1, lvlPopY + 1, WinWidth+1, "center")
			gfx.setColor(255,255,255,lvlPopA)
			gfx.printf("Level Up!", -1, lvlPopY - 1, WinWidth-1, "center")
		end

	end
	
	function drawBlock(x, y, color)
		
		gfx.setColor(color[4],color[4],color[4]) -- make the glow color a grey scale of the alpha that is already incermented
		
		love.graphics.setBlendMode("additive")
		gfx.draw(block_glow, blockSize * x + (blockSpacing * x) + block_glow:getWidth() / 2 - 13, blockSize * y + (blockSpacing * y) + block_glow:getWidth() / 2 - 13, 0,1, 1, block_glow:getWidth() / 2, block_glow:getWidth() / 2)
		love.graphics.setBlendMode("alpha")
		gfx.setColor(color)
		gfx.rectangle("fill", blockSize * x + (blockSpacing * x), blockSize * y+ (blockSpacing * y), blockSize, blockSize)
		
    
	end

	function love.draw()
		
		
		if fadeColorAlpha > 5 and fadingColor then
			gfx.setColor(fadeColor)
			gfx.rectangle("fill",0,0,WinWidth,WinHeight)
		end

		-- draw bord overlay
		
		gfx.setColor(255,255,255)
		gfx.draw(main_bg,0,0)
		

		if state == "splash" then

			gfx.setFont(menuFont)
			menu.draw()

		elseif state == "game" then

			-- draw playing related stuff
			snake.draw()
			food.draw()
			drawScore()

		elseif state == "paused" then

			--draw the snake under
			snake.draw()
			food.draw()
			drawScore()
			
			-- draw paused background
			gfx.setColor(0,0,0,100)
			gfx.rectangle("fill",0,0,WinWidth,WinHeight)
			
			-- draw the paused text
			gfx.setFont(lvlFont)
			gfx.setColor(0,0,0,100)
			gfx.printf("Game Paused", 1, WinHeight/2-8, WinWidth, "center")
			gfx.setColor(255,255,255)
			gfx.printf("Game Paused", -1, WinHeight/2-10, WinWidth, "center")

		elseif state == "gameover" then
			
			
			snake.draw()
			gfx.setColor(0,0,0,100)
			gfx.rectangle("fill",0,0,WinWidth,WinHeight)
			drawScore()
			gfx.setColor(255,255,255)
			gfx.draw(game_over, WinWidth/2 - game_over:getWidth()/2,  200)
			
			gfx.setFont(menuFont)
			menu.draw()
		end
		
		-- draw logo
		gfx.setColor(255,255,255,logoA)
		gfx.draw(main_logo, WinWidth/2-main_logo:getWidth()/2 +.5, 188,0)


		if debug then
			gfx.setFont(defaultFont)
			gfx.setColor(0,0,0,100)
			gfx.rectangle("fill",0,WinHeight-40,WinWidth,40)
			gfx.setColor(255,255,255)
			-- left aligned
			gfx.print("FPS: "..tostring(love.timer.getFPS()), 10, WinHeight-20)
			gfx.print("Game State: "..state, 10, WinHeight-35)
		end

	end

	function love.keypressed(key)
		if key == "`" then
			debug = not debug
			love.mouse.setVisible(debug)
		end

		-- toggle pause menue only if playing or paused
		if state == "game" then
		
			if key == "pause" or key == "p" then
				state = "paused"
				pauseAutoBg = true
				love.audio.play(pauseOGG)
				love.mouse.setVisible(true)
			end
			
			if key == "up" and snake.direction ~= "s" then
				
				snake.changeDir("n")
				
			elseif key == "down" and snake.direction ~= "n" then
				
				snake.changeDir("s")
				
			elseif key == "left" and snake.direction ~= "e" then
				
				snake.changeDir("w")
				
			elseif key == "right" and snake.direction ~= "w" then
				
				snake.changeDir("e")
				
			end
			
			
		elseif state =="splash" or state =="gameover" then
		
			if key == "up" then
				menu.up()
				love.audio.play(nextOGG)
			elseif key == "down" then
				menu.down()
				love.audio.play(nextOGG)
			elseif key == "return" then

				love.audio.play(selectOGG)
				love.timer.sleep(.2)
				
				if menu.selected == 1 then
				
					gameStart()
					
				elseif menu.selected == 2 then

					love.event.quit()
				
				elseif menu.selected == 3 then
				
					
				end
			end
			
		elseif state == "paused" then
			if key == "pause" or key == "p" then
				state = "game"
				pauseAutoBg = false
				love.audio.play(unPauseOGG)
				love.mouse.setVisible(false)
			end
		end

		-- temp for testing
		if debug then
			if key == "1" then
				fadeBgColor(bgColors[1])
			elseif key == "2" then
				fadeBgColor(bgColors[2])
			elseif key == "3" then
				fadeBgColor(bgColors[3])
			elseif key == "4" then
				fadeBgColor(bgColors[4])
			elseif key == "5" then
				fadeBgColor(bgColors[5])
			end
		end
	end




