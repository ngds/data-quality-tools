-- Table: public.ngds_resource_quality

-- DROP TABLE public.ngds_resource_quality;

CREATE TABLE public.ngds_resource_quality
(
    id text COLLATE pg_catalog."default" NOT NULL,
    package_id text COLLATE pg_catalog."default" NOT NULL,
    resource_id text COLLATE pg_catalog."default" NOT NULL,
    orig_url text COLLATE pg_catalog."default",
    validation_date timestamp without time zone,
    http_status text COLLATE pg_catalog."default",
    http_location text COLLATE pg_catalog."default",
    http_content_length bigint,
    http_last_modified timestamp without time zone,
    CONSTRAINT resource_quality_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.ngds_resource_quality
    OWNER to ckan_default;

-- Index: idx_ngds_quality_package_id

-- DROP INDEX public.idx_ngds_quality_package_id;

CREATE INDEX idx_ngds_quality_package_id
    ON public.ngds_resource_quality USING btree
    (package_id COLLATE pg_catalog."default", id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: idx_ngds_quality_resource_id

-- DROP INDEX public.idx_ngds_quality_resource_id;

CREATE INDEX idx_ngds_quality_resource_id
    ON public.ngds_resource_quality USING btree
    (resource_id COLLATE pg_catalog."default", id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: idx_resource_quality_id

-- DROP INDEX public.idx_resource_quality_id;

CREATE INDEX idx_resource_quality_id
    ON public.ngds_resource_quality USING btree
    (id COLLATE pg_catalog."default")
    TABLESPACE pg_default;