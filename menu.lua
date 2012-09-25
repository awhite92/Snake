
menu = {}
menu.items = {}

itemBG = {0,0,0,50}
itemFG = {0,0,0}
selectedItemBG = {0,0,0,200}
selectedItemFG = {255,255,255,200}

gfx = love.graphics
menu.selected = 1

selectedY = 0
direction = "down"

	function menu.load(x, y, width, height, padding, spacing, align)
		menu.width = width 
		menu.height = height 
		menu.x = x 
		menu.y = y 
		menu.padding = padding
		menu.spacing = spacing
		menu.align = align
		selectedY = y
	end
	
	function menu.setItemColors(ItemBG, ItemFG)
		itemBG = ItemBG
		itemFG = ItemFG
	end
	
	function menu.setSelectedColors(ItemBG, ItemFG)
		selectedItemBG = ItemBG
		selectedItemFG = ItemFG
	end
	
	function menu.addItem(text)
		table.insert(menu.items,{text = text})
	end
	
	function menu.update(dt)
		if direction == "up" then
			if selectedY > menu.y + menu.height*(menu.selected-1) then
				selectedY = selectedY - dt*350
			else
				selectedY = menu.y + menu.height*(menu.selected-1)
			end
		elseif direction == "down" then
			if selectedY < menu.y + menu.height*(menu.selected-1) then
				selectedY = selectedY + dt*350
			else
				selectedY = menu.y + menu.height*(menu.selected-1)
			end
		end
		
	end
	
	function menu.draw()
	
		
		
		gfx.setColor(0,0,0,50) 
		gfx.rectangle("fill",menu.x ,  selectedY  + (menu.spacing*(menu.selected-1)) , menu.width, menu.height)
		gfx.setColor(selectedItemBG) 
		gfx.rectangle("fill",menu.x-5,  selectedY + (menu.spacing*(menu.selected-1))-5, menu.width, menu.height)
		
		
		for i,v in ipairs(menu.items) do
			
			if i == menu.selected then 
			else
				gfx.setColor(itemBG)
				gfx.rectangle("fill",menu.x, menu.y + (menu.height*(i-1)) + (menu.spacing*(i-1)), menu.width, menu.height)
			end
		
			gfx.setColor(0,0,0,100) 
			if i == menu.selected then gfx.setColor(0,0,0,0) end
			gfx.printf(v.text, menu.x + menu.padding+2, menu.y + (menu.height*(i-1)) + (menu.spacing*(i-1)) + menu.padding +2, menu.width - menu.padding*2, menu.align)
			
			gfx.setColor(itemFG)
			if i == menu.selected then gfx.setColor(0,0,0,50) end
			gfx.printf(v.text, menu.x + menu.padding, menu.y + (menu.height*(i-1)) + (menu.spacing*(i-1)) + menu.padding , menu.width - menu.padding*2, menu.align)
			
			if i == menu.selected then 
				gfx.setColor(selectedItemFG) 
				gfx.printf(v.text, menu.x + menu.padding-5, menu.y + (menu.height*(i-1)) + (menu.spacing*(i-1)) + menu.padding -5, menu.width - menu.padding*2, menu.align)
			end
		end
	end
	
	function menu.up()
		s = menu.selected
		if s == 1 then
			menu.selected = #menu.items
			direction = "down"
		else
			menu.selected = s - 1
			direction = "up"
		end
	end
	
	function menu.down()
		s = menu.selected
		if s == #menu.items then
			menu.selected = 1
			direction = "up"
		else
			menu.selected = s + 1
			direction = "down"
		end
	end