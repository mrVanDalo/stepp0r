--- ======================================================================================================
---
---                                                 [ Logging Layer ]

function log(key, value)
    if value then
        print(key .. " : " .. value)
    else
        print(key .. " : nil")
    end
end

function add_notifier(observable, handler)
    observable:add_notifier(handler)
end

function remove_notifier(observable, handler)
    if observable:has_notifier(handler) then
        print("removed notifier")
        print(handler)
        observable:remove_notifier(handler)
    else
        print("no notifier found")
        print(handler)
    end
end

function create_bank()
    return {
        bank = {},
        min  = 1,
        max  = 1,
        mode = BankData.mode.copy
    }
end
