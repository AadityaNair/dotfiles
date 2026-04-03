local module = {}

function module.TableConcat(t1, t2)
    for _, v in ipairs(t2) do
        require("table").insert(t1, v)
    end
    return t1
end

function module.gh_url(repo)
    return string.format("https://github.com/%s.git", repo)
end

return module
