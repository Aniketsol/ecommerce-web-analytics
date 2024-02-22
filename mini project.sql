
/* 
1) Trend for gsearch and orders placed per session 
*/
select 
year(website_sessions.created_at) as yr,
month(website_sessions.created_at) as month,
count(distinct website_sessions.website_session_id) as sessions,
count(distinct orders.order_id) as orders,
count(distinct orders.order_id)/count(distinct website_sessions.website_session_id)  as order_per_session_rate
from website_sessions
left join orders
	on website_sessions.website_session_id=orders.website_session_id
where website_sessions.utm_source='gsearch'
		and website_sessions.created_at<'2012-11-27'
group by 1,2;


/*
same as above but seperate gsearch by brand and nonbrand campaigns
*/

select 
year(website_sessions.created_at) as yr,
month(website_sessions.created_at) as month,
website_sessions.utm_campaign,
count(distinct website_sessions.website_session_id) as sessions,
count(distinct orders.order_id) as orders,
count(distinct orders.order_id)/count(distinct website_sessions.website_session_id)  as order_per_session_rate
from website_sessions
left join orders
	on website_sessions.website_session_id=orders.website_session_id
where website_sessions.utm_source='gsearch'
		and website_sessions.utm_campaign in ('brand','nonbrand')
		and website_sessions.created_at<'2012-11-27'
group by 1,2,3;

/*
for Gsearch nonbrand split it into device type 
*/

select 
year(website_sessions.created_at) as yr,
month(website_sessions.created_at) as month,
count(distinct case when device_type='desktop' then website_sessions.website_session_id else null end) as desktop_sessions,
count(distinct case when device_type='desktop' then orders.order_id else null end) as desktop_orders,
count(distinct case when device_type='mobile' then website_sessions.website_session_id else null end) as mobile_sessions,
count(distinct case when device_type='mobile' then orders.order_id else null end) as mobile_orders
from website_sessions
left join orders 
	on website_sessions.website_session_id=orders.website_session_id
where website_sessions.utm_source='gsearch'
group by 1,2;

/*
monthly trend for gsearch, alongside monthly trends for each of our other channels
*/

select distinct
utm_source,
utm_campaign,
http_referer
from website_sessions
where created_at < '2012-11-27';

select 
year(website_sessions.created_at) as yr,
month(website_sessions.created_at) as month,
count(distinct case when utm_source = 'gsearch'then website_sessions.website_session_id else null end ) as gsearch_paid_session,
count(distinct case when utm_source = 'bsearch'then website_sessions.website_session_id else null end ) as bsearch_paid_session,
count(distinct case when utm_source is null and http_referer is not null then website_sessions.website_session_id else null end) as organic_search_session,
count(distinct case when utm_source is null and http_referer is null then website_sessions.website_session_id else null end) as direct_type_in_session


from website_sessions
left join orders 
	on website_sessions.website_session_id=orders.website_session_id
where website_sessions.created_at<'2012-11-27'

group by 1,2;



/*
session to order conversion rate for 8 months
*/

select 
year(website_sessions.created_at),
month(website_sessions.created_at),
count(distinct website_sessions.website_session_id) as sessions,
count(distinct orders.order_id) as orders,
count(distinct orders.order_id)/count(distinct website_sessions.website_session_id) as sessions_to_order_rate

from website_sessions
left join orders 
		on orders.website_session_id=website_sessions.website_session_id
where website_sessions.created_at < '2012-11-27'
group by 1,2;


/*
6.	For the gsearch lander test, please estimate the revenue that test earned us 
(Hint: Look at the increase in CVR from the test (Jun 19 – Jul 28), and use 
nonbrand sessions and revenue since then to calculate incremental value)
*/ 


select 
min(website_pageview_id) as first_test_pv
from website_pageviews
where pageview_url ='/lander-1';


create temporary table first_pv
select 
website_sessions.website_session_id,
min(website_pageviews.website_pageview_id) as landing_page
from  website_pageviews
left join website_sessions 
		on website_sessions.website_session_id=website_pageviews.website_session_id
where website_sessions.created_at < '2012-07-28'
		and website_sessions.utm_source='gsearch'
		and website_sessions.utm_campaign='nonbrand'
        and website_pageviews.website_pageview_id >= 23504
group by 1;

create temporary table landing_page
select 
first_pv.website_session_id,
website_pageviews.pageview_url

from first_pv
left join website_pageviews
		on first_pv.landing_page=website_pageviews.website_pageview_id
where website_pageviews.pageview_url in ('/home','/lander-1');

select  
landing_page.pageview_url,
count(distinct landing_page.website_session_id),
count(distinct orders.order_id),
count(distinct orders.order_id)/count(distinct landing_page.website_session_id) as conv_rate
from landing_page
left join orders
		on landing_page.website_session_id=orders.website_session_id
group by 1;



/*
7.	For the landing page test you analyzed previously, it would be great to show a full conversion funnel 
from each of the two pages to orders. You can use the same time period you analyzed last time (Jun 19 – Jul 28).
*/


CREATE TEMPORARY TABLE session_level_flagged

select 
website_session_id,
max(homepage) as homepage,
max(lander) as lander,
max(products) as products,
max(mrfuzzy) as mrfuzzy,
max(cart_page) as cart,
max(shipping) as shipping,
max(billing) as billing,
max(thank_you) as thankyou
from(
select 
website_sessions.website_session_id,
website_pageviews.pageview_url,
case when pageview_url='/home' then 1 else 0 end as homepage,
case when pageview_url='/lander-1' then 1 else 0 end as lander,
case when pageview_url='/products' then 1 else 0 end as products,
case when pageview_url='/the-orignal-mr-fuzzy' then 1 else 0 end as mrfuzzy,
case when pageview_url='/cart' then 1 else 0 end as cart_page,
case when pageview_url='/shipping' then 1 else 0 end as shipping,
case when pageview_url='/billing' then 1 else 0 end as billing,
case when pageview_url='/thank-you-for-your-order' then 1 else 0 end as thank_you

from website_sessions
left join website_pageviews 
		on website_pageviews.website_session_id=website_sessions.website_session_id
where website_sessions.created_at <'2012-07-28' 
and website_sessions.created_at> '2012-06-19'
				and website_sessions.utm_source='gsearch'
                and website_sessions.utm_campaign='nonbrand'

) as funnel
group by website_session_id;


SELECT
	CASE 
		WHEN homepage = 1 THEN 'saw_homepage'
        WHEN lander = 1 THEN 'saw_custom_lander'
        ELSE 'uh oh... check logic' 
	END AS segment, 
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN products = 1 THEN website_session_id ELSE NULL END) AS to_products,
    COUNT(DISTINCT CASE WHEN mrfuzzy = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN billing= 1 THEN website_session_id ELSE NULL END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM session_level_flagged 
GROUP BY 1;


/*
8.	I’d love for you to quantify the impact of our billing test, as well. Please analyze the lift generated 
from the test (Sep 10 – Nov 10), in terms of revenue per billing page session, and then pull the number 
of billing page sessions for the past month to understand monthly impact.
*/ 


select 
pageview_url,
count(distinct website_session_id),
sum(price_usd)/count(distinct website_session_id) as revenue_per_billing_page
from(

select 
website_pageviews.website_session_id,
website_pageviews.pageview_url,
orders.order_id,
orders.price_usd
from website_pageviews
left join orders
		on orders.website_session_id=website_pageviews.website_session_id
where website_pageviews.created_at <'2012-11-10'
		and website_pageviews.created_at>'2012-09-10'
        and website_pageviews.pageview_url in ('/billing','/billing-2')
) as billing_page_and_order

group by 1;




