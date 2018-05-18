<?php
/*Code heavily updated by Craig Boman; initial script provided by Larry Hansard at Middle Tennessee State University libraries*/

function getdb() {
   $host        = "host=your sierra server";
   $port        = "port=1032";
   $dbname      = "dbname=iii";
   $credentials = "user=userid password=password";
   $ssl 	= "sslmode=require";

   $db = pg_connect("$host $port $dbname $credentials $ssl");
   return $db;
}

$db_handle = getdb(); //call the db function

$query = "
SELECT
--b. and v. abbreviations must be consistent throughout
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

WHERE
  b.cataloging_date_gmt >  (now() - interval '8 days') --for initial load remove time limit
AND
  v.marc_tag = '020' --need regex exclude \|q.*
AND
  b.is_suppressed = 'FALSE'
AND
  b.bcode2 != '@' --we are excluding ebooks here

";


$result = pg_query($db_handle, $query);


while($row = pg_fetch_row($result)) {
      echo "<div>". $row[2] . "\n" . "</div>";
      echo "<br />\n";

 }

 pg_free_result($result);
//deprecated pg_close($db_handle);
?>


