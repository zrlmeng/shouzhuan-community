-- platform 能力 SKU 运营表（C5-P0 · 控制面写）
-- 与 PlatformMarketCatalogRegistry 静态登记合并为目录真源

CREATE TABLE IF NOT EXISTS `platform_market_sku` (
    `id`                  bigint       NOT NULL AUTO_INCREMENT COMMENT '编号',
    `capability_id`       varchar(128) NOT NULL COMMENT '能力 ID',
    `display_name`        varchar(128) NOT NULL COMMENT '展示名',
    `summary`             varchar(512)          DEFAULT NULL COMMENT '摘要',
    `price_hint`          varchar(64)           DEFAULT '联系商务' COMMENT '价格提示',
    `manifest_version`    varchar(32)  NOT NULL DEFAULT '1.0.0' COMMENT '清单版本',
    `component_id`        varchar(128)          DEFAULT NULL COMMENT '制品 component',
    `bundled_with_install` bit(1)      NOT NULL DEFAULT b'0' COMMENT '装机 bundled',
    `marketplace_listed`  bit(1)       NOT NULL DEFAULT b'1' COMMENT '市场展示',
    `status`              tinyint      NOT NULL DEFAULT 0 COMMENT '0 正常 1 停用',
    `creator`             varchar(64)           DEFAULT '' COMMENT '创建者',
    `create_time`         datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`             varchar(64)           DEFAULT '' COMMENT '更新者',
    `update_time`         datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`             bit(1)       NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_capability_id` (`capability_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='远程市场 SKU 运营';

-- 与 PlatformMarketCatalogRegistry 对齐的运营种子（幂等；空表时 Registry 仍可单独回退）
INSERT INTO `platform_market_sku`
    (`capability_id`, `display_name`, `summary`, `price_hint`, `manifest_version`, `component_id`,
     `bundled_with_install`, `marketplace_listed`, `status`, `creator`, `updater`)
VALUES
    ('common.home', '首页运营', '轮播、公告、宫格 Feed', '联系商务', '1.0.0', 'backend-app-common', b'1', b'1', 0, 'sku-baseline', 'sku-baseline'),
    ('message.inbox', '消息收件箱', '站内信分页、未读、设备注册', '联系商务', '1.0.0', 'backend-app-message', b'1', b'1', 0, 'sku-baseline', 'sku-baseline'),
    ('contact.channels', '官方联系', '联系我们分组与渠道宫格', '联系商务', '1.0.0', 'backend-app-contact', b'0', b'1', 0, 'sku-baseline', 'sku-baseline'),
    ('appmarket.core', '网赚应用市场', 'EarnStore 垂直（首加购样板）', '联系商务', '1.0.0', 'backend-app-appmarket', b'0', b'1', 0, 'sku-baseline', 'sku-baseline'),
    ('earn.core', '网赚能力包', '任务、试玩、钱包与提现', '联系商务', '1.0.0', 'backend-app-earn', b'0', b'1', 0, 'sku-baseline', 'sku-baseline'),
    ('browser.core', '纯浏览器', '浏览器垂直能力（L3）', '联系商务', '1.0.0', 'backend-app-browser', b'0', b'1', 0, 'sku-baseline', 'sku-baseline'),
    ('weather.core', '天气能力包', '和风天气与首页天气入口', '联系商务', '1.0.0', 'backend-app-weather', b'0', b'1', 0, 'sku-baseline', 'sku-baseline'),
    ('survey.engine', '题库考试', '问卷与考试模块', '联系商务', '1.0.0', 'backend-app-survey', b'0', b'1', 0, 'sku-baseline', 'sku-baseline')
ON DUPLICATE KEY UPDATE
    `display_name` = VALUES(`display_name`),
    `summary` = VALUES(`summary`),
    `component_id` = VALUES(`component_id`),
    `bundled_with_install` = VALUES(`bundled_with_install`),
    `marketplace_listed` = VALUES(`marketplace_listed`),
    `status` = 0,
    `updater` = 'sku-baseline',
    `update_time` = CURRENT_TIMESTAMP;
