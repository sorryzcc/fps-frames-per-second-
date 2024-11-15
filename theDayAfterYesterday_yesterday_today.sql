SELECT
    y.MainCityPerfTargetFrameRate AS 前日目标帧率,
    y.MainCityPerfDeviceLevel AS 前日机型档位,
    y.昨日平均帧率 AS 前天平均帧率,
    t.昨日平均帧率 AS 昨天平均帧率,
    y.昨日平均帧率 - COALESCE(t.昨日平均帧率, 0) AS 帧率变化,
    t.MainCityPerfDeviceLevel AS 昨日机型挡位
FROM
    (
        SELECT
            MainCityPerfTargetFrameRate,
            MainCityPerfDeviceLevel,
            AVG(MainCityPerfMaincityRealFps) / 10 AS 昨日平均帧率
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
            AVG(MainCityPerfMaincityRealFps) / 10 AS 昨日平均帧率
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