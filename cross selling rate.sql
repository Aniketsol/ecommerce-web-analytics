
select 
orders.primary_product_id,
count(distinct orders.order_id) as orders,
count(case when order_items.product_id=1 then orders.order_id else null end) as x_product1,
count(case when order_items.product_id=2 then orders.order_id else null end) as x_product2,
count(case when order_items.product_id=3 then orders.order_id else null end) as x_product3



from orders 
left join order_items
		on orders.order_id = order_items.order_id
        and order_items.is_primary_item = 0 

where orders.order_id between 10000 and 11000        

group by 1
        