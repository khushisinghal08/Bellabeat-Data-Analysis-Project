use bellabeat;

select * from daily_activity limit 20;

select * from 
daily_activity da
join sleepday sd
on da.Id = sd.Id
and da.ActivityDate = sd.SleepDate
limit 20;

SELECT *
FROM daily_activity da
LEFT JOIN weightloginfo wl
ON da.Id = wl.Id
AND DATE(da.ActivityDate) = DATE(wl.LogDate)
;

select * from weightloginfo limit 20;

SELECT *
FROM daily_activity da
LEFT JOIN weightloginfo wl
ON da.Id = wl.Id
AND DATE(da.ActivityDate) = DATE(wl.LogDate);

SELECT DISTINCT DATE(ActivityDate) 
FROM daily_activity
LIMIT 10;
SELECT DISTINCT DATE(LogDate) 
FROM weightloginfo
LIMIT 10;

SELECT DISTINCT DATE(ActivityDate) 
FROM daily_activity
LIMIT 10;

SELECT DISTINCT DATE(LogDate) 
FROM weightloginfo
LIMIT 10;

SELECT da.Id, 
       DATE(da.ActivityDate) AS activity_date,
       DATE(wl.LogDate) AS weight_date
FROM daily_activity da
LEFT JOIN weightloginfo wl
  ON da.Id = wl.Id
 AND DATE(da.ActivityDate) = DATE(wl.LogDate)
WHERE da.Id = 1503960366;

SELECT da.Id,
       DATE(da.ActivityDate) AS activity_date,
       DATE(wl.LogDate) AS weight_date
FROM daily_activity da
INNER JOIN weightloginfo wl
  ON da.Id = wl.Id
 AND DATE(da.ActivityDate) = DATE(wl.LogDate)
WHERE da.Id = 1927972279;

CREATE TABLE daily_heartrate AS
SELECT 
    Id,
    DATE(Time) AS ActivityDate,
    AVG(Value) AS AvgHeartRate
FROM heartrate
GROUP BY Id, DATE(Time);
select * from daily_heartrate;

CREATE TABLE master_daily AS
SELECT 
    da.Id,
    DATE(da.ActivityDate) AS activity_date,
    da.TotalSteps,
    da.TotalDistance,
    da.Calories,
    sd.TotalMinutesAsleep,
    sd.TotalTimeInBed,
    wl.WeightKg,
    wl.BMI
FROM daily_activity da
LEFT JOIN sleepday sd
    ON da.Id = sd.Id
   AND DATE(da.ActivityDate) = DATE(sd.SleepDate)
LEFT JOIN weightloginfo wl
    ON da.Id = wl.Id
   AND DATE(da.ActivityDate) = DATE(wl.LogDate);
   
   select * from weightloginfo;
   select * from daily_activity;
   
   select * from master_daily limit 20;
   
   CREATE TABLE master_daily AS
SELECT 
    da.Id,
    DATE(da.ActivityDate) AS activity_date,

    -- Activity Data
    da.TotalSteps,
    da.TotalDistance,
    da.VeryActiveMinutes,
    da.FairlyActiveMinutes,
    da.LightlyActiveMinutes,
    da.SedentaryMinutes,
    da.Calories,

    -- Sleep Data
    sd.TotalMinutesAsleep,
    sd.TotalTimeInBed,

    -- Weight Data
    wl.WeightKg,
    wl.BMI

FROM daily_activity da

LEFT JOIN sleepday sd
    ON da.Id = sd.Id
   AND DATE(da.ActivityDate) = DATE(sd.SleepDate)

LEFT JOIN weightloginfo wl
    ON da.Id = wl.Id
   AND DATE(da.ActivityDate) = DATE(wl.LogDate);
   
   select count(*) from master_daily;
   select count(*) from daily_activity;
   
   SELECT 
    COUNT(*) AS total_rows,
    COUNT(WeightKg) AS weight_available,
    COUNT(TotalMinutesAsleep) AS sleep_available
FROM master_daily;

SELECT 
COUNT(*) AS total_rows,
COUNT(TotalSteps) AS steps_not_null,
COUNT(TotalMinutesAsleep) AS sleep_not_null,
COUNT(WeightKg) AS weight_not_null
FROM master_daily;

SELECT * 
FROM master_daily
WHERE TotalSteps < 0;

SELECT *
FROM master_daily
WHERE TotalMinutesAsleep > 1440;

SELECT Id, activity_date, COUNT(*)
FROM master_daily
GROUP BY Id, activity_date
HAVING COUNT(*) > 1;

CREATE TABLE master_daily_clean AS
SELECT DISTINCT *
FROM master_daily;

SELECT COUNT(*) FROM master_daily;
SELECT COUNT(*) FROM master_daily_clean;
#insights 

select Id , avg(TotalSteps) from master_daily
group by Id
order by avg(TotalSteps) desc;

SELECT 
    CASE 
        WHEN TotalMinutesAsleep < 300 THEN 'Low Sleep'
        ELSE 'Good Sleep'
    END AS sleep_category,
    AVG(TotalSteps) AS avg_steps
FROM master_daily
GROUP BY sleep_category;

SELECT AVG(TotalSteps) AS overall_avg_steps
FROM master_daily;

select 
case when TotalMinutesAsleep < 300 then 'Low Sleep'
else 'Good Sleep'
end as sleep_category,
avg(TotalSteps) as avg_steps
from master_daily
group by sleep_category;

select avg(TotalSteps) as avg_steps,
avg(Calories) as avg_calories
from master_daily;

select Id , avg(SedentaryMinutes) AS avg_sedentary
from master_daily
group by Id
order by avg(SedentaryMinutes);

SELECT 
    Id,
    AVG(TotalSteps) AS avg_steps,
    CASE 
        WHEN AVG(TotalSteps) < 5000 THEN 'Sedentary'
        WHEN AVG(TotalSteps) BETWEEN 5000 AND 9999 THEN 'Moderately Active'
        ELSE 'Highly Active'
    END AS activity_level
FROM master_daily
GROUP BY Id;

select dayname(activity_date) as day_name ,
avg(TotalSteps) as avg_steps
from master_daily
group by day_name
order by avg_steps DESC;

SELECT 
    CASE 
        WHEN TotalMinutesAsleep < 300 THEN 'Low Sleep'
        WHEN TotalMinutesAsleep BETWEEN 300 AND 420 THEN 'Moderate Sleep'
        ELSE 'High Sleep'
    END AS sleep_group,
    AVG(TotalSteps) AS avg_steps
FROM master_daily
GROUP BY sleep_group;

select * from master_daily_clean;
select count(*) from master_daily_clean;

SELECT 
    Id,
    AVG(SedentaryMinutes) AS avg_sedentary
FROM master_daily
GROUP BY Id
ORDER BY avg_sedentary DESC;

SELECT 
    AVG(WeightKg) AS avg_weight,
    AVG(TotalSteps) AS avg_steps
FROM master_daily
WHERE WeightKg IS NOT NULL;

SELECT 
    MONTH(activity_date) AS month,
    AVG(TotalSteps) AS avg_steps
FROM master_daily
GROUP BY month;

CREATE TABLE daily_heartrate AS
SELECT 
    Id,
    DATE(Time) AS activity_date,
    AVG(Value) AS avg_heartrate,
    MAX(Value) AS max_heartrate,
    MIN(Value) AS min_heartrate
FROM heartrate
GROUP BY Id, DATE(Time);

CREATE TABLE master_daily_final AS
SELECT 
    md.*,
    dh.avg_heartrate,
    dh.max_heartrate,
    dh.min_heartrate
FROM master_daily_clean md
LEFT JOIN daily_heartrate dh
    ON md.Id = dh.Id
   AND md.activity_date = dh.activity_date;
   
   select * from master_daily_final;
   
   SELECT 
    AVG(TotalSteps) AS avg_steps,
    AVG(avg_heartrate) AS avg_hr
FROM master_daily_final
WHERE avg_heartrate IS NOT NULL;

SELECT 
    Id,
    AVG(TotalSteps) AS avg_steps,
    AVG(avg_heartrate) AS avg_hr
FROM master_daily_final
GROUP BY Id
ORDER BY avg_steps DESC;

SELECT 
    CASE 
        WHEN TotalMinutesAsleep < 300 THEN 'Low Sleep'
        ELSE 'Good Sleep'
    END AS sleep_category,
    AVG(avg_heartrate) AS avg_hr
FROM master_daily_final
WHERE avg_heartrate IS NOT NULL
GROUP BY sleep_category;

SELECT 
    DAYNAME(activity_date) AS day_name,
    AVG(avg_heartrate) AS avg_hr
FROM master_daily_final
GROUP BY day_name;

SELECT 
    Id,
    AVG(max_heartrate) AS avg_max_hr
FROM master_daily_final
GROUP BY Id
ORDER BY avg_max_hr DESC;

SELECT 
    AVG(SedentaryMinutes) AS avg_sedentary,
    AVG(avg_heartrate) AS avg_hr
FROM master_daily_final
WHERE avg_heartrate IS NOT NULL;

select * from master_daily_final;

SELECT 
COUNT(*) AS total_rows,
COUNT(avg_heartrate) AS hr_available,
COUNT(WeightKg) AS weight_available,
COUNT(TotalMinutesAsleep) AS sleep_available
FROM master_daily_final;

describe master_daily_final;