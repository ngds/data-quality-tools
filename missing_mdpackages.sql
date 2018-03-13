/* the mdpackage element in package_extra is an essential NGDS data element. 
*/
with pid as (
select p.id as pid 
from package p, package_extra e 
where p.id = e.package_id and e.key = 'md_package'),
pj as (
select * 
from package left outer join  pid on (id = pid)  ),
hosrc as (
select package_id, o.import_finished as impfin, o.guid as guid, s.title 
from harvest_object o, harvest_source s 
where o.harvest_source_id = s.id
), midP as (
select pj.id as package_id, guid, pj.title as ptitle, pj.state, hosrc.title as srctitle, impfin
from pj, hosrc 
where pj.id = hosrc.package_id and pid is null order by impfin)
select * from midP where srctitle = '{{source_title}}'

/* Option end sql */
-- select * from midP

-- select count(*), srctitle from midP group by srctitle

-- select count(*)  from package where state='active'  group by srctitle
