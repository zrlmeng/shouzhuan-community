-- 社区版站长侧栏三入口补强：应用市场 / 授权状态 / 框架与能力更新（只读）
-- 与 install-foundation-menu-trim.sql 配套；幂等 ON DUPLICATE KEY UPDATE

INSERT INTO `system_menu` (
    `id`, `name`, `permission`, `type`, `sort`, `parent_id`,
    `path`, `icon`, `component`, `component_name`, `status`,
    `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`
) VALUES
(6210, '框架与能力更新', 'tenant:app:market:query', 2, 6, 6000, 'platform-updates', 'ep:upload-filled', 'tenant/instance-updates/index', 'TenantInstanceUpdates', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `permission` = VALUES(`permission`),
    `path` = VALUES(`path`),
    `component` = VALUES(`component`),
    `component_name` = VALUES(`component_name`),
    `parent_id` = 6000,
    `status` = 0,
    `updater` = 'install-community-site-admin',
    `update_time` = NOW();

-- 运行面禁止 publish/push（控制面能力裁剪）
UPDATE `system_menu`
SET `status` = 1,
    `updater` = 'install-community-site-admin',
    `update_time` = NOW()
WHERE `deleted` = b'0'
  AND `id` IN (6212, 6213);
