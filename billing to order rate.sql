select 
min(date(created_at)),
website_pageview_id

from website_pageviews
where pageview_url='/billing-2'
group by 2;



select
pageview_url,
count(distinct website_session_id) as sessions,
count(distinct order_id) as orders_made,
count(distinct order_id)/count(distinct website_session_id) as billing_to_order_rate
from (
select  
website_pageviews.website_session_id,
website_pageviews.pageview_url,
orders.order_id
from website_pageviews
left join orders
	on orders.website_session_id= website_pageviews.website_session_id

where website_pageviews.created_at < '2012-11-10'
	and website_pageviews.website_pageview_id > 53550
    and website_pageviews.pageview_url in ('/billing','/billing-2')
) as pageview

group by pageview_url