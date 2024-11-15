SELECT
    y.MainCityPerfTargetFrameRate AS 前天目标帧率,
    y.MainCityPerfDeviceLevel AS 前天机型档位,
    y.前日平均帧率 AS 前天平均帧率,
    y.前日每分钟总卡顿次数 as 前天每分钟总卡顿次数,
    t.MainCityPerfTargetFrameRate as 昨天目标帧率,
    t.MainCityPerfDeviceLevel AS 昨天机型档位,
    t.昨日平均帧率 AS 昨天平均帧率,
    t.昨日每分钟总卡顿次数 as 昨天每分钟总卡顿次数,
    t.昨日平均帧率 - COALESCE(y.前日平均帧率, 0) AS 帧率变化,
    t.昨日每分钟总卡顿次数 - COALESCE(y.前日每分钟总卡顿次数, 0) AS 每分钟总卡顿次数变化
FROM
    (
        SELECT
            MainCityPerfTargetFrameRate,
            MainCityPerfDeviceLevel,
            AVG(MainCityPerfMaincityRealFps) / 10 AS 前日平均帧率,
            avg(
                (MainCityPerfJank) / (MainCityPerfStayDuration / 60000)
            ) as 前日每分钟总卡顿次数
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
    ) y
    LEFT JOIN (
        SELECT
            MainCityPerfTargetFrameRate,
            MainCityPerfDeviceLevel,
            AVG(MainCityPerfMaincityRealFps) / 10 AS 昨日平均帧率,
            avg(
                (MainCityPerfJank) / (MainCityPerfStayDuration / 60000)
            ) as 昨日每分钟总卡顿次数
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
    ) t ON y.MainCityPerfTargetFrameRate = t.MainCityPerfTargetFrameRate
    AND y.MainCityPerfDeviceLevel = t.MainCityPerfDeviceLevel;