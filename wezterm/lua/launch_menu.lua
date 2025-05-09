local wezterm = require 'wezterm'
local module = {}
function module.apply_config(config)
  config.launch_menu = { {
    label = "pfsense",
    args = { "ssh", "vinicius.andrade@pfsense.andrades.cloud", "-p 55222" }
  }, {
    label = "nixos-development-tests",
    args = { "ssh", "admin@nixos-development.andrades.cloud", "-i", "C:\\Users\\vinic\\.ssh\\ssh_id_ed25519" }
  }, {
    label = "kubernetes-management",
    args = { "ssh", "admin@kubernetes-home-server-management.andrades.cloud" }
  }, {
    label = "kubernetes-node-1",
    args = { "ssh", "admin@kubernetes-home-server-node-1.andrades.cloud" }
  }, {
    label = "kubernetes-node-2",
    args = { "ssh", "admin@kubernetes-home-server-node-2.andrades.cloud" }
  }, {
    label = "kubernetes-node-3",
    args = { "ssh", "admin@kubernetes-home-server-node-3.andrades.cloud" }
  }, {
    label = "kubernetes-node-4",
    args = { "ssh", "admin@kubernetes-home-server-node-4.andrades.cloud" }
  }, {
    label = "kubernetes-node-5",
    args = { "ssh", "admin@kubernetes-home-server-node-5.andrades.cloud" }
  }, {
    label = "kubernetes-node-6",
    args = { "ssh", "admin@kubernetes-home-server-node-6.andrades.cloud" }
  }, {
    label = "kubernetes-node-7",
    args = { "ssh", "admin@kubernetes-home-server-node-7.andrades.cloud" }
  }, {
    label = "kubernetes-node-8",
    args = { "ssh", "admin@kubernetes-home-server-node-8.andrades.cloud" }
  }, {
    label = "atuin",
    args = { "ssh", "admin@atuin-home-server.andrades.cloud" }
  }, {
    label = "games-home-server",
    args = { "ssh", "dev-vinicius-andrade@games-home-server.andrades.cloud" }
  }, {
    label = "kubernetes-load-balancer",
    args = { "ssh", "admin@kubernetes-home-server-load-balancer.andrades.cloud" }
  }, {
    label = "postgres-load-balancer",
    args = { "ssh", "admin@database-home-server-postgres-load-balancer.andrades.cloud" }
  }, {
    label = "postgres-01",
    args = { "ssh", "admin@database-home-server-postgres-01.andrades.cloud" }
  }, {
    label = "postgres-02",
    args = { "ssh", "admin@database-home-server-postgres-02.andrades.cloud" }
  }, {
    label = "postgres-03",
    args = { "ssh", "admin@database-home-server-postgres-03.andrades.cloud" }
  }, {
    label = "etcd-load-balancer",
    args = { "ssh", "admin@database-home-server-etcd-load-balancer.andrades.cloud" }
  }, {
    label = "etcd-01",
    args = { "ssh", "admin@database-home-server-etcd-01.andrades.cloud" }
  }, {
    label = "etcd-02",
    args = { "ssh", "admin@database-home-server-etcd-02.andrades.cloud" }
  }, {
    label = "etcd-03",
    args = { "ssh", "admin@database-home-server-etcd-03.andrades.cloud" }
  }, {
    label = "portainer-home-server",
    args = { "ssh", "admin@portainer-home-server.andrades.cloud" }
  } }
end

return module
