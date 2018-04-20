-- Duplicate GUID check
with pos as
(select p.id,p.title as packageTitle, s.title as sourcetitle, o.guid, o.gathered, p.current, p.state
 from package_revision p,harvest_object o, harvest_source s
where 
 	p.id = o.package_id and o.harvest_source_id = s.id and
    o.current=true and
    p.current = true and 
    p.state='active' 
   
), countguid as (
	select guid, count(guid) as cg from pos group by guid
)
--select * from countguid order by guid desc
select * from pos p, countguid c where p.guid=c.guid and c.cg > 1

-- Duplicate titles
with pos as
(select p.id,p.title as packageTitle, s.title as sourcetitle, o.guid, o.gathered, p.current, p.state
 from package_revision p,harvest_object o, harvest_source s
where 
 	p.id = o.package_id and o.harvest_source_id = s.id and
    o.current=true and
    p.current = true and 
    p.state='active' 
   
), countguid as (
	select packageTitle, count(packageTitle) as cg from pos group by packageTitle
), pg as (
--select * from countguid order by guid desc
select * from pos p, countguid c where p.packageTitle=c.packageTitle and c.cg > 1 )
select sourcetitle, count(sourcetitle) from pg group by sourcetitle

select * from ngds_traffic_statistics
