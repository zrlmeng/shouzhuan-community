-- 收银 Collect 运维权限（挂应用市场菜单下）
-- 权限码：wallet:collect:query|create（ADR-0030）

INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(6177, '收银查询', 'wallet:collect:query', 3, 4, 6173, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6178, '收银运维', 'wallet:collect:create', 3, 5, 6173, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `permission` = VALUES(`permission`),
    `name` = VALUES(`name`),
    `updater` = 'collect-menu',
    `update_time` = NOW(),
    `deleted` = b'0';
