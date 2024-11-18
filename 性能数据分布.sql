select
    MainCityPerfTargetFrameRate as 目标帧率,
    MainCityPerfDeviceLevel as 机型档位,
    avg(MainCityPerfMaincityRealFps) / 10 as 平均帧率,
    avg(
        (MainCityPerfJank) / (MainCityPerfStayDuration / 60000)
    ) as 每分钟总卡顿次数,
    count(*) as 样本数量,
    avg(MainCityPerfLeavePss) as 离开主城平均内存,
    max(MainCityPerfLeavePss) as 离开主城最高内存,
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
                        and { { range } }(dtEventTime)
                )
            ),
            2
        ),
        '%'
    ) AS 样本占比
from
    100712_CBT2ExportTable
where
    MainCityPerfMaincityRealFps > 0
    and MainCityPerfMaincityRealFps < 2000
    and MainCityPerfreserve3 = 0
    and MainCityPerfDevice != "tenc gamematrix"
    and MainCityPerfStayDuration > 30000
    and { { range } }(dtEventTime)
group by
    MainCityPerfTargetFrameRate,
    MainCityPerfDeviceLevel