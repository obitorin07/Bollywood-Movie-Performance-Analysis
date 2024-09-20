select * from bollywood;
use projects;
select * from bollywood;

-- Identify which movie genres generate the highest and lowest average revenue to inform decisions on future genre investments.
-- :
-- o	Calculate total and average revenue for each genre.
-- o	Rank genres based on profitability.
-- o	Identify high-performing and underperforming genres.

SELECT GENRE, 
	SUM(REVENUE_INR) AS TOTAL_REVENUE,
    ROUND(AVG(REVENUE_INR) ,2) AS AVERAGE_REVENUE,
    SUM(PROFIT) AS PROFIT,
    RANK() OVER(ORDER BY SUM(PROFIT) DESC) AS RANKS
FROM BOLLYWOOD
GROUP BY GENRE 


-- Evaluate how different release periods, such as holiday seasons or regular periods, influence movie revenue. This will guide optimal release timing for maximizing box office revenue.

-- o	Compare average revenue for holiday-released movies versus non-holiday releases.
-- o	Provide insights on the best periods for movie releases to maximize profitability.

select
RELEASE_PERIOD,
ROUND(AVG(REVENUE_INR)) AS AVERAGE_REVENUE,
SUM(PROFIT) AS TOTAL_PROFIT ,
COUNT(*) AS NO_MOVIES ,
(100 * COUNT(*) / (SELECT COUNT(*) FROM BOLLYWOOD)) AS CONTRIBUTION
FROM BOLLYWOOD
GROUP BY RELEASE_PERIOD;

-- LETS FIGURE WHICH DAY AND WHAT KIND MOVIE GIVE PROFIT
SELECT
GENRE,
RELEASE_PERIOD,
ROUND(AVG(REVENUE_INR)) AS AVERAGE_REVENUE,
SUM(PROFIT) AS TOTAL_PROFIT ,
COUNT(*) AS NO_MOVIES ,
(100 * COUNT(*) / (SELECT COUNT(*) FROM BOLLYWOOD)) AS CONTRIBUTION
FROM BOLLYWOOD
GROUP BY GENRE , RELEASE_PERIOD
ORDER BY TOTAL_PROFIT DESC;
 

-- 3.	Franchise vs. Standalone Movie Performance
-- Objective:
-- Compare the financial performance of franchise movies against standalone films to assess the benefits of producing sequels or franchise films.
-- Tasks:
-- o	Calculate the average revenue and profitability of franchise movies.
-- o	Compare with standalone movies to measure financial impact.
-- o	Identify trends or patterns that may justify investments in franchise films.

select 
is_franchise,
release_period ,
sum(revenue_inr) as Total_Revenue , 
round(avg(revenue_inr)) as Average_Revenue , 
sum(profit) as Total_Profit ,
round(avg(profit)) as Total_Profit,
count(*) as no_of_movies
from bollywood
group by is_franchise ,  release_period;



-- 4.	Star Power vs. New Talent
-- Objective:
-- Analyze the impact of lead actors, directors, and music directors (established stars vs. new talent) on movie revenue.
-- :
-- o	Compare the revenue of movies featuring established stars versus new talent.
-- o	Assess the impact of experienced versus new directors and music directors on revenue generation.
-- o	Provide insights into whether it’s financially viable to invest in new talent.



select
(case when new_actor = 'Yes' then 'New_actor' else 'Experienced_Actor' end) as Actors,
(case when new_director ='Yes' then "New Director" else "Experienced Director" end) as Directors,
(case when new_music_director ='Yes' then "New Music Director" else "Experienced Music Director" end) as Music_Directos,
sum(revenue_inr) as revenue
from bollywood
group by Actors , Directors ,Music_Directos
order by revenue desc



-- Objective:
-- Examine the financial performance of remakes compared to original movies to determine whether remakes offer a profitable business model.
-- :
-- o	Calculate the total and average revenue for remakes and original movies.
-- o	Compare the ROI of remakes versus original films.
-- o	Identify patterns that indicate whether remakes or original content generate higher returns.

SELECT 
(CASE WHEN  is_remake = 'No' Then "Original Movie"  else "Remake Movie" end) as Movie_Type,
sum(revenue_inr) as Total_Revenue_Generated,
avg(revenue_inr) as Average_Revenue_Generated,
((sum(revenue_inr) - sum(budget_inr))/ sum(budget_inr)) *100 as ROI
FROM 
BOLLYWOOD
GROUP BY Movie_Type
order by Total_Revenue_Generated desc 


-- 5.	Budget vs. Revenue Analysis
-- Objective:
-- Assess the relationship between the production budget and box office revenue. This will help in evaluating financial efficiency and ROI.
-- o	Calculate profit for each movie.
-- o	Compute the ROI for each movie.

SELECT
MOVIE_NAME AS MOVIE,
Budget_inr as Budget,
Revenue_inr  as Revenue ,
PROFIT , -- (REVENUE_inr - BUDGET_INr)
concat(round(((SUM(REVENUE_INR) - SUM(BUDGET_INR))/ SUM(BUDGET_INR))*100 ,2),"%")AS ROI
from bollywood
group by MOVIE , Budget ,Revenue , PROFIT;