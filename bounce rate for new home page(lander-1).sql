select
min(created_at) as first_created_at,
min(website_pageview_id) as first_pageview_id
from website_pageviews
where pageview_url = '/lander-1' and created_at is not null;



create temporary table first_test_pv
select 
website_pageviews.website_session_id,
min(website_pageviews.website_pageview_id) as min_pageview_id
from website_pageviews
inner join website_sessions
		on website_pageviews.website_session_id=website_sessions.website_session_id
        and website_sessions.created_at<'2012-07-28' 
        and website_pageviews.website_pageview_id>25304 
        and utm_source = 'gsearch'
        and utm_campaign = 'nonbrand'
group by 1;



-- landing page

create temporary table non_brand_lpg
select 
first_test_pv.website_session_id,
website_pageviews.pageview_url as landing_page

from first_test_pv
left join website_pageviews on website_pageviews.website_pageview_id=first_test_pv.min_pageview_id

where website_pageviews.pageview_url in('/home','/lander-1');

-- bounded session
create temporary table bounsed_session
select 
non_brand_lpg.website_session_id,
non_brand_lpg.landing_page,
count(website_pageviews.website_pageview_id)

from non_brand_lpg
left join website_pageviews
		on website_pageviews.website_session_id=non_brand_lpg.website_session_id
group by 1,2
having count(website_pageviews.website_pageview_id)=1;


select 
count(non_brand_lpg.website_session_id) as website_session,
non_brand_lpg.landing_page as landing_page,
count(bounsed_session.website_session_id) as bounced_session,
count(bounsed_session.website_session_id)/count(non_brand_lpg.website_session_id)  as bounce_rate

from non_brand_lpg
left join bounsed_session
		on non_brand_lpg.website_session_id = bounsed_session.website_session_id
group by 2

