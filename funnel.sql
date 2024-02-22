
create temporary table session_level_made_it_flags_demo

select 

website_session_id,
max(products_page) as product_made_it,
max(mrfuzzy_page) as mrfuzzy_made_it,
max(cart_page) as cart_made_it


from(

select 
website_sessions.website_session_id,
website_pageviews.pageview_url,
website_pageviews.created_at as pageview_created_at,
case when pageview_url = '/products' then 1 else 0 end as products_page,
case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
case when pageview_url = '/cart' then 1 else 0 end as cart_page
from website_sessions
left join website_pageviews 
		on website_sessions.website_session_id=website_pageviews.website_session_id
where website_sessions.created_at between '2014-01-01' and '2014-02-01'
        and website_pageviews.pageview_url 
				in ('/lander-2','/products','/the-original-mr-fuzzy','/cart')
order by  1,2

) as pageview_lvl

group by 1;



select 
	count(distinct website_session_id) as sessions,
    count(distinct case when product_made_it = 1 then website_session_id else null end )
			/count(distinct website_session_id) as clicked_to_products ,
	count(distinct case when mrfuzzy_made_it=1 then website_session_id else null end ) 
           /count(distinct case when product_made_it = 1 then website_session_id else null end ) as clicked_to_mrfuzzy,
	count(distinct case when cart_made_it=1 then website_session_id else null end ) 
          /count(distinct case when mrfuzzy_made_it=1 then website_session_id else null end ) as to_cart
    
    from session_level_made_it_flags_demo











