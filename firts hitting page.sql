
-- 1) find first page view for each session
-- 2) find url the customer saw fist page view

create temporary table first_pv
select 
		website_session_id,
		min(website_pageview_id) as website_sessionsfirst_pv
from website_pageviews
where created_at<'2012-06-12'
group by 1;

select 
		website_pageviews.pageview_url,
       count( first_pv.website_sessionsfirst_pv)

from first_pv
left join website_pageviews on first_pv.website_sessionsfirst_pv=website_pageviews.website_pageview_id
group by 1