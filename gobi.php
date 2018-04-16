<?php
/*script provided by Larry Hansard at Middle Tennessee State University libraries*/

   $host        = "host=your sierra server";
   $port        = "port=1032";
   $dbname      = "dbname=iii";
   $credentials = "user=userid password=password";

   $db_handle = pg_connect( "$host $port $dbname $credentials"  );


$query = " 
SELECT 
  bib_record.cataloging_date_gmt, 
  varfield_view.marc_tag, 
  varfield_view.field_content as isbn, 
  bib_record.is_suppressed
FROM 
  sierra_view.bib_record, 
  sierra_view.varfield_view
WHERE 
  bib_record.record_id = varfield_view.record_id and 
  bib_record.cataloging_date_gmt >  (now() - interval '8 days') and
  varfield_view.marc_tag = '020' and
  bib_record.is_suppressed = 'FALSE'";

$result = pg_exec($db_handle, $query);

if ($result) {        


    for ($row = 0; $row < pg_numrows($result); $row++) {        

        echo pg_result($result, $row, 'isbn') .  "\n";        


    }        

} 


 pg_free_result($result);
 pg_close($db_handle);
?>
