-- install / onprem · OAuth2 client 幂等种子（商 P0 · 防预发空表无法 Admin 登录）
-- client_id=default · secret=admin123（与官方 ruoyi-vue-pro.sql 一致）

INSERT INTO `system_oauth2_client` (
  `id`, `client_id`, `secret`, `name`, `logo`, `description`, `status`,
  `access_token_validity_seconds`, `refresh_token_validity_seconds`,
  `redirect_uris`, `authorized_grant_types`, `scopes`, `auto_approve_scopes`,
  `authorities`, `resource_ids`, `additional_information`,
  `creator`, `create_time`, `updater`, `update_time`, `deleted`
) VALUES (
  1, 'default', 'admin123', '芋道源码', '', 'install/oauth seed', 0,
  1800, 2592000,
  '["https://www.iocoder.cn","https://doc.iocoder.cn"]',
  '["password","authorization_code","implicit","refresh_token","client_credentials"]',
  '["user.read","user.write"]', '[]',
  '["user.read","user.write"]', '[]', '{}',
  '1', NOW(), '1', NOW(), b'0'
) ON DUPLICATE KEY UPDATE
  `secret` = VALUES(`secret`),
  `status` = 0,
  `deleted` = b'0',
  `authorized_grant_types` = VALUES(`authorized_grant_types`),
  `updater` = 'install-oauth2-client-seed',
  `update_time` = NOW();
