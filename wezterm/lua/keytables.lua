local wezterm = require 'wezterm'
local module = {}
function module.apply_config(config)

    config.key_tables = {
        launch_servers = {{
            key = "1",
            action = wezterm.action.Multiple {wezterm.action.SpawnCommandInNewTab {
                args = {"ssh", "admin@nixos-development-tests"}
            }, wezterm.action.EmitEvent("set-tab-title", "nixos-development-tests")}
        }, {
            key = "2",
            action = wezterm.action {
                SpawnCommandInNewTab = {
                    args = {"ssh", "admin@kubernetes-home-server-management"}
                }
            }
        }, {
            key = "3",
            action = wezterm.action {
                SpawnCommandInNewTab = {
                    args = {"ssh", "admin@kubernetes-home-server-node-1"}
                }
            }
        }, {
            key = "4",
            action = wezterm.action {
                SpawnCommandInNewTab = {
                    args = {"ssh", "admin@kubernetes-home-server-node-2"}
                }
            }
        }, {
            key = "5",
            action = wezterm.action {
                SpawnCommandInNewTab = {
                    args = {"ssh", "admin@kubernetes-home-server-node-3"}
                }
            }
        }, {
            key = "6",
            action = wezterm.action {
                SpawnCommandInNewTab = {
                    args = {"ssh", "admin@kubernetes-home-server-node-4"}
                }
            }
        }, {
            key = "7",
            action = wezterm.action {
                SpawnCommandInNewTab = {
                    args = {"ssh", "admin@kubernetes-home-server-node-5"}
                }
            }
        }, {
            key = "8",
            action = wezterm.action {
                SpawnCommandInNewTab = {
                    args = {"ssh", "admin@kubernetes-home-server-node-6"}
                }
            }
        }, {
            key = "9",
            action = wezterm.action {
                SpawnCommandInNewTab = {
                    args = {"ssh", "admin@kubernetes-home-server-node-7"}
                }
            }
        }, {
            key = "a",
            action = wezterm.action {
                SpawnCommandInNewTab = {
                    args = {"ssh", "admin@kubernetes-home-server-node-8"}
                }
            }
        }, {
            key = "b",
            action = wezterm.action {
                SpawnCommandInNewTab = {
                    args = {"ssh", "admin@atuin-home-server"}
                }
            }
        }, {
            key = "c",
            action = wezterm.action {
                SpawnCommandInNewTab = {
                    args = {"ssh", "dev-vinicius-andrade@games-home-server"}
                }
            }
        }, {
            key = "d",
            action = wezterm.action {
                SpawnCommandInNewTab = {
                    args = {"ssh", "admin@kubernetes-home-server-load-balancer"}
                }
            }
        }, {
            key = "e",
            action = wezterm.action {
                SpawnCommandInNewTab = {
                    args = {"ssh", "admin@kubernetes-home-server-rancher-load-balancer"}
                }
            }
        }, {
            key = "f",
            action = wezterm.action {
                SpawnCommandInNewTab = {
                    args = {"ssh", "admin@kubernetes-home-server-rancher-node-1"}
                }
            }
        }, {
            key = "g",
            action = wezterm.action {
                SpawnCommandInNewTab = {
                    args = {"ssh", "admin@kubernetes-home-server-rancher-node-2"}
                }
            }
        }, {
            key = "h",
            action = wezterm.action {
                SpawnCommandInNewTab = {
                    args = {"ssh", "admin@kubernetes-home-server-rancher-node-3"}
                }
            }
        }}
    }
end

return module
