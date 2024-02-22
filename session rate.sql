use mavenfuzzyfactory;

select website_sessions.utm_content,
	count(distinct website_sessions.website_session_id) AS session,
    count(distinct orders.order_id) as orders,
    count(distinct orders.order_id)/count(distinct website_sessions.website_session_id)as session_to_orders_conver_rate

from website_sessions 
left join orders 
	on website_sessions.website_session_id=orders.website_session_id
where website_sessions.website_session_id between 1000 and 2000


group by 1

order by 2 desc