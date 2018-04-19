-- Table: public.ngds_resource_quality

-- DROP TABLE public.ngds_resource_quality;

CREATE TABLE public.ngds_traffic_statistics
(
    id text COLLATE pg_catalog."default" NOT NULL,
    log_start text COLLATE pg_catalog."default" NOT NULL,
    log_last text COLLATE pg_catalog."default" NOT NULL,
    total_hits text COLLATE pg_catalog."default",
    crawler_hits text COLLATE pg_catalog."default",
    local_hits text COLLATE pg_catalog."default",
	valid_hits text COLLATE pg_catalog."default",
	valid_datasets text COLLATE pg_catalog."default",
	unique_ip text COLLATE pg_catalog."default",
    track_date timestamp without time zone,
    CONSTRAINT traffic_stats_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.ngds_traffic_statistics
    OWNER to ckan_default;

-- Index: idx_ngds_quality_package_id

CREATE INDEX idx_traffic_statistics_id
    ON public.ngds_traffic_statistics USING btree
    (id COLLATE pg_catalog."default", id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

