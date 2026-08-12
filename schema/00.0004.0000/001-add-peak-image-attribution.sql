START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260812110522_AddPeakImageAttributionAndRunDiff') THEN
    ALTER TABLE peaks ADD image_author character varying(200);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260812110522_AddPeakImageAttributionAndRunDiff') THEN
    ALTER TABLE peaks ADD image_credit_url character varying(500);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260812110522_AddPeakImageAttributionAndRunDiff') THEN
    ALTER TABLE peaks ADD image_license character varying(60);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260812110522_AddPeakImageAttributionAndRunDiff') THEN
    ALTER TABLE peaks ADD image_license_url character varying(500);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260812110522_AddPeakImageAttributionAndRunDiff') THEN
    ALTER TABLE peak_ingestion_runs ADD peaks_unchanged integer NOT NULL DEFAULT 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260812110522_AddPeakImageAttributionAndRunDiff') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20260812110522_AddPeakImageAttributionAndRunDiff', '10.0.10');
    END IF;
END $EF$;
COMMIT;

