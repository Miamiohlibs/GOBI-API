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
";


$result = pg_query($db_handle, $query);


while($row = pg_fetch_row($result)) {
      echo "<div>". $row[2] . "\n" . "</div>";
      echo "<br />\n";

 }

 pg_free_result($result);
//deprecated pg_close($db_handle);
?>


