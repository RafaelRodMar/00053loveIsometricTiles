function love.load()
    --variables
    gameWidth = 640
    gameHeight = 480
    love.window.setMode(gameWidth, gameHeight, {resizable=false, vsync=false})
    love.graphics.setBackgroundColor(1,1,1) --white

    -- Number of tiles in world
	vWorldSize = { x=14, y=10 }

	-- Size of single tile graphic
	vTileSize = { x=40, y=20 }

	-- Where to place tile (0,0) on screen (in tile size steps)
	vOrigin = { x=5, y=1 }

	-- Sprite that holds all imagery
    imagedata = love.image.newImageData('isometric_demo.png')
	sprIsom = love.graphics.newImage(imagedata)

	-- table to create 2D world array
	pWorld = {}

    -- Fill the empty table with vWorldSize.x * vWorldSize.y zeroes
    for i = 1, vWorldSize.x * vWorldSize.y do
        pWorld[i] = 0
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
    vCell = { x = vMouse.x / vTileSize.x, y = vMouse.y / vTileSize.y }

    -- Work out mouse offset into cell
    vOffset = { x = vMouse.x % vTileSize.x, y = vMouse.y % vTileSize.y }

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
            (vOrigin.x * vTileSize.x) + (x - y) * (vTileSize.x / 2),
            (vOrigin.y * vTileSize.y) + (x + y) * (vTileSize.y / 2)
        }
    end

    mouseClicked = false
end

function love.draw()
    love.graphics.setBackgroundColor(1,1,1)
    love.graphics.setColor(1,1,1)
end
