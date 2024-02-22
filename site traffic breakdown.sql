select 
year(created_at),
month(created_at),
count(case when utm_campaign='nonbrand'then website_session_id else null end) as nonbrand,
count(case when utm_campaign='brand'then website_session_id else null end) as brand,
count(case when utm_campaign='brand'then website_session_id else null end)/count(case when utm_campaign='nonbrand'then website_session_id else null end) as conversion_percentage,
count(case when utm_campaign is null  and utm_source is null and http_referer is null then website_session_id else null end) as direct,
count(case when utm_campaign is null  and utm_source is null and http_referer is null then website_session_id else null end)/count(case when utm_campaign='nonbrand'then website_session_id else null end) as direct_pct_nonbrand,
count(case when  utm_source is null and http_referer in ('https://www.gsearch.com','https://www.bsearch.com') then website_session_id else null end) as organic,

count(case when  utm_source is null and http_referer in ('https://www.gsearch.com','https://www.bsearch.com') then website_session_id else null end)/count(case when utm_campaign='nonbrand'then website_session_id else null end) as organic_pct_nonbrand

from website_sessions
where created_at < '2012-12-23'
group by 1,2