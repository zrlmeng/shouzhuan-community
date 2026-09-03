-- 站长 License 只读页（商8）· 菜单 6196-6197
-- 续费/吊销仍在控制面；本页仅 summary 可视

INSERT INTO `system_menu` (
    `id`, `name`, `permission`, `type`, `sort`, `parent_id`,
    `path`, `icon`, `component`, `component_name`, `status`,
    `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`
) VALUES
(6196, '授权状态', 'tenant:license:query', 2, 5, 6000, 'tenant-license', 'ep:key', 'tenant/license/index', 'TenantLicense', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6197, '授权查询', 'tenant:license:query', 3, 1, 6196, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `permission` = VALUES(`permission`),
    `path` = VALUES(`path`),
    `component` = VALUES(`component`),
    `updater` = 'tenant-license-menu',
    `update_time` = NOW();
