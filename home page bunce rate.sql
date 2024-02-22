
create temporary table first_pageviews
select 
website_session_id,
min(website_pageview_id) as min_pageview_id
from website_pageviews
where created_at < '2012-06-14'
group by 1;



create temporary table session_landing_page
select 
first_pageviews.website_session_id,
 website_pageviews.pageview_url as landing_page
 
from first_pageviews
left join website_pageviews on first_pageviews.min_pageview_id= website_pageviews.website_pageview_id
where website_pageviews.pageview_url='/home';


-- bounced session 
create temporary table bounced_session
select 
session_landing_page.website_session_id,
session_landing_page.landing_page,
count(website_pageviews.website_pageview_id)

from session_landing_page
left join website_pageviews 
		on website_pageviews.website_session_id = session_landing_page.website_session_id
 group by 1,2 
 having count(website_pageviews.website_pageview_id)=1;
 
 
select 
count(session_landing_page.website_session_id),
-- session_landing_page.landing_page,
count(bounced_session.website_session_id) as bounced_sessions_id,
count(bounced_session.website_session_id)/count(session_landing_page.website_session_id) as bunce_rate
from session_landing_page
left join bounced_session 
	on session_landing_page.website_session_id = bounced_session.website_session_id
