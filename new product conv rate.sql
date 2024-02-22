select 
year(website_sessions.created_at) as yr,
month(website_sessions.created_at) as mo,
count(website_sessions.website_session_id) as session,
count(distinct orders.order_id) as orders,
count(distinct orders.order_id)/count(website_sessions.website_session_id) as conv_rate,
count(case when primary_product_id=1 then order_id else null end) as 1_st_product,
count(case when primary_product_id=2 then order_id else null end) as 2_st_product

 from website_sessions
 left join orders
			on  orders.website_session_id=website_sessions.website_session_id
 where website_sessions.created_at between '2012-04-01' and '2013-04-05'
 group by 1,2