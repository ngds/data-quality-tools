/* these dups are based on title and resource urls
   GH - 11/13/2015 */
with pack_ext as (
select 	package.id, 
	package.title, 
	package.notes,
	package.state,
	package.metadata_modified,
	package_extra.value as pe_guid
from package_extra, package 
where 	package_id = package.id and
	package.state = 'active' and 
	package_extra.state = 'active' and 
	key = 'guid'
),
harvest as
(select o.guid as hguid, 
	o.state, 
	o.package_id as opackid, 
	o.import_finished,
	o.metadata_modified_date,
	s.title as src_title, 
	s.url as surl, 
	s.type,
	e.value as status
from 	harvest_object o, 
	harvest_source s, 
	harvest_object_extra e
where o.harvest_source_id = s.id and 
      o.id = e.harvest_object_id and
      o.report_status = 'added' --current = true and s.active = true
),
titleCount as (
	select title, tc from (
		select title, count(id) as tc
		from package 
		where state = 'active' 
		group by title) pc
	where tc > 1 
),
 package_dups as (
select 	pack_ext.id, 
	pack_ext.title, 
	notes, 
	pe_guid, 
	import_finished,
	metadata_modified, 
	src_title,
	titleCount.tc
from pack_ext, titleCount, harvest
where pack_ext.title = titleCount.title and
      pack_ext.id = harvest.opackid
order by pack_ext.title),
-- resource quereies
resrc as (
select package_id, 
	url, 
	position, 
	name, 
	created
	from resource r, resource_group g 
where r.resource_group_id = g.id and 
	r.state = 'active'
), rescount as (
   select package_id, 
   max(position) + 1 as resource_count 
   from resrc
   group by package_id
), resgrp as (
select 	c.package_id as packid, 
        p.title,
	r.url, 
	c.resource_count 
	from rescount c, resrc r, package p
	where c.package_id = r.package_id and
	      c.package_id = p.id
),
res_dups as (
        select * from (
		select title, url as durl, count(packid) dup_count
		from resgrp
		group by title, url 
		) iq 
	where  
	dup_count > 1 		
),
res_final as (
select * from res_dups, resgrp 
where res_dups.title = resgrp.title and
      res_dups.durl = resgrp.url
)
select  package_dups.id as package_id,
        package_dups.title as title,
        package_dups.notes as notes,
        pe_guid as guid,
        import_finished,
        metadata_modified,
        src_title as harvests_source,
        res_final.url as resource_url,
        url as resource_url,
        dup_count as resource_duplicates,
        tc as title_duplicates
 from 
res_final, package_dups where
res_final.packid = package_dups.id
order by
package_dups.title
 
  limit 10


limit 10




	select package_dups.title, 
		url, 
		count(id) dup_count
	from package_dups, resgrp
	where id = packid
	group by package_dups.title, url 


select * from harvest_object where package_id in (
select id from package where title = '03-05 Hz Apparent Resistivity Reconnaissance MapColado Hot Springs Pershing County, Nevada') 

with
resrc as (
select package_id, 
	url, 
	position, 
	name, 
	created
	from resource r, resource_group g 
where r.resource_group_id = g.id and 
	r.state = 'active'
), rescount as (
   select package_id, 
   max(position) + 1 as resource_count 
   from resrc
   group by package_id
)
select * from rescount c, resrc r where c.package_id = r.package_id limit 100



select package_id, max(position) + 1 as resource_count from 
(select package_id, 
	url, 
	position, 
	name, 
	created
	from resource r, resource_group g 
where r.resource_group_id = g.id and 
	r.state = 'active') sq
group by package_id
limit 10







	 and
	g.package_id = '294ff019-4737-40c0-afc5-7983e08b9c0c'





select * from package where id = '294ff019-4737-40c0-afc5-7983e08b9c0c'
