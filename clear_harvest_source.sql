/*

This is the SQL that clears all the records for a harvest source as found in:

ckan-harvest/ckanext/harveest/logic/action/update.py 
   harvest_source_clear

Sometimes it is necessary to run this manually step by step, since this process can
get hung due if the database tables are large and havent been adeq1uately maintained.

GH

SRCID -- pass it in

*/

update package set state = 'to_delete' 
	where id in (select package_id from harvest_object where harvest_source_id = :SRCID)

delete from resource_revision where resource_group_id in 
        (select id from resource_group where package_id in 
        (select id from package where state = 'to_delete'));
		
delete from resource where resource_group_id in 
        (select id from resource_group where package_id in 
        (select id from package where state = 'to_delete'));
		
 delete from resource_group_revision where package_id in 
        (select id from package where state = 'to_delete');
		
 delete from resource_group where package_id  in 
        (select id from package where state = 'to_delete');
		
delete from harvest_object_error 
	where harvest_object_id in 
		(select id from harvest_object where harvest_source_id = :SRCID);

delete from harvest_object_extra 
	where harvest_object_id in 
		(select id from harvest_object where harvest_source_id = :SRCID);
		
delete from harvest_object 
	where harvest_source_id = :SRCID;

delete from harvest_gather_error 
	where harvest_job_id in 
		(select id from harvest_job where source_id = :SRCID);

delete from harvest_job where source_id = :SRCID;

delete from package_role 
	where package_id in (select id from package where state = 'to_delete' );

delete from user_object_role where id not in (select user_object_role_id from package_role) and context = 'Package';
delete from package_tag_revision where package_id in (select id from package where state = 'to_delete');
delete from member_revision where table_id in (select id from package where state = 'to_delete');
delete from package_extra_revision where package_id in (select id from package where state = 'to_delete');
delete from package_revision where id in (select id from package where state = 'to_delete');
delete from package_tag where package_id in (select id from package where state = 'to_delete');
delete from package_extra where package_id in (select id from package where state = 'to_delete');
delete from member where table_id in (select id from package where state = 'to_delete');
delete from related_dataset where dataset_id in (select id from package where state = 'to_delete');
delete from related where id in {related_ids};

reindex table package;
reindex table package_extra;
reindex table package_tag;
reindex table package_revision;
reindex table package_extra_revision;
reindex table member_revision;
reindex table package_tag_revision
reindex table package_role;
reindex table harvest_job;
reindex table harvest_object;
reindex table harvest_object_error;
reindex table resource;
reindex table resource_group;
reindex table resource_revision;
reindex table resource_group_revision;


-- Rebuild solr with command line paster
-- /usr/lib/ckan/bin/paster --plugin=ckan search-index rebuild '{{source_name}}' --config=/etc/ckan/production.ini
