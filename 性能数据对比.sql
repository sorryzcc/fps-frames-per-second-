SELECT
    p.MainCityPerfTargetFrameRate AS 前天目标帧率,
    p.MainCityPerfDeviceLevel AS 前天机型档位,
    p.前日平均帧率 AS 前天平均帧率,
    p.前日每分钟总卡顿次数 AS 前天每分钟总卡顿次数,
    p.前日样本数量 AS 前天样本数量,
    p.前日样本占比 AS 前天样本占比,
    y.MainCityPerfTargetFrameRate AS 昨天目标帧率,
    y.MainCityPerfDeviceLevel AS 昨天机型档位,
    y.昨日平均帧率 AS 昨天平均帧率,
    y.昨日每分钟总卡顿次数 AS 昨天每分钟总卡顿次数,
    y.昨日样本数量 AS 昨天样本数量,
    y.昨日样本占比 AS 昨天样本占比,
    y.昨日平均帧率 - COALESCE(p.前日平均帧率, 0) AS 前天与昨天帧率变化,
    y.昨日每分钟总卡顿次数 - COALESCE(p.前日每分钟总卡顿次数, 0) AS 前天与昨天每分钟总卡顿次数变化,
    t.MainCityPerfTargetFrameRate AS 今天目标帧率,
    t.MainCityPerfDeviceLevel AS 今天机型档位,
    t.今日平均帧率 AS 今天平均帧率,
    t.今日每分钟总卡顿次数 AS 今天每分钟总卡顿次数,
    t.今日样本数量 AS 今天样本数量,
    t.今日样本占比 AS 今天样本占比,
    t.今日平均帧率 - COALESCE(y.昨日平均帧率, 0) AS 昨天与今天帧率变化,
    t.今日每分钟总卡顿次数 - COALESCE(y.昨日每分钟总卡顿次数, 0) AS 昨天与今天每分钟总卡顿次数变化
FROM
    (
        SELECT
            MainCityPerfTargetFrameRate,
            MainCityPerfDeviceLevel,
            AVG(MainCityPerfMaincityRealFps) / 10 AS 前日平均帧率,
            AVG(
                (MainCityPerfJank) / (MainCityPerfStayDuration / 60000)
            ) AS 前日每分钟总卡顿次数,
            count(*) as 前日样本数量,
            concat(
                round(
                    (
                        count(*) * 100.0 / (
                            select
                                count(*)
                            from
                                100712_CBT2ExportTable
                            where
                                MainCityPerfMaincityRealFps > 0
                                and MainCityPerfMaincityRealFps < 2000
                                and MainCityPerfreserve3 = 0
                                and MainCityPerfDevice != "tenc gamematrix"
                                and MainCityPerfStayDuration > 30000
                                AND thedate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%Y%m%d')
                        )
                    ),
                    2
                ),
                '%'
            ) AS 前日样本占比
        FROM
            100712_CBT2ExportTable
        WHERE
            MainCityPerfMaincityRealFps > 0
            AND MainCityPerfMaincityRealFps < 2000
            AND MainCityPerfreserve3 = 0
            AND MainCityPerfDevice != 'tenc gamematrix'
            AND MainCityPerfStayDuration > 30000
            AND thedate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%Y%m%d')
        GROUP BY
            MainCityPerfTargetFrameRate,
            MainCityPerfDeviceLevel
    ) p
    LEFT JOIN (
        SELECT
            MainCityPerfTargetFrameRate,
            MainCityPerfDeviceLevel,
            AVG(MainCityPerfMaincityRealFps) / 10 AS 昨日平均帧率,
            AVG(
                (MainCityPerfJank) / (MainCityPerfStayDuration / 60000)
            ) AS 昨日每分钟总卡顿次数,
            count(*) as 昨日样本数量,
            concat(
                round(
                    (
                        count(*) * 100.0 / (
                            select
                                count(*)
                            from
                                100712_CBT2ExportTable
                            where
                                MainCityPerfMaincityRealFps > 0
                                and MainCityPerfMaincityRealFps < 2000
                                and MainCityPerfreserve3 = 0
                                and MainCityPerfDevice != "tenc gamematrix"
                                and MainCityPerfStayDuration > 30000
                                AND thedate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')
                        )
                    ),
                    2
                ),
                '%'
            ) AS 昨日样本占比
        FROM
            100712_CBT2ExportTable
        WHERE
            MainCityPerfMaincityRealFps > 0
            AND MainCityPerfMaincityRealFps < 2000
            AND MainCityPerfreserve3 = 0
            AND MainCityPerfDevice != 'tenc gamematrix'
            AND MainCityPerfStayDuration > 30000
            AND thedate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')
        GROUP BY
            MainCityPerfTargetFrameRate,
            MainCityPerfDeviceLevel
    ) y ON p.MainCityPerfTargetFrameRate = y.MainCityPerfTargetFrameRate
    AND p.MainCityPerfDeviceLevel = y.MainCityPerfDeviceLevel
    LEFT JOIN (
        SELECT
            MainCityPerfTargetFrameRate,
            MainCityPerfDeviceLevel,
            AVG(MainCityPerfMaincityRealFps) / 10 AS 今日平均帧率,
            AVG(
                (MainCityPerfJank) / (MainCityPerfStayDuration / 60000)
            ) AS 今日每分钟总卡顿次数,
            count(*) as 今日样本数量,
            concat(
                round(
                    (
                        count(*) * 100.0 / (
                            select
                                count(*)
                            from
                                100712_CBT2ExportTable
                            where
                                MainCityPerfMaincityRealFps > 0
                                and MainCityPerfMaincityRealFps < 2000
                                and MainCityPerfreserve3 = 0
                                and MainCityPerfDevice != "tenc gamematrix"
                                and MainCityPerfStayDuration > 30000
                                AND thedate = DATE_FORMAT(CURDATE(), '%Y%m%d')
                        )
                    ),
                    2
                ),
                '%'
            ) AS 今日样本占比
        FROM
            100712_CBT2ExportTable
        WHERE
            MainCityPerfMaincityRealFps > 0
            AND MainCityPerfMaincityRealFps < 2000
            AND MainCityPerfreserve3 = 0
            AND MainCityPerfDevice != 'tenc gamematrix'
            AND MainCityPerfStayDuration > 30000
            AND thedate = DATE_FORMAT(CURDATE(), '%Y%m%d')
        GROUP BY
            MainCityPerfTargetFrameRate,
            MainCityPerfDeviceLevel
    ) t ON p.MainCityPerfTargetFrameRate = t.MainCityPerfTargetFrameRate
    AND p.MainCityPerfDeviceLevel = t.MainCityPerfDeviceLevel;