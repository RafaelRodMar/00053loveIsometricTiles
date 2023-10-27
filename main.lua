function love.load()
    --variables
    gameWidth = 640
    gameHeight = 480
    love.window.setMode(gameWidth, gameHeight, {resizable=false, vsync=false})
    love.graphics.setBackgroundColor(1,1,1) --white

    --load font
    font = love.graphics.newFont("sansation.ttf",25)
    love.graphics.setFont(font)

    -- Number of tiles in world
	vWorldSize = { x=14, y=10 }

	-- Size of single tile graphic
	vTileSize = { x=40, y=20 }

	-- Where to place tile (0,0) on screen (in tile size steps)
	vOrigin = { x=5, y=1 }

	-- Sprite that holds all imagery
    imagedata = love.image.newImageData('isometric_demo.png')
	sprIsom = love.graphics.newImage(imagedata)
    textureWidth = imagedata:getWidth()
    textureHeight = imagedata:getHeight()

	-- table to create 2D world array
	pWorld = {}

    -- Fill the empty table with vWorldSize.x * vWorldSize.y zeroes
    for i = 1, vWorldSize.x * vWorldSize.y do
        pWorld[i] = 1
    end

    -- mouse
    mouseClicked = false
    vMouse = {x=0, y=0}
end

function love.keypressed(key)
end

function love.keyreleased(key)
end

function love.mousemoved( x, y, dx, dy, istouch )
    vMouse.x = x
    vMouse.y = y
end

function love.mousepressed(x,y,button, istouch)
	if button == 1 then
		mouseClicked = true
	end
end

function love.update(dt)
    
    -- Work out active cell
    vCell = { x = math.floor(vMouse.x / vTileSize.x), y = math.floor(vMouse.y / vTileSize.y) }

    -- Work out mouse offset into cell
    vOffset = { x = math.floor(vMouse.x % vTileSize.x), y = math.floor(vMouse.y % vTileSize.y) }

    -- Sample into cell offset colour
    colr, colg, colb = imagedata:getPixel(3 * vTileSize.x + vOffset.x, vOffset.y)

    -- Work out selected cell by transforming screen cell
    vSelected = 
    {
        x = (vCell.y - vOrigin.y) + (vCell.x - vOrigin.x),
        y = (vCell.y - vOrigin.y) - (vCell.x - vOrigin.x) 
    }

    -- "Bodge" selected cell by sampling corners
    if colr == 1 and colg == 0 and colb == 0 then
        vSelected.x = vSelected.x - 1
        vSelected.y = vSelected.y + 0
    end
    if colr == 0 and colg == 0 and colb == 1 then
        vSelected.x = vSelected.x + 0
        vSelected.y = vSelected.y - 1
    end
    if colr == 0 and colg == 1 and colb == 0 then
        vSelected.x = vSelected.x + 0
        vSelected.y = vSelected.y + 1
    end
    if colr == 1 and colg == 1 and colb == 0 then
        vSelected.x = vSelected.x + 1
        vSelected.y = vSelected.y + 0
    end

    -- Handle mouse click to toggle if a tile is visible or not
    if mouseClicked == true then
        -- Guard array boundary
        if vSelected.x >= 0 and vSelected.x < vWorldSize.x and vSelected.y >= 0 and vSelected.y < vWorldSize.y then
            local index = vSelected.y * vWorldSize.x + vSelected.x
            index = math.floor(index)
            pWorld[index] = (pWorld[index] + 1) % 6
        end
    end
                    
    -- Function to convert "world" coordinate into screen space
    function ToScreen(x, y)
        return {
            math.floor((vOrigin.x * vTileSize.x) + (x - y) * (vTileSize.x / 2)),
            math.floor((vOrigin.y * vTileSize.y) + (x + y) * (vTileSize.y / 2))
        }
    end

    mouseClicked = false
end

function love.draw()
    love.graphics.setBackgroundColor(1,1,1)
    love.graphics.setColor(1,1,1)

    -- Draw World

    -- (0,0) is at top, defined by vOrigin, so draw from top to bottom
    -- to ensure tiles closest to camera are drawn last
    for y = 1, vWorldSize.y do
        for x = 1, vWorldSize.x do
            -- Convert cell coordinate to world space
            print(x..","..y)
            vWorld = ToScreen(x, y)
            
            local tileValue = pWorld[y * vWorldSize.x + x]

            if tileValue == 0 then
                -- Invisible Tile
                -- quad : where it starts into the texture, the x and y size of the quad, and the width and height of the texture.
                quad = love.graphics.newQuad(1*vTileSize.x,0, vTileSize.x, vTileSize.y, textureWidth, textureHeight)
                love.graphics.draw(sprIsom,quad, vWorld.x, vWorld.y)
            elseif tileValue == 1 then
                -- Visible Tile
                quad = love.graphics.newQuad(2*vTileSize.x, 0, vTileSize.x, vTileSize.y, textureWidth, textureHeight)
                love.graphics.draw(sprIsom, quad, vWorld.x, vWorld.y)
            elseif tileValue == 2 then
                -- Tree
                quad = love.graphics.newQuad(0 * vTileSize.x, 1 * vTileSize.y, vTileSize.x, vTileSize.y * 2, textureWidth, textureHeight)
                love.graphics.draw(sprIsom, quad, vWorld.x, vWorld.y - vTileSize.y)
            elseif tileValue == 3 then
                -- Spooky Tree
                quad = love.graphics.newQuad(1 * vTileSize.x, 1 * vTileSize.y, vTileSize.x, vTileSize.y * 2, textureWidth, textureHeight)
                love.graphics.draw(sprIsom, quad, vWorld.x, vWorld.y - vTileSize.y)
            elseif tileValue == 4 then
                -- Beach
                quad = love.graphics.newQuad(2 * vTileSize.x, 1 * vTileSize.y, vTileSize.x, vTileSize.y * 2, textureWidth, textureHeight)
                love.graphics.draw(sprIsom, quad, vWorld.x, vWorld.y - vTileSize.y)
            elseif tileValue == 5 then
                -- Water
                quad = love.graphics.newQuad(3 * vTileSize.x, 1 * vTileSize.y, vTileSize.x, vTileSize.y * 2, textureWidth, textureHeight)
                love.graphics.draw(sprIsom, quad, vWorld.x, vWorld.y - vTileSize.y)
            end
        end
    end

    -- Draw Selected Cell
    -- Convert selected cell coordinate to world space
    vSelectedWorld = ToScreen(vSelected.x, vSelected.y)

    -- Draw "highlight" tile
    quad = love.graphics.newQuad(0 * vTileSize.x, 0, vTileSize.x, vTileSize.y, textureWidth, textureHeight)
    love.graphics.draw(sprIsom, quad, vSelectedWorld.x, vSelectedWorld.y)

    -- Draw Hovered Cell Boundary
    --DrawRect(vCell.x * vTileSize.x, vCell.y * vTileSize.y, vTileSize.x, vTileSize.y, olc::RED);
            
    -- Draw Debug Info
    --draw UI
    love.graphics.setColor(1,0,0)
    love.graphics.print("Mouse: " .. vMouse.x .. "," .. vMouse.y, 4, 4)
    love.graphics.print("Cell: " .. vCell.x .. "," .. vCell.y, 4, 24)
    love.graphics.print("Selected: " .. vSelected.x .. "," .. vSelected.y, 4, 44)
end
