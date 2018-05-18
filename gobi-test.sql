SELECT
--b. and v. abbreviations must be consistent throughout
(regexp_matches(
	v.field_content,
	'[0-9]{9,10}[x]{0,1}|[0-9]{12,13}[x]{0,1}', --regex borrowed from PLCH
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
  b.cataloging_date_gmt >  (now() - interval '8 days') --for initial load remove time limit
AND
  v.marc_tag = '020' --need regex exclude \|q.*
AND
  b.is_suppressed = 'FALSE'
AND
  b.bcode2 != '@' --we are excluding ebooks here
AND 
  m.campus_code = ''
AND
  l.location_code <> 'h*' --these don't work; convert to regex
AND
  l.location_code <> 'm*'


  -- need to exclude hamilton and middletown locations
