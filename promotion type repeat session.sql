select 

case
	when utm_source is null and http_referer in ('https://www.gsearch.com','https://www.bsearch.com') then 'organic_search'
    when utm_campaign = 'nonbrand' then 'paid_nonbrand'
    when utm_campaign = 'brand' then 'paid_brand'
    when utm_source  is null and http_referer is null then 'direct_typein'
    when utm_source = 'socialbook' then 'paid_social'
end as channle_grp,

count(case when is_repeat_session=0 then website_session_id else null end) as new_sessions,
count(case when is_repeat_session=1 then website_session_id else null end) as repeat_session

from website_sessions
where created_at < '2014-11-05'
		and created_at>'2014-01-01'
group by 1
