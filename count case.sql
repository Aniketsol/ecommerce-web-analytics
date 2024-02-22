select primary_product_id, 
	    count(case when items_purchased = 1 then order_id else null end ) as single_items_orders,
        count(case when items_purchased = 2 then order_id else null end) as double_items_orders
	from orders

where order_id between 31000 and 32000

group by 1