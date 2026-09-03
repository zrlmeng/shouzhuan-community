-- 市场加购支付单 + SKU 定价（分）· 商4 收银闭环
-- 规范：ADR-0030 附录 · products/install CLOSED-LOOP 商4
-- 说明：price_fen 列若已存在，跳过对应 ALTER（手动执行时忽略 Duplicate column）

-- ALTER TABLE `platform_market_sku`
--     ADD COLUMN `price_fen` int NULL DEFAULT NULL COMMENT '加购价（分）；NULL=不可在线收银' AFTER `price_hint`;

CREATE TABLE IF NOT EXISTS `platform_market_pay_order` (
    `id`                    bigint       NOT NULL AUTO_INCREMENT COMMENT '编号',
    `tenant_id`             bigint       NOT NULL DEFAULT 0 COMMENT '租户',
    `order_no`              varchar(64)  NOT NULL COMMENT '业务单号=收银 merchantOrderId',
    `capability_id`         varchar(128) NOT NULL COMMENT '能力 ID',
    `amount_fen`            int          NOT NULL COMMENT '金额（分）',
    `status`                varchar(32)  NOT NULL DEFAULT 'CREATED' COMMENT 'CREATED/WAIT_PAY/PAID/GRANTED/EXPIRED/CLOSED/GRANT_FAILED',
    `rail_code`             varchar(32)           DEFAULT NULL COMMENT '收银轨',
    `channel_code`          varchar(64)           DEFAULT NULL COMMENT '渠道码',
    `display_mode`          varchar(32)           DEFAULT NULL COMMENT '展示模式',
    `display_content`       varchar(2048)         DEFAULT NULL COMMENT '出码/跳转内容',
    `user_id`               bigint                DEFAULT NULL COMMENT '下单用户',
    `expire_time`           datetime              DEFAULT NULL COMMENT '过期时间',
    `paid_time`             datetime              DEFAULT NULL COMMENT '支付时间',
    `granted_time`          datetime              DEFAULT NULL COMMENT 'Grant 时间',
    `grant_error`           varchar(512)          DEFAULT NULL COMMENT 'Grant 失败原因',
    `channel_order_no`      varchar(128)          DEFAULT NULL COMMENT '通道单号',
    `pay_order_id`          bigint                DEFAULT NULL COMMENT '芋道 pay_order.id',
    `creator`               varchar(64)           DEFAULT '' COMMENT '创建者',
    `create_time`           datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`               varchar(64)           DEFAULT '' COMMENT '更新者',
    `update_time`           datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`               bit(1)       NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_order_no` (`order_no`),
    KEY `idx_tenant_cap_status` (`tenant_id`, `capability_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='远程市场加购支付单';

CREATE TABLE IF NOT EXISTS `wallet_collect_order` (
    `id`                    bigint       NOT NULL AUTO_INCREMENT COMMENT '编号',
    `tenant_id`             bigint       NOT NULL DEFAULT 0 COMMENT '租户',
    `merchant_order_id`     varchar(64)  NOT NULL COMMENT '商户单号',
    `amount_fen`            int          NOT NULL COMMENT '金额（分）',
    `subject`               varchar(128) NOT NULL COMMENT '标题',
    `body`                  varchar(256)          DEFAULT NULL COMMENT '描述',
    `status`                int          NOT NULL DEFAULT 0 COMMENT '0 CREATED 10 WAIT_PAY 20 PAID 30 CLOSED 40 EXPIRED',
    `rail_code`             varchar(32)           DEFAULT NULL COMMENT '轨',
    `channel_code`          varchar(64)           DEFAULT NULL COMMENT '渠道',
    `display_mode`          varchar(32)           DEFAULT NULL,
    `display_content`       varchar(2048)         DEFAULT NULL,
    `pay_order_id`          bigint                DEFAULT NULL,
    `channel_order_no`      varchar(128)          DEFAULT NULL,
    `user_id`               bigint                DEFAULT NULL,
    `user_ip`               varchar(64)           DEFAULT NULL,
    `return_url`            varchar(512)          DEFAULT NULL,
    `expire_time`           datetime              DEFAULT NULL,
    `paid_time`             datetime              DEFAULT NULL,
    `fail_reason`           varchar(256)          DEFAULT NULL,
    `creator`               varchar(64)           DEFAULT '',
    `create_time`           datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater`               varchar(64)           DEFAULT '',
    `update_time`           datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted`               bit(1)       NOT NULL DEFAULT b'0',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_merchant_order_id` (`merchant_order_id`),
    KEY `idx_status_expire` (`status`, `expire_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公司支付门面收银单';
