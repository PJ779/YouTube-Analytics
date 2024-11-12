CREATE VIEW us_youtubers AS

  select left(name, CHARINDEX('@', NAME) - 1) AS channel_name,
          subscribers,
           views,
           total_videos
  from dbo.updated_youtube_data_us
  
/*
Data quality check
1) checking duplicates
2) row count
3) column count
4) column type
*/


SELECT channel_name, COUNT(*)
from dbo.us_youtubers
GROUP BY channel_name
HAVING count(*) > 1


SELECT COUNT(*) as no_of_rows
from dbo.us_youtubers

SELECT count(*) AS no_of_columns
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'us_youtubers'

SELECT COLUMN_NAME, DATA_TYPE 
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'us_youtubers'


--1) Declare variables
DECLARE @conversionRate FLOAT = 0.025;    --conversion rate is 2.5%
DECLARE @productCost FLOAT = 7.0;         ---product cost is 7.0
DECLARE @campaignCost FLOAT = 100000;      ---campaign cost is 100,000

with averageViewsPerVideo as (
  SELECT channel_name,
  total_videos,
  views, 
  subscribers,
  Cast(round((views/total_videos),0) AS int) AS average_viewers
  from dbo.us_youtubers
)
select TOP 3 channel_name, average_viewers,
average_viewers * @conversionRate as potential_units_sold_per_video,
average_viewers * @conversionRate * @productCost as potential_revenue_per_video,
(average_viewers * @conversionRate * @productCost) - @campaignCost as net_profit

from averageViewsPerVideo
ORDER by net_profit DESC


select channel_name, average_viewers,
average_viewers * @conversionRate as potential_units_sold_per_video,
average_viewers * @conversionRate * @productCost as potential_revenue_per_video,
(average_viewers * @conversionRate * @productCost) - @campaignCost as net_profit

from averageViewsPerVideo
where channel_name IN ('MrBeast ', 'T-Series ', 'Cocomelon - Nursery Rhymes ')
ORDER by net_profit DESC