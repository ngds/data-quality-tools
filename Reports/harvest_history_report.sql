/* NGDS HAREST HISTORY REPORT
   Provides dates and count for each active harvest source by date
   G. Hudman
   May 4, 2018
*/

with hc as (
	select 
	count(case when state = 'COMPLETE' then id end) as COMPLETE, 
	count(case when state = 'WAITING' then id end) as WAIT, 
	count(case when state = 'IMPORT' then id end) as IMP, 
	count(case when state = 'ERROR' then id end) as ERR, 
	harvest_job_id as ojid, harvest_source_id as osid
	from harvest_object 
	group by harvest_job_id, harvest_source_id, state
), hc_gp as (
	select sum(COMPLETE) as complete, 
		sum(WAIT) as wait, 
	    sum(IMP) as imported, 
	    sum(ERR) as errors, 
		ojid, osid 
	from hc
	group by ojid, osid
), hs as (
	select s.title, 
		s.url, 
		j.created, 
		j.status, 
		s.id as sid, 
		j.id as jid
	from harvest_source s, harvest_job j
	where s.id = j.source_id and 
		s.active=true 
)
select title, 
       url, 
	   created as run_date,
	   status as job_status,
	   complete as count_success,
	   wait as count_wait,
	   imported as count_import,
	   errors as count_error
    from hc_gp right join hs 
    	ON hs.jid = hc_gp.ojid and hs.sid = hc_gp.osid
	order by title, 
			 run_date desc





