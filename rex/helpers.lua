-- rex/helpers.lua -- shared helpers. No Rex API calls at load time.
-- Required by init.lua before client_settings/keybindings so they can use it.
-- (Docs: Config > Execution Model -- load-time only defines things;
--  API calls need a client, so they live inside functions called later.)

local M = {}

-- Applies a list of client settings: { { action = "client.setting.…", args = { … } }, … }.
-- Must run inside an action's run() (or another client context), because
-- rex.client.queue needs the client that ran the action. Raises on the first
-- failure (unknown action, no client), so a half-applied list is loud.
function M.apply_client_settings(settings)
    for _, s in ipairs(settings) do
        rex.client.queue(s.action, s.args)
    end
end

return M
