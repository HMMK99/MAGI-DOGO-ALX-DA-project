use md_water_services;

DROP TABLE IF EXISTS `auditor_report`;
CREATE TABLE `auditor_report` (
`location_id` VARCHAR(32),
`type_of_water_source` VARCHAR(64),
`true_water_source_score` int DEFAULT NULL,
`statements` VARCHAR(255)
);

select * from auditor_report;
select employee_name,statements from visits join employee on employee.assigned_employee_id = visits.assigned_employee_id
		join auditor_report on visits.location_id = auditor_report.location_id
where statements like '%villagers%'
and employee_name in('Bello Azibo', 'Zuriel Matembo', 'Malachi Mavuso', 'Lalitha Kaburi');

select employee_name, location.location_id, statements
from visits join employee on employee.assigned_employee_id = visits.assigned_employee_id
			join location on visits.location_id = location.location_id
            join auditor_report on visits.location_id = auditor_report.location_id
			JOIN water_quality ON visits.record_id=water_quality.record_id

where water_quality.subjective_quality_score != auditor_report.true_water_source_score
and employee.assigned_employee_id in(
WITH wquality_check as(
SELECT
	-- auditor_report.location_id AS audit_location,
	-- auditor_report.true_water_source_score,
	-- visits.record_id,
 --   water_quality.subjective_quality_score
 --   ,water_source.type_of_water_source AS survey_source,
 --   auditor_report.type_of_water_source AS auditor_source
	-- ,employee.assigned_employee_id
	-- ,employee.employee_name
    visits.assigned_employee_id, count(*) as no_of_mistakes
 
FROM
	auditor_report
JOIN
	visits
ON auditor_report.location_id = visits.location_id
 JOIN water_quality ON visits.record_id=water_quality.record_id
-- JOIN water_source ON visits.source_id = water_source.source_id
JOIN employee ON employee.assigned_employee_id = visits.assigned_employee_id
WHERE 1=1 
	and water_quality.subjective_quality_score != auditor_report.true_water_source_score
	and visits.visit_count= 1
  --  and water_source.type_of_water_source != auditor_report.type_of_water_source
  group by employee.assigned_employee_id
)

select assigned_employee_id
from wquality_check -- join employee on employee.assigned_employee_id = wquality_check.assigned_employee_id
where no_of_mistakes > (select avg(no_of_mistakes) from wquality_check)
-- order by no_of_mistakes desc
)
and visits.visit_count= 1
-- and statements like '%motives.%'
;






WITH wquality_check as(
SELECT
	-- auditor_report.location_id AS audit_location,
	-- auditor_report.true_water_source_score,
	-- visits.record_id,
 --   water_quality.subjective_quality_score
 --   ,water_source.type_of_water_source AS survey_source,
 --   auditor_report.type_of_water_source AS auditor_source
	-- ,employee.assigned_employee_id
	-- ,employee.employee_name
    visits.assigned_employee_id, count(*) as no_of_mistakes
 
FROM
	auditor_report
JOIN
	visits
ON auditor_report.location_id = visits.location_id
 JOIN water_quality ON visits.record_id=water_quality.record_id
-- JOIN water_source ON visits.source_id = water_source.source_id
JOIN employee ON employee.assigned_employee_id = visits.assigned_employee_id
WHERE 1=1 
	and water_quality.subjective_quality_score != auditor_report.true_water_source_score
	and visits.visit_count= 1
  --  and water_source.type_of_water_source != auditor_report.type_of_water_source
  group by employee.assigned_employee_id
)

select employee_name, no_of_mistakes
from wquality_check  join employee on employee.assigned_employee_id = wquality_check.assigned_employee_id
where no_of_mistakes <= (select avg(no_of_mistakes) from wquality_check)
order by no_of_mistakes desc
;