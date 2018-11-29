/*the purpose of this query is to inform GOBI of any materials we may have 
purchased outside of GOBI. This allows our book selecting librarians to avoid
purchasing duplicates. */

select 
(regexp_matches(
	v.field_content,
	'[0-9]{9,10}[x]{0,1}|[0-9]{12,13}[x]{0,1}', --regex borrowed from PLCH (Ray Voelker)
	'i'
	)
)[1] as clean_isbn

from
sierra_view.record_metadata AS m
JOIN
sierra_view.bib_record_order_record_link AS L
ON
m.id = L.order_record_id
JOIN
sierra_view.bib_record AS b
ON
L.bib_record_id = b.record_id
JOIN
sierra_view.varfield_view AS v
ON
b.id = v.record_id
JOIN
sierra_view.bib_record_location AS loc
ON
b.record_id = loc.bib_record_id

where
m.record_type_code = 'o'
ANd
m.creation_date_gmt > (now() - interval '8 days')
AND
  v.marc_tag = '020' --ISBNs 
AND
  b.is_suppressed = 'FALSE'
AND
  b.bcode2 != '@' --excluding ebooks
AND 
  m.campus_code = '' --excluding virtual records
AND
  loc.location_code NOT LIKE 'h%' --excluding hamilton
AND
  loc.location_code NOT LIKE 'm%' --excluding middletown


ORDER BY clean_isbn ASC
--limit 100