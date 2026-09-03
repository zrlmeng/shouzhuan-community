-- SKU 加价列（分）；执行前确认列不存在
ALTER TABLE `platform_market_sku`
    ADD COLUMN `price_fen` int NULL DEFAULT NULL COMMENT '加购价（分）；NULL=不可在线收银' AFTER `price_hint`;

UPDATE `platform_market_sku`
SET `price_fen` = 100, `price_hint` = '¥1.00', `updater` = 'collect-baseline'
WHERE `capability_id` = 'appmarket.core' AND (`price_fen` IS NULL OR `price_fen` = 0);
