CREATE DATABASE bicycle_spring_2021 DEFAULT CHARACTER SET utf8mb4;

CREATE TABLE Facility(
    stop_index INT, 
    stop_ VARCHAR(64), 
    address_ VARCHAR(64), 
    gu_name VARCHAR(16), 
    lat FLOAT, 
    lng FLOAT
);

CREATE TABLE User(
    bicycle_index VARCHAR(16), 
    time_start DATETIME, 
    stop_index1 INT, 
    stop_1 VARCHAR(64),
    count_stop1 INT, 
    time_end DATETIME, 
    stop_index2 INT, 
    stop_2 VARCHAR(64), 
    count_stop2 INT,
    cycle INT, 
    distance FLOAT
);

CREATE TABLE Weather(
    city_code INT, 
    city VARCHAR(16), 
    time_ DATETIME, 
    temperature FLOAT, 
    rain FLOAT, 
    windspeed FLOAT,
    humidity FLOAT, 
    pressure FLOAT, 
    sunshine FLOAT, 
    snow FLOAT, 
    cloud FLOAT
);


-- Bulk Insert
-- python
-- sqlalchemy


-- Check execute
-- 1) COUNT
SELECT COUNT(*) FROM User;
-- 2) LIMIT 1
SELECT *
FROM User
LIMIT 2;

SELECT *
FROM Weather
LIMIT 2;

SELECT *
FROM Facility
LIMIT 2;


-- Targeting for EDA
-- <1> Gangnam Station & Miwang Building
-- stop_index = (2231, 2407, 3628, 2505, 2409)
-- <2> Spring(March - May)
-- (time_start >= '2021-03-01')
SELECT *
FROM User
WHERE (time_start >= '2021-03-01')
  AND (stop_index1 in (2231, 2407, 3628, 2505, 2409))
LIMIT 10;


-- Y / M / D/ DoW / H
SELECT time_start
    , stop_index1
    , cycle
    , distance
    , YEAR(time_start)
    , MONTH(time_start)
    , DAY(time_start)
    , DAYOFWEEK(time_start)
    , HOUR(time_start)
FROM User
WHERE (time_start >= '2021-03-01')
  AND (stop_index1 in (2231, 2407, 3628, 2505, 2409))
LIMIT 10;


-- VIEW Gangnam_stops
CREATE VIEW Gangnam_stops AS
SELECT time_start as time
    , stop_index1 as stopnum
    , cycle
    , distance
    , YEAR(time_start) as year
    , MONTH(time_start) as month
    , DAY(time_start) as day
    , DAYOFWEEK(time_start) as dayofweek
    , HOUR(time_start) as hour
FROM User
WHERE (time_start >= '2021-03-01')
  AND (stop_index1 in (2231, 2407, 3628, 2505, 2409));


-- SELECT VIEW TABLE
SELECT *
FROM Gangnam_stops
LIMIT 10;


-- SELECT - groupby stops
SELECT stop_index1 AS stops
    , COUNT(*) AS users
FROM Gangnam_stops
GROUP BY stop_index1
ORDER BY time_start DESC;


-- Weather *
SELECT *
FROM Weather
LIMIT 1;

-- VIEW Weather_v
CREATE VIEW Weather_v AS
SELECT time_ as time
    , temperature
    , rain
    , windspeed
    , humidity
    , pressure
    , sunshine
    , snow
    , cloud
    , YEAR(time_) as year
    , MONTH(time_) as month
    , DAY(time_) as day
    , DAYOFWEEK(time_) as dayofweek
FROM Weather;


-- Check view Weather_v
SELECT *
FROM Weather_v
LIMIT 3;


-- JOIN Gangnam_stops & Weather
SELECT *
FROM Gangnam_stops as s
LEFT JOIN Weather_v as w
ON s.year = w.year
  AND s.month = w.month
  AND s.day = w.day
  AND s.dayofweek = w.dayofweek
LIMIT 10;


-- stopnum - count
SELECT stopnum AS ???????????????
  , count(*) AS ????????????
FROM Gangnam_stops
GROUP BY stopnum;


-- month - stopnum - count
SELECT stopnum AS ???????????????
  , month AS ?????????
  , count(*) AS ????????????
FROM Gangnam_stops
GROUP BY stopnum, month;


-- dayofweek - count
SELECT dayofweek AS ??????_?????????_1 , count(*) AS ??????????????????
FROM Gangnam_stops
GROUP BY dayofweek
ORDER BY ??????_?????????_1;


-- hour - count
SELECT hour AS ????????? , count(*) AS ?????????????????????
FROM Gangnam_stops
GROUP BY hour
ORDER BY hour;


-- weather
-- weather(temperature) - count
SELECT w.temperature AS ??????, COUNT(*) AS ??????????????????
FROM Gangnam_stops as s
LEFT JOIN Weather_v as w
ON s.year = w.year
  AND s.month = w.month
  AND s.day = w.day
  AND s.dayofweek = w.dayofweek
GROUP BY w.temperature;

-- weather(windspeed) - count
SELECT w.windspeed AS ??????, COUNT(*) AS ??????????????????
FROM Gangnam_stops as s
LEFT JOIN Weather_v as w
ON s.year = w.year
  AND s.month = w.month
  AND s.day = w.day
  AND s.dayofweek = w.dayofweek
GROUP BY w.windspeed;

-- weather(humidity) - count
SELECT w.humidity AS ??????, COUNT(*) AS ??????????????????
FROM Gangnam_stops as s
LEFT JOIN Weather_v as w
ON s.year = w.year
  AND s.month = w.month
  AND s.day = w.day
  AND s.dayofweek = w.dayofweek
GROUP BY w.humidity;

-- weather(pressure) - count
SELECT w.pressure AS ??????, COUNT(*) AS ??????????????????
FROM Gangnam_stops as s
LEFT JOIN Weather_v as w
ON s.year = w.year
  AND s.month = w.month
  AND s.day = w.day
  AND s.dayofweek = w.dayofweek
GROUP BY w.pressure;

-- weather(sunshine) - count
SELECT w.sunshine AS ?????????, COUNT(*) AS ?????????????????????
FROM Gangnam_stops as s
LEFT JOIN Weather_v as w
ON s.year = w.year
  AND s.month = w.month
  AND s.day = w.day
  AND s.dayofweek = w.dayofweek
GROUP BY w.sunshine;

-- weather(snow) - count
SELECT w.snow AS ??????, COUNT(*) AS ?????????????????????
FROM Gangnam_stops as s
LEFT JOIN Weather_v as w
ON s.year = w.year
  AND s.month = w.month
  AND s.day = w.day
  AND s.dayofweek = w.dayofweek
GROUP BY w.snow;

-- weather(cloud) - count
SELECT w.cloud AS ??????, COUNT(*) AS ??????????????????
FROM Gangnam_stops as s
LEFT JOIN Weather_v as w
ON s.year = w.year
  AND s.month = w.month
  AND s.day = w.day
  AND s.dayofweek = w.dayofweek
GROUP BY w.cloud;

-- weather(rain) - count
SELECT w.rain AS ?????????, COUNT(*) AS ?????????????????????
FROM Gangnam_stops as s
LEFT JOIN Weather_v as w
ON s.year = w.year
  AND s.month = w.month
  AND s.day = w.day
  AND s.dayofweek = w.dayofweek
GROUP BY w.rain;


-- Final dataset
SELECT s.count
  , s.month
  , s.day
  , s.dayofweek
  , stopnum
  , temperature
  , rain
  , windspeed
  , humidity
  , pressure
  , sunshine
  , snow
  , cloud
FROM (
  SELECT stop_index1 as stopnum
    , MONTH(time_start) as month
    , DAY(time_start) as day
    , DAYOFWEEK(time_start) as dayofweek
    , COUNT(*) as count
  FROM User
  WHERE (time_start >= '2021-03-01')
  GROUP BY month, day, stopnum, dayofweek
) AS s
LEFT JOIN Weather_v AS w
ON s.month = w.month
  AND s.day = w.day
  AND s.dayofweek = w.dayofweek
LIMIT 30;
