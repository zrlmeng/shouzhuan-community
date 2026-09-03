-- 装机版对外菜单裁剪：隐藏芋道母版演示模块，保留基础框架 + 租户市场/授权
-- 幂等：status=1 停用；不删行。本地/交付包导库后可再执行。
-- 保留顶级：系统管理 / 基础设施 / 会员中心 / APP 业务中心
-- APP 业务中心内保留：应用市场(6173)、授权状态(6196)；隐藏网赚运营(6005)等母版运营树

UPDATE `system_menu`
SET `status` = 1,
    `updater` = 'install-menu-trim',
    `update_time` = NOW()
WHERE `deleted` = b'0'
  AND `parent_id` = 0
  AND (
    `path` IN (
      '/mall', '/crm', '/erp', '/wms', '/mes', '/ai', '/iot', '/im', '/mp',
      '/bpm', '/report', '/pay'
    )
    OR `path` LIKE 'http%'
    OR `path` LIKE 'https%'
  );

-- 垂直轨出厂默认停用（加购/装包后由 install-pending 或 enable-owned SQL 再打开）
UPDATE `system_menu`
SET `status` = 1,
    `updater` = 'install-menu-trim',
    `update_time` = NOW()
WHERE `deleted` = b'0'
  AND `parent_id` = 0
  AND `path` = '/appmarket'
  AND `id` = 6870;

-- 轨 A 母版运营子树（装机出厂不含垂直网赚运营）
-- 注意：invite 运营树 6450+ 挂 6000，6390/6400/6410/6420 已迁移至 6450，不在此停用范围
-- 母版全量库 WMS 占 6451+：app-invite-ops-menu 后必须再跑 app-invite-ops-menu-baseline-collision-fix.sql
UPDATE `system_menu`
SET `status` = 1,
    `updater` = 'install-menu-trim',
    `update_time` = NOW()
WHERE `deleted` = b'0'
  AND (
    `id` = 6005
    OR `parent_id` = 6005
    OR `id` IN (6001, 6006, 6007)
    OR `parent_id` IN (6001, 6006, 6007)
  );

-- 控制面「代理商中心」不出装机站长后台
UPDATE `system_menu`
SET `status` = 1,
    `updater` = 'install-menu-trim',
    `update_time` = NOW()
WHERE `deleted` = b'0'
  AND (
    `id` IN (6221, 6222, 6223, 6224, 6225)
    OR `parent_id` = 6221
    OR `permission` LIKE 'commercial:partner:%'
  );

-- 控制面「授权中心」签发/运维树（装机仅保留站长只读 6196）
UPDATE `system_menu`
SET `status` = 1,
    `updater` = 'install-menu-trim',
    `update_time` = NOW()
WHERE `deleted` = b'0'
  AND (
    `id` = 6002
    OR `parent_id` = 6002
    OR `component` LIKE 'license/%'
  )
  AND `id` NOT IN (6196, 6197);

-- 母版运营杂项（装机出厂不展示）
UPDATE `system_menu`
SET `status` = 1,
    `updater` = 'install-menu-trim',
    `update_time` = NOW()
WHERE `deleted` = b'0'
  AND `parent_id` = 6000
  AND `path` IN ('survey', 'forum', 'home-ops', 'site', 'earn', 'risk', 'member-welfare');

-- 应用市场挂回 APP 业务中心（勿挂在已裁剪的 6007 下）
UPDATE `system_menu`
SET `parent_id` = 6000,
    `status` = 0,
    `path` = 'app-market',
    `component` = 'tenant/app-market/index',
    `updater` = 'install-menu-trim',
    `update_time` = NOW()
WHERE `id` = 6173 AND `deleted` = b'0';

-- 控制面「市场 SKU」CRUD（6230–6234）不出社区版/运行面站长后台
-- 货架标价与上下架只在总站；租户只走「应用市场」6173 只读同步 + 加购
UPDATE `system_menu`
SET `status` = 1,
    `updater` = 'install-menu-trim',
    `update_time` = NOW()
WHERE `deleted` = b'0'
  AND (
    `id` IN (6230, 6231, 6232, 6233, 6234)
    OR `parent_id` = 6230
    OR `component` = 'platform/market-sku/index'
    OR `permission` LIKE 'platform:market:sku:%'
  );

-- 确保装机关键菜单启用
UPDATE `system_menu`
SET `status` = 0,
    `visible` = b'1',
    `updater` = 'install-menu-trim',
    `update_time` = NOW()
WHERE `deleted` = b'0'
  AND `id` IN (6000, 6004, 6173, 6174, 6175, 6176, 6177, 6178, 6196, 6197);
