-- 租户应用市场菜单（6173-6177）
-- 挂载在「APP 业务中心」(6000) 下；执行前请先跑 app-business-menu-tree-baseline.sql

INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(6173, '应用市场', 'tenant:app:market:query', 2, 4, 6000, 'app-market', 'ep:shopping-cart', 'tenant/app-market/index', 'TenantAppMarket', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6174, '市场查询', 'tenant:app:market:query', 3, 1, 6173, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6175, '权益查询', 'tenant:app:market:entitlement', 3, 2, 6173, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6176, '市场加购', 'tenant:app:market:purchase', 3, 3, 6173, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `permission` = VALUES(`permission`),
  `parent_id` = VALUES(`parent_id`),
  `path` = VALUES(`path`),
  `component` = VALUES(`component`),
  `updater` = 'platform-market-menu',
  `update_time` = NOW();
