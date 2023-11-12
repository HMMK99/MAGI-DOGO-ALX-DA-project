-- EMAILS IN EMPLOYEE TBL R NULLS
USE md_water_services;
SELECT distinct type_of_water_source FROM md_water_services.water_source;

SELECT L.address, COUNT(*) C FROM md_water_services.visits V 
JOIN md_water_services.location L ON L.location_id = V.location_id
GROUP BY L.address
ORDER BY C DESC
;

SELECT * FROM md_water_services.visits WHERE time_in_queue>=500;


SELECT * FROM md_water_services.water_source S
JOIN md_water_services.visits V ON S.source_id = V.source_id
WHERE v.time_in_queue>=500
ORDER BY  v.time_in_queue DESC
;

SELECT S.TYPE_OF_WATER_SOURCE, COUNT(*) C  FROM md_water_services.water_quality WQ
JOIN VISITS V ON V.record_id=WQ.record_id
JOIN WATER_SOURCE S ON S.source_id = V.source_id
WHERE WQ.subjective_quality_score = 10
	AND WQ.visit_count > 1
GROUP BY S.TYPE_OF_WATER_SOURCE
-- AND S.TYPE_OF_WATER_SOURCE != 'tap_in_home'
;


SELECT distinct results FROM md_water_services.well_pollution LIMIT 10;

SELECT * FROM md_water_services.well_pollution
WHERE 1=1
AND biological > 0.01
AND (results LIKE 'Clean%' OR description LIKE 'Clean%')
;

UPDATE WELL_POLLUTION
SET DESCRIPTION = 'Bacteria: Giardia Lamblia'
WHERE 
	BIOLOGICAL > 0.01
    AND DESCRIPTION = 'Clean Bacteria: Giardia Lamblia';
    
UPDATE WELL_POLLUTION
SET DESCRIPTION = 'Bacteria: E. coli'
WHERE 
	BIOLOGICAL > 0.01
    AND DESCRIPTION = 'Clean Bacteria: E. coli';
    
UPDATE WELL_POLLUTION
SET RESULTS = 'Contaminated: Biological'
WHERE 
	BIOLOGICAL > 0.01
    AND RESULTS = 'Clean';

SET autocommit = 1;

SELECT *
FROM well_pollution
WHERE description LIKE 'Clean_%' OR results = 'Clean' AND biological < 0.01;
/*
Contaminated: Chemical
Contaminated: Biological
Clean