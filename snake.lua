

snake = {}
snake.direction = "w"
quryDir = nil
snake.speed = 1
snake.fadeAlpha = 255
snake.body = {}
snake.x = -1
snake.y = 0

food = {}
food.itemx = 0
food.itemy = 0
food.angle = 0
food.alphaDirection = "out"
food.fade = true
food.image = gfx.newImage("res/food.png")

food.count = 0
multiplyer = 1

snake.mv = -5

	-- SNAKE --
	
	function snake.setup()
		
		-- reset the table to nil
		for k in pairs (snake.body) do
			snake.body [k] = nil
		end
		
		-- add the default length of 4
		for i = 1, 5, 1 do table.insert(snake.body, {x = 16 +i, y = 13}) end
		
		snake.direction = "w"
		snake.speed = 1
		snake.x = -1
		snake.y = 0
		snake.mv = -5
		multiplyer = 1
		food.count = 0
		quryDir = nil
		
		food.move()
	end
	
	function snake.draw()
		snake.fadeAlpha = 255
		-- simply draw all the snakes body
		for i,v in pairs(snake.body) do
			snake.fadeAlpha = (((#snake.body - i) * 150) / #snake.body) + 105
			drawBlock(v.x, v.y, {255,255,255,snake.fadeAlpha})
		end

	end
	
	function snake.move(dt)
		
		snake.mv = snake.mv + (snake.speed + 7) * dt
		
		if snake.mv >= 1 then
			
			if quryDir ~= nil then
				
				if quryDir == "n" then
				
					snake.x = 0
					snake.y = -1
					snake.direction = "n"
					
				elseif quryDir == "s" then
					
					snake.x = 0
					snake.y = 1
					snake.direction = "s"
					
				elseif quryDir == "w" then
					
					snake.x = -1
					snake.y = 0
					snake.direction = "w"
					
				elseif quryDir == "e" then
					
					snake.x = 1
					snake.y = 0
					snake.direction = "e"
					
				end
				
				quryDir = nil
			end
			
			
			snake.mv = 0
			
			newx = snake.body[1].x + snake.x
			newy = snake.body[1].y + snake.y
			
			
			if not checkColide(newx, newy) then
				
				
				lastX = snake.body[#snake.body].x
				lastY = snake.body[#snake.body].y
				
				
				-- move all parts to the one before it
				for i = #snake.body, 2, -1 do
					snake.body[i].x = snake.body[i-1].x
					snake.body[i].y = snake.body[i-1].y
				end
				
				if snake.add then
					snake.add = false
					table.insert(snake.body, {x = lastX, y = lastY})
				end
				
				
				-- move the head to the new point
				-- lets you move through walls :D ok, now the game is too easy
				if newx < 0 then newx = totalBlocksX end
				if newx > totalBlocksX then newx = 0 end
				-- and this is for the y postion, obviously
				if newy < 0 then newy = totalBlocksY end
				if newy > totalBlocksY then newy = 0 end
				
				-- aaannnddddd update it :D
				snake.body[1].x = newx
				snake.body[1].y = newy
				
				
				
				-- mmm, i wonder what it taste like? ;)
				if snake.body[1].x == food.itemx and snake.body[1].y == food.itemy then -- OMM NOM NOM
					food.move()
					love.audio.play(selectOGG)
					snake.add = true
					score = score + 1 * multiplyer
					food.angle = 0
					food.count = food.count + 1
					
					if food.count == 10 then -- lvl up :D
					
						food.count = 0
						snake.speed = snake.speed + 1 -- faster, faster!!
						multiplyer = multiplyer + 1 -- more score
						
						if bgColorIndex == #bgColors then -- change the bg color each lvl
						
							bgColorIndex = 1
							snake.speed = snake.speed - 4
							
						else bgColorIndex = bgColorIndex + 1 end
						
						fadeBgColor(bgColors[bgColorIndex])
						
						showLvlPop = 1.1
						lvlPopYD = 150
						lvlPopY = 200
						lvlPopA = 0
						lvlPopAD = 255
					end
				end
			else -- hits something bad :(
			
				state = "gameover"
				love.audio.play(hitOGG)
			
			end
		end
		
	end
	
	function snake.changeDir(d)
		quryDir = d
	end
	
	function snake.grow()
		-- obsolite, maybe
	end
	
	-- FOOD --
	
	function food.draw()
		gfx.setColor(200,200,200)
		-- simply draw all the food
		love.graphics.setBlendMode("additive")
		gfx.draw(block_glow, blockSize * food.itemx + (blockSpacing * food.itemx) + block_glow:getWidth() / 2 - 13, blockSize * food.itemy + (blockSpacing * food.itemy) + block_glow:getWidth() / 2 - 13, food.angle,1, 1, block_glow:getWidth() / 2, block_glow:getWidth() / 2)
		love.graphics.setBlendMode("alpha")
		
		gfx.setColor(255,255,255)
		gfx.draw(food.image, blockSize * food.itemx + (blockSpacing * food.itemx) + blockSize / 2, blockSize * food.itemy + (blockSpacing * food.itemy) + blockSize / 2, food.angle,1, 1, blockSize / 2, blockSize / 2)
		
		
	end
	
	-- checks the coridinats againsts the snake, food, outside bounds, and map(later). -- nevermind, no map :( i decided it was going to be forever a unlimited game
	function checkColide(x, y)
		-- returns true if it is, well, true lol
		rtv = false
		
		for i,v in pairs(snake.body) do
			if v.x == x and v.y == y and i ~= #snake.body then 
				rtv = true 
			end
		end
		
		if x < 0 or y < 0 or x > totalBlocksX or y > totalBlocksY then
			--rtv = true
		end
		
		return rtv
	end
	
	function food.move()
		nx = math.random(0,totalBlocksX)
		ny = math.random(0,totalBlocksY)
		
		while checkColide(nx,ny) do			
			nx = math.random(0,totalBlocksX)
			ny = math.random(0,totalBlocksY)
		end
		
		food.itemx = nx
		food.itemy = ny
	end
	
	function food.update(dt)
	
		-- rotating the food
		food.angle = food.angle + 0.5 * dt
		
	end
	
	
	
	
	
	
	
	
	
	
	
	
	
	