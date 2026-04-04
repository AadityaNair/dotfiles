This is the collection of all the dotfiles I use in my setup.

Anything I have stopped using is moved to the archive folder. We do not delete it.
This implies to distinct services only. If we delete a config in vim/fish we don't move it.
We rely on git history to get it back.
For any changes requested, fully ignore the archive folder unless specifically requested.

We also try to maintain a uniform colourscheme for all the services involved. Whenever we 
update the colourscheme, these services need to be updated as well. Also update this list
wherever a new service is added or deleted.
The services we care about are:
* Neovim
* Neovim Lualine plugin
* Fish Shell
* Tmux 
* Ghostty
* Atuin History UI

We also have versions.json where we track the versions of various important software we use.
This should help you inform decisions on what is available or not. If there are discrepencies between
reality and that file, inform the user.

There are going to be a bunch of TODOs scattered around. Always investigate those when you can.

When creating changes, the commits for those changes should be small and focused. No merging multiple distinct
changes into the same commit. Prefix the commit message with "[<application we are working with>]"
For changes to shell_applications, prefix with "[shell_applications][<application>]". 
Everything else should be prefixed with "[meta]". Refer to `git log` for examples.

For major services (currently for fish and neovim), I generally have a separate file that is not committed.
This is where the work stuff goes. It is very important to make sure that work related config never pollute
the rest of the config.
For neovim and fish, we have use a plugin based approach to enable this. I can just drop the company file with
rest of the config and it just works. For big changes or adding new major services, this needs to be remembered.
