--- ======================================================================================================
---
---                                                 [ Logging Layer ]

function log(key, value)
    print(string.format("%s : %s", key,value))
end

function add_notifer(observable, handler)
    observable:add_notifier(handler)
end

function remove_notifier(observable, handler)
    if observable:has_notfier(handler) then
        log("removed notifier", handler)
        observable:remove_notifier(handler)
    else
        log("no notifier found", handler)
    end
end

