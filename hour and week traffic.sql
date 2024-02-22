

select 
hr,
avg(website_sessions) as avg_session,
round(avg( case when wkday = 0 then website_sessions else null end),1) as monday,
round( avg( case when wkday = 1 then website_sessions else null end),1) as tue,
avg( case when wkday = 2 then website_sessions else null end) as wed,
avg( case when wkday = 3 then website_sessions else null end) as thurs,
avg( case when wkday = 4 then website_sessions else null end) as fri,
avg( case when wkday = 5 then website_sessions else null end) as sat,
avg( case when wkday = 6 then website_sessions else null end) as sun


from(
select 
date(created_at) as created_at ,
hour(created_at) hr,
weekday(created_at) as wkday,
count(distinct website_session_id) as website_sessions
from website_sessions
where created_at between '2012-09-15' and '2012-11-15'
group by 1,2,3

) as daily_hourly_sessions
group by 1