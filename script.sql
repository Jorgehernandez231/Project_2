use project_2;
-- Scoring by region
select r.region, avg(h.score) as happines_score_average, avg(h.gdp_per_capita) as gdp_p_capita_average, avg(h.corruption) as per_corruption_average, avg(h.freedom) as freedom_average, avg(h.social_support) as social_support_average, avg(h.generosity) as generosity_avg
from region as r 
join country as c
on r.region_id = c.region_id
join happiness as h
on c.country_id = h.country_id
group by r.region 
order by happines_score_average desc;

-- 
select r.region, avg(h.score) as happines_score_average, avg(h.corruption) as per_corruption_average, avg(h.freedom) as freedom_average
from region as r 
join country as c
on r.region_id = c.region_id
join happiness as h
on c.country_id = h.country_id
group by r.region 
order by happines_score_average desc;

create temporary table region_avg as
select r.region, avg(h.score) as happines_score_average, avg(h.gdp_per_capita) as gdp_p_capita_average, avg(h.corruption) as per_corruption_average, 
avg(h.freedom) as freedom_average, avg(h.social_support) as social_support_average, avg(h.generosity) as generosity_avg
from region as r 
join country as c
on r.region_id = c.region_id
join happiness as h
on c.country_id = h.country_id
group by r.region 
order by happines_score_average desc;

select *
from region_avg;


with cte_region as (
SELECT *,
  AVG(gdp_p_capita_average )   OVER (PARTITION BY region) +
  AVG(social_support_average )   OVER (PARTITION BY region) +
  AVG(generosity_avg )       OVER (PARTITION BY region) +
  AVG(freedom_average )          OVER (PARTITION BY region) -
  AVG(per_corruption_average )       OVER (PARTITION BY region)     AS composite_sum
FROM region_avg AS t
)

select region, happines_score_average, composite_sum,
	avg(happines_score_average + composite_sum) over (PARTITION BY region)
from cte_region;
