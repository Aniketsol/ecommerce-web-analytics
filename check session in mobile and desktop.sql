select 
		min(date(ws.created_at)) as week_starts, 
		week(ws.created_at),
        count(distinct ws.website_session_id) as 'total sesion',
       count(case when device_type='desktop' then ws.website_session_id else null end )as 'total desktop session',
       count(case when device_type='mobile' then ws.website_session_id else null end )as 'total mobile session'
from website_sessions ws
left join orders o on ws.website_session_id=o.website_session_id
where ws.created_at<'2012-06-09' and ws.created_at>'2012-04-015'and utm_source='gsearch' and utm_campaign='nonbrand'
group by 2
