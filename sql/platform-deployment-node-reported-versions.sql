-- Layer 2 · platform_deployment_node.reported_versions（节点已装 component→version JSON）
-- 幂等：列已存在则跳过

SET @col_exists := (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'platform_deployment_node'
      AND COLUMN_NAME = 'reported_versions'
);

SET @ddl := IF(
    @col_exists = 0,
    'ALTER TABLE platform_deployment_node ADD COLUMN reported_versions varchar(2048) DEFAULT NULL COMMENT ''component→version JSON'' AFTER last_report_at',
    'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
