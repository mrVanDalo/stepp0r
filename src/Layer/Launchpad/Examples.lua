--- ======================================================================================================
---
---                                                 [ Examples ]

--- example handler
--
function echo_top(_,msg)
    local x   = msg.x
    local vel = msg.vel
    --print(top)
--    print(("top    : (%X) = %X"):format(x,vel))
end
function echo_right(_,msg)
    local x   = msg.x
    local vel = msg.vel
    --print(right)
--    print(("right  : (%X) = %X"):format(x,vel))
end
function echo_matrix(_,msg)
    local x   = msg.x
    local y   = msg.y
    local vel = msg.vel
    --print(matrix)
--    print(("matrix : (%X,%X) = %X"):format(x,y,vel))
end


--- example functions
--
function example_matrix(pad)
    for y=0,7,1 do
        for x=0,7,1 do
            pad:set_matrix(x,y,x+(y*8))
        end
    end
end
function example_colors(pad)
    -- send
    -- configuration
    pad:set_flash()

    pad:set_matrix(i,1,Color.red)
    pad:set_matrix(1,1,Color.yellow)
    pad:set_matrix(2,1,Color.green)
    pad:set_matrix(3,1,Color.orange)

    pad:set_matrix(4,2,Color.flash.red)
    pad:set_matrix(1,2,Color.flash.yellow)
    pad:set_matrix(2,2,Color.flash.green)
    pad:set_matrix(3,2,Color.flash.orange)

    pad:set_matrix(3,3,Color.full.red)
    pad:set_matrix(1,3,Color.full.yellow)
    pad:set_matrix(2,3,Color.full.green)

    pad:set_matrix(3,4,Color.dim.red)
    pad:set_matrix(1,4,Color.dim.yellow)
    pad:set_matrix(2,4,Color.dim.green)

    pad:set_top(1,Color.yellow)
    pad:set_top(2,Color.green)
    pad:set_top(3,Color.orange)
    pad:set_top(4,Color.flash.red)
    pad:set_top(5,Color.flash.yellow)
    pad:set_top(6,Color.flash.green)
    pad:set_top(7,Color.flash.orange)
    pad:set_top(8,Color.red)

    pad:set_side(8,Color.red)
    pad:set_side(1,Color.yellow)
    pad:set_side(2,Color.green)
    pad:set_side(3,Color.orange)
    pad:set_side(4,Color.flash.red)
    pad:set_side(5,Color.flash.yellow)
    pad:set_side(6,Color.flash.green)
    pad:set_side(7,Color.flash.orange)

    -- callbacks
    pad:unregister_all()

    pad:register_matrix_listener(echo_matrix)
    pad:register_top_listener(echo_top)
    pad:register_right_listener(echo_right)
end
function example(pad)
    -- configuration
    example_colors(pad)
end



