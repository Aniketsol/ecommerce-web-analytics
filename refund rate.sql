select  

year(order_items.created_at),
month(order_items.created_at),
count( case when order_items.product_id=1 then order_items.order_item_id else null end) as p1_order,

count(distinct case when product_id=1 then order_item_refunds.order_item_id else null end)/count( case when order_items.product_id=1 then order_items.order_item_id else null end) as p1_refund_rt,

count( case when order_items.product_id=2 then order_items.order_item_id else null end) as p2_order,

count(distinct case when product_id=2 then order_item_refunds.order_item_id else null end)/count( case when order_items.product_id=2 then order_items.order_item_id else null end) as p2_refund_rt,

count( case when order_items.product_id=3 then order_items.order_item_id else null end) as p3_order,

count(distinct case when product_id=3 then order_item_refunds.order_item_id else null end)/count( case when order_items.product_id=3 then order_items.order_item_id else null end) as p3_refund_rt,

count( case when order_items.product_id=4 then order_items.order_item_id else null end) as p4_order,
count(distinct case when product_id=4 then order_item_refunds.order_item_id else null end)/count( case when order_items.product_id=4 then order_items.order_item_id else null end) as p4_refund_rt

from order_items
left join order_item_refunds
		on order_item_refunds.order_item_id = order_items.order_item_id
where order_items.created_at < '2014-10-15'
group by 1,2