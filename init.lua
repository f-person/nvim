print("welcome to brave new wwworld 🛸")


-- MARK: core
require "core.globals".set_vim_globals()

require "core.options".set_vim_configuration_options()

require "core.lazy".setup_lazy_package_manager()

require "core.lsp".setup_language_servers()


-- MARK: keymap
require "keymap.telescope".set_keybindings()
require "keymap.editing".set_keybindings()


-- MARK: behavior
require "behavior.highlight_yank".setup()
require "behavior.telescope_show_line_numbers".setup()
