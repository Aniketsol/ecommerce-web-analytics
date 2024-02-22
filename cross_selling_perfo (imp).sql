-- identify the relevant /cart page view and sessions


create temporary table sessions_carts
select 
case 
	when created_at <  '2013-09-25' then 'A. pre_cross_sell'
    when created_at >='2013-01-06' then 'B. post_cross_sell'
	else 'check_logic'
    end as time_period,
    website_session_id as cart_session_id,
    website_pageview_id as cart_pageview_id
    
from website_pageviews
where created_at between '2013-08-25' and '2013-10-25'	
	and pageview_url='/cart';
    
    
    
 
 create temporary table cart_seeing_another_page
 
select 
time_period,
cart_session_id,
min(website_pageviews.website_pageview_id) as pv_after_cart


from sessions_carts
left join website_pageviews
		on website_pageviews.website_session_id = sessions_carts.cart_session_id
        and website_pageviews.website_pageview_id>sessions_carts.cart_pageview_id

group by 1,2

having

		min(website_pageviews.website_pageview_id) is not null ;



create temporary table pre_post_session_orders

select 

time_period,
cart_session_id,
order_id,
items_purchased,
price_usd

from sessions_carts
inner join orders
	on sessions_carts.cart_session_id = orders.website_session_id;
    
    
    




select  

time_period,
count( distinct cart_session_id),
sum(clicked_another_page) as clickthroughs,
sum(clicked_another_page)/count( distinct cart_session_id) as cart_click_rate,
sum(placed_order) as placed_order,
sum(items_purchased) as items_purchased,
sum(items_purchased)/sum(placed_order) as items_per_order,
sum(price_usd)/sum(placed_order) as aov,
sum(price_usd)/count( distinct cart_session_id) as rev_per_session 


   
from(
select  

sessions_carts.time_period,
sessions_carts.cart_session_id,
case when cart_seeing_another_page.cart_session_id is null then 0 else 1 end as clicked_another_page,
case when pre_post_session_orders.order_id is null then 0 else 1 end as placed_order,
pre_post_session_orders.items_purchased,
pre_post_session_orders.price_usd

from sessions_carts 
left join cart_seeing_another_page
		ON sessions_carts.cart_session_id=cart_seeing_another_page.cart_session_id
left join pre_post_session_orders
		on sessions_carts.cart_session_id=pre_post_session_orders.cart_session_id
        
order by 1
) as all_data

group by time_period