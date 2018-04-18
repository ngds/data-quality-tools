-- The Data Quality script reads current resource links from the database, runs a curl for each and inserts the results in the
-- NGDS_resource_quality table in the ckan database. These SQL commands provide reports for each type of error 

-- this is a sample - single record
with posgr as
(select p.id,p.title as packageTitle, s.title as sourcetitle, p.current, p.state,
 substring(r.url from '^(([^/]*/){3})') as surl, r.id as rid, r.url, r.description, r.extras, r.resource_type, r.cache_url 
 from package_revision p,harvest_object o, harvest_source s, resource_group_revision g, resource_revision r
where 
 	p.id = o.package_id and o.harvest_source_id = s.id and
    p.id = g.package_id and g.id = r.resource_group_id and
    o.current=true and
    p.current = true and r.current = true and r.state='active' and
    p.state='active' and p.revision_id=g.revision_id 
   
)
select * from posgr where id = '66735a73-f168-483d-a878-7f82f1c7cc2e'

-- April 17 - Initial execution with no response, then reprocessed on April 12. these are error records on second run

with posgr as
(select p.id,p.title as packageTitle, s.title as sourcetitle, p.current, p.state,
 substring(r.url from '^(([^/]*/){3})') as surl, r.id as rid, r.url, r.description, r.extras, r.resource_type, r.cache_url 
 from package_revision p,harvest_object o, harvest_source s, resource_group_revision g, resource_revision r
where 
 	p.id = o.package_id and o.harvest_source_id = s.id and
    p.id = g.package_id and g.id = r.resource_group_id and
    o.current=true and
    p.current = true and r.current = true and r.state='active' and
    p.state='active' and p.revision_id=g.revision_id 
   
)
select p.id, packagetitle,sourcetitle, surl as domain, rid, description, orig_url, http_status, http_content_length
from posgr p, ngds_resource_quality n 
where p.id = n.package_id and rid=n.resource_id and http_location = 'NONE-2'
and orig_url not like 'ftp%' and http_content_length < 10 --and http_status = '200'
order by 2


-- April 17 updated
-- 404 errors by harvest source 
with posgr as
(select p.id,p.title as packageTitle, s.title as sourcetitle, p.current, p.state,
 substring(r.url from '^(([^/]*/){3})') as surl, r.id as rid, r.url, r.description, r.extras, r.resource_type, r.cache_url 
 from package_revision p,harvest_object o, harvest_source s, resource_group_revision g, resource_revision r
where 
 	p.id = o.package_id and o.harvest_source_id = s.id and
    p.id = g.package_id and g.id = r.resource_group_id and
    o.current=true and
    p.current = true and r.current = true and r.state='active' and
    p.state='active' and p.revision_id=g.revision_id 
)
select p.id, packagetitle,sourcetitle, surl as domain, rid, description, orig_url, http_status, http_content_length
from posgr p, ngds_resource_quality n 
where p.id = n.package_id and rid=n.resource_id and n.http_status = '404' and to_char(n.validation_date,'YYYY-MM-DD') = '2018-04-11' order by 2 desc


-- April 17 - non responsive links with harvest source and package info 
-- These are SMU links that originally where 405 errors, after link reporcessed, they responded with 200, but not with valid data
with posgr as
(select p.id,p.title as packageTitle, s.title as sourcetitle, p.current, p.state,
 substring(r.url from '^(([^/]*/){3})') as surl, r.id as rid, r.url, r.description, r.extras, r.resource_type, r.cache_url 
 from package_revision p,harvest_object o, harvest_source s, resource_group_revision g, resource_revision r
where 
 	p.id = o.package_id and o.harvest_source_id = s.id and
    p.id = g.package_id and g.id = r.resource_group_id and
    o.current=true and
    p.current = true and r.current = true and r.state='active' and
    p.state='active' and p.revision_id=g.revision_id 
)
select p.id, packagetitle,sourcetitle, surl, rid, orig_url, validation_date,http_status, http_content_length
from posgr p, ngds_resource_quality n 
where p.id = n.package_id and rid=n.resource_id and to_char(n.validation_date,'YYYY-MM-DD') = '2018-04-12' and
http_location <> 'NONE-2' AND http_content_length <10 and orig_url not like 'ftp%'  order by 1 


-- FTP Broken Links - updated April 17
with posgr as
(select p.id,p.title as packageTitle, s.title as sourcetitle, p.current, p.state,
 substring(r.url from '^(([^/]*/){3})') as surl, r.id as rid, r.url, r.description, r.extras, r.resource_type, r.cache_url 
 from package_revision p,harvest_object o, harvest_source s, resource_group_revision g, resource_revision r
where 
 	p.id = o.package_id and o.harvest_source_id = s.id and
    p.id = g.package_id and g.id = r.resource_group_id and
    o.current=true and
    p.current = true and r.current = true and r.state='active' and
    p.state='active' and p.revision_id=g.revision_id 
)
select p.id, packagetitle,sourcetitle, surl, rid, orig_url, validation_date,http_status, http_content_length
--select p.sourcetitle, count(p.sourcetitle)
from posgr p, ngds_resource_quality n 
where p.id = n.package_id and rid=n.resource_id and
 orig_url like 'ftp%' and http_content_length  < 10 
 order by 1
 group by 1
 
 
