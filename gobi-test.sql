SELECT
  b.cataloging_date_gmt, --b. v. abbreviations must be consistent throughout
  v.marc_tag,
  v.field_content as isbn,
  b.is_suppressed
  
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

WHERE
  b.cataloging_date_gmt >  (now() - interval '8 days') 
AND
  v.marc_tag = '020' --need regex exclude \|q.*
AND
  b.is_suppressed = 'FALSE'
AND
  b.bcode2 = '@'

