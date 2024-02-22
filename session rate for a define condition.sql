select 
	ws.utm_source,ws.utm_campaign,ws.http_referer,
    count(distinct ws.website_session_id) as no_of_session,
    count(distinct o.order_id) as orders,
    count(distinct o.order_id)/count(distinct ws.website_session_id) as session_to_order_conv_rate
from website_sessions ws
left join orders o
	on o.website_session_id=ws.website_session_id
where ws.created_at<'2012-04-12'and
	ws.utm_source='gsearch' and ws.utm_campaign='nonbrand'
group by 1,2,3
order by 4 desc
