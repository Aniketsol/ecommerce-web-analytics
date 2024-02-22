
-- finding the minimum website pageview


select website_pageviews.website_session_id,
		min(website_pageviews.website_pageview_id) as min_pageview_id

from website_pageviews
	inner join website_sessions 
    on website_sessions.website_session_id = website_pageviews.website_session_id and
    website_sessions.created_at between '2014-01-01' and '2014-02-01'
group by 1 ;


-- created temporary table

create temporary table first_pageviews_demo
select website_pageviews.website_session_id,
		min(website_pageviews.website_pageview_id) as min_pageview_id



from website_pageviews
	inner join website_sessions 
    on website_sessions.website_session_id = website_pageviews.website_session_id and
    website_sessions.created_at between '2014-01-01' and '2014-02-01'
group by 1 ;

-- we wil bring in the landing page to  each sessions

create temporary table sessions_landing_page_demo
select  
first_pageviews_demo.website_session_id,
website_pageviews.pageview_url as landing_page


from first_pageviews_demo
left join website_pageviews 
	on website_pageviews.website_pageview_id = first_pageviews_demo.min_pageview_id;
    
    
    
    -- bounced session
create temporary table bounced_session_only
select 
	sessions_landing_page_demo.website_session_id,
    sessions_landing_page_demo.landing_page,
    count(website_pageviews.website_pageview_id) as count_of_pages_viewed
from sessions_landing_page_demo

left join website_pageviews
	on sessions_landing_page_demo.website_session_id = website_pageviews.website_session_id
group by  1,2 

having 
	count(website_pageviews.website_pageview_id) = 1;



-- bounced session id

select 
		sessions_landing_page_demo.website_session_id,
        sessions_landing_page_demo.landing_page,
		bounced_session_only.website_session_id as bounced_session_id
        
from sessions_landing_page_demo
left join bounced_session_only
		on sessions_landing_page_demo.website_session_id = bounced_session_only.website_session_id
order by 1
        