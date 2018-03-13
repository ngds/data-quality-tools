
select * from package where id in (
select package_id from package_extra where key = 'md_package') and
id in
(select package_id from harvest_object 
where harvest_source_id = 'f1cf5554-72a1-4466-8b0a-e98840b1d236')

-- THIS IS THE WORKING VERSION

select p.id, 
p.title, 
p.metadata_modified,
t.name as tag_name,
s.source,
substr(value,position('usginContentModel"' IN value),120) as model,
substr(value,position('usginContentModelLayer' IN value),60) as Layer,
substr(value,position('usginContentModelVersion' IN value),120) as Version 
from package p,package_extra e,
(select distinct p.id as pid, t.name from tag t, package_tag pt, package p where p.id = pt.package_id and pt.tag_id = t.id and t.name like 'usgincm:%') t,
(select s.title as source, o.package_id as spid from harvest_source s, harvest_object o where o.harvest_source_id = s.id and s.active = 't') s
where 
p.id  = e.package_id and 
p.id = t.pid and
(p.id = s.spid and e.key = 'md_package' and e.value like '%usginContent%')
order by title

-- This one will get it by harvest_source

select p.id, 
p.title, 
p.metadata_modified,
t.name as tag_name,
s.source,
substr(value,position('usginContentModel"' IN value),80) as model,
substr(value,position('usginContentModelLayer' IN value),80) as Layer,
substr(value,position('usginContentModelVersion' IN value),80) as Version 
from package p,package_extra e,
(select p.id as pid, t.name from tag t, package_tag pt, package p where p.id = pt.package_id and pt.tag_id = t.id and t.name like 'usgincm:%') t,
(select s.title as source, o.package_id as spid  from harvest_source s, harvest_object o where s.active = 't') s
where 
p.id  = e.package_id and 
p.id = t.pid and
p.id = s.spid and
e.key = 'md_package' and 
p.id in
(select package_id from harvest_object 
where harvest_source_id = 'f1cf5554-72a1-4466-8b0a-e98840b1d236')
order by p.id



select * from package where id in (
select  --package_id
package_id, substr(value,position('usginContentModel"' IN value)-2,120) as model,
substr(value,position('usginContentModelLayer' IN value),120) as Layer,
substr(value,position('usginContentModelVersion' IN value),120) as Version 
from package_extra where key = 'md_package' and value like '%usginContent%' and value like '%PowerPlant%' limit 100
)




select package_id, substr(value,position('usginContent' IN value),150) as USGIN
from package_extra where key = 'md_package' and value like '%usginContent%' limit 100


select * from harvest_object where package_id = 'f7f953ca-68f1-4ea4-aa02-0d5696db6b88'


select p.title, p.metadata_modified,
substr(value,position('usginContentModel"' IN e.value)-2,120) as Model,
substr(value,position('usginContentModelLayer' IN e.value),120) as Layer,
substr(value,position('usginContentModelVersion' IN e.value),120) as Version 
from package p, package_extra e 
where p.id = e.package_id and  
      e.key = 'md_package' and 
      value like '%usginContent%'
limit 100

limit 10
