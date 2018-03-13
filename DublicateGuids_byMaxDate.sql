with pack_ext as (
-- Active Packages with the GUID identified in package_extra 
select 	package.id, 
	package.title, 
	package.revision_id,
	r.state,
	r.current,
	package.metadata_modified,
	package_extra.value as guid
from package_extra, package, package_revision r 
where 	package_id = package.id and
        package.id = r.id and
        package.revision_id = r.revision_id and
	package.state = 'active' and 
	package_extra.state = 'active' and key = 'guid'
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
from harvest_object o, harvest_source s , harvest_object_extra e
where o.harvest_source_id = s.id and 
      o.id = e.harvest_object_id
--o.current = true and s.active = true
),
dup_pack as (
-- Returns package ID and titles that have duplicate guids
select * from
	(select title, guid as pack_guid, count(id) as datacount from
	 pack_ext
	group by title, guid) sq2
where datacount > 1),
rescount as (
-- Resource count
select package_id, r.revision_id, count(url) as rcount from 
resource r, resource_group g where r.resource_group_id = g.id 
group by package_id, r.revision_id
),
fullset as (
select 	hguid as harvest_guid, 
	d.pack_guid as package_guid, 
	e.id as package_id,
	e.revision_id,
	e.state,
	e.current,	
	d.title as package_title, 
	d.datacount as duplicate_count, 
        e.metadata_modified as package_metadata_modified,
        h.metadata_modified_date as harvest_metadata_modified,
        h.import_finished as harvest_complete,
        h.state as harvest_state,
        h.src_title as harvest_source,
        h.surl as harvest_url,
        h.status,
        r.rcount
from dup_pack d, pack_ext e, harvest h,rescount r
where d.pack_guid = e.guid and
      e.id = h.opackid and
      r.package_id = e.id and
      r.revision_id = e.revision_id
order by pack_guid)
select * from fullset 
where (package_id,revision_id) not in (
select package_id, revision_id from fullset where
(harvest_guid, package_metadata_modified) in
(select harvest_guid, max(package_metadata_modified) from fullset group by harvest_guid) )

-- select harvest_guid, avg(rcount) from fullset group by harvest_guid order by avg
