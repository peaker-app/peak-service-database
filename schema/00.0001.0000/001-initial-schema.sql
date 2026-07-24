CREATE TABLE IF NOT EXISTS "__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL,
    CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId")
);

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724145514_InitialPeakSchema') THEN
    CREATE EXTENSION IF NOT EXISTS postgis;
    CREATE EXTENSION IF NOT EXISTS unaccent;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724145514_InitialPeakSchema') THEN
    CREATE OR REPLACE FUNCTION immutable_unaccent(text)
    RETURNS text
    LANGUAGE sql IMMUTABLE PARALLEL SAFE STRICT
    AS $$ SELECT unaccent('unaccent', $1) $$;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724145514_InitialPeakSchema') THEN
    CREATE TABLE mountain_ranges (
        id uuid NOT NULL,
        name character varying(200) NOT NULL,
        parent_range_id uuid,
        created_at_utc timestamp with time zone NOT NULL,
        updated_at_utc timestamp with time zone NOT NULL,
        CONSTRAINT "PK_mountain_ranges" PRIMARY KEY (id),
        CONSTRAINT "FK_mountain_ranges_mountain_ranges_parent_range_id" FOREIGN KEY (parent_range_id) REFERENCES mountain_ranges (id) ON DELETE RESTRICT
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724145514_InitialPeakSchema') THEN
    CREATE TABLE peaks (
        id uuid NOT NULL,
        wikidata_id character varying(20) NOT NULL,
        name character varying(200) NOT NULL,
        altitude_m integer NOT NULL,
        prominence_m integer,
        location geography (Point,4326) NOT NULL,
        country_code character(2),
        region character varying(120),
        range_id uuid,
        search_vector tsvector GENERATED ALWAYS AS (to_tsvector('simple', immutable_unaccent(name))) STORED,
        created_at_utc timestamp with time zone NOT NULL,
        updated_at_utc timestamp with time zone NOT NULL,
        CONSTRAINT "PK_peaks" PRIMARY KEY (id),
        CONSTRAINT "FK_peaks_mountain_ranges_range_id" FOREIGN KEY (range_id) REFERENCES mountain_ranges (id) ON DELETE SET NULL
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724145514_InitialPeakSchema') THEN
    CREATE TABLE peak_names (
        id uuid NOT NULL,
        language_code character varying(12) NOT NULL,
        name character varying(200) NOT NULL,
        is_official boolean NOT NULL,
        peak_id uuid NOT NULL,
        CONSTRAINT "PK_peak_names" PRIMARY KEY (id),
        CONSTRAINT "FK_peak_names_peaks_peak_id" FOREIGN KEY (peak_id) REFERENCES peaks (id) ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724145514_InitialPeakSchema') THEN
    CREATE INDEX "IX_mountain_ranges_parent_range_id" ON mountain_ranges (parent_range_id);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724145514_InitialPeakSchema') THEN
    CREATE INDEX ix_peak_names_peak ON peak_names (peak_id);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724145514_InitialPeakSchema') THEN
    CREATE UNIQUE INDEX ux_peak_names_unique ON peak_names (peak_id, language_code, name);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724145514_InitialPeakSchema') THEN
    CREATE INDEX ix_peaks_altitude ON peaks (altitude_m DESC);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724145514_InitialPeakSchema') THEN
    CREATE INDEX ix_peaks_country ON peaks (country_code);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724145514_InitialPeakSchema') THEN
    CREATE INDEX ix_peaks_location ON peaks USING gist (location);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724145514_InitialPeakSchema') THEN
    CREATE INDEX "IX_peaks_range_id" ON peaks (range_id);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724145514_InitialPeakSchema') THEN
    CREATE INDEX ix_peaks_search ON peaks USING gin (search_vector);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724145514_InitialPeakSchema') THEN
    CREATE UNIQUE INDEX ux_peaks_wikidata ON peaks (wikidata_id);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724145514_InitialPeakSchema') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20260724145514_InitialPeakSchema', '10.0.10');
    END IF;
END $EF$;
COMMIT;

