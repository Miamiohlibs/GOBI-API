DROP  TABLETABLE IF EXISTS temp_bib_records;
CREATE TEMP TABLE temp_bib_records  AS

SELECT
m.record_type_code || m.record_num || 'a' AS bib_rec,
--b. and v. abbreviations must be consistent throughout
(regexp_matches(
	v.field_content,
	'[0-9]{9,10}[x]{0,1}|[0-9]{12,13}[x]{0,1}', --regex borrowed from PLCH (Ray Voelker)
	'i'
	)
)[1] as clean_isbn

FROM
sierra_view.bib_record AS b
JOIN
sierra_view.bib_record_location AS l
ON
b.record_id = l.bib_record_id
JOIN
sierra_view.varfield_view AS v
ON
b.id = v.record_id
JOIN
sierra_view.record_metadata AS m  
ON
b.record_id = m.id  

WHERE
 -- b.cataloging_date_gmt >  (now() - interval '8 days') --for initial load remove time limit
--AND
  v.marc_tag = '020' --ISBNs 
AND
  b.is_suppressed = 'FALSE'
AND
  b.bcode2 != '@' --excluding ebooks
AND 
  m.campus_code = '' --excluding virtual records
AND
  l.location_code NOT LIKE 'h%' --excluding hamilton
AND
  l.location_code NOT LIKE 'm%' --excluding middletown


CREATE INDEX index_clean_isbn_bibs ON temp_bib_records;

SELECT
*
FROM 
temp_bib_records as t
WHERE
t.clean_isbn
IN 
(
"078681859X"
"0313284288"
"9780822590286"
"082259028X"
"0780652975"
"9780780652972"
"9781400066094"
)
