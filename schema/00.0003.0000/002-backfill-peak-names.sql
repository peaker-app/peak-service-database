START TRANSACTION;

UPDATE peaks p
SET name = best.name
FROM (
    SELECT DISTINCT ON (pn.peak_id)
           pn.peak_id,
           pn.name
    FROM peak_names pn
    WHERE pn.name !~ '^Q[1-9][0-9]*$'
    ORDER BY pn.peak_id,
             (pn.language_code = 'en') DESC,
             pn.is_official DESC,
             pn.name
) AS best
WHERE best.peak_id = p.id
  AND p.name ~ '^Q[1-9][0-9]*$';

DELETE FROM peak_names pn
USING peaks p
WHERE pn.peak_id = p.id
  AND lower(pn.name) = lower(p.name);

COMMIT;
