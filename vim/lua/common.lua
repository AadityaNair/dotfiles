local module = {}

function module.TableConcat(t1, t2)
    for _, v in ipairs(t2) do
        require("table").insert(t1, v)
    end
    return t1
end

return module
