-- ③ 独立部署 · 升级编排计划（规格见 docs/platform/delivery/独立部署-升级与SLA开发规范.md）

CREATE TABLE IF NOT EXISTS `delivery_upgrade_plans` (
    `id`               bigint       NOT NULL AUTO_INCREMENT COMMENT '编号',
    `tenant_id`        bigint       NOT NULL DEFAULT 0 COMMENT '租户（0=全局模板）',
    `plan_code`        varchar(64)  NOT NULL COMMENT '计划编码',
    `title`            varchar(128) NOT NULL COMMENT '标题',
    `target_version`   varchar(64)  NOT NULL COMMENT '目标版本',
    `channel`          varchar(32)  NOT NULL DEFAULT 'SIGNED_MANIFEST' COMMENT 'SIGNED_MANIFEST / MANUAL_ARTIFACT',
    `status`           tinyint      NOT NULL DEFAULT 0 COMMENT '0草稿 1已排程 2滚动中 3完成 4已回滚',
    `window_start`     datetime              DEFAULT NULL COMMENT '维护窗开始',
    `window_end`       datetime              DEFAULT NULL COMMENT '维护窗结束',
    `artifact_ref`     varchar(512)          DEFAULT NULL COMMENT '制品引用（manifest component@ver / 镜像）',
    `rollback_ref`     varchar(512)          DEFAULT NULL COMMENT '回滚目标 N-1',
    `notes`            varchar(1024)         DEFAULT NULL COMMENT 'SLA/备注',
    `creator`          varchar(64)           DEFAULT '' COMMENT '创建者',
    `create_time`      datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`          varchar(64)           DEFAULT '' COMMENT '更新者',
    `update_time`      datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`          bit(1)       NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_delivery_upgrade_plan_code` (`tenant_id`, `plan_code`),
    KEY `idx_delivery_upgrade_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='③升级编排计划';
