local module = {}

function module.gh_url(repo)
    return string.format("https://github.com/%s.git", repo)
end

return module
