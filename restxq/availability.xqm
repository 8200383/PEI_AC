xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("availibilty/{$from}/{$to}")
  %rest:GET
  updating
  function local:availibilty($from as xs:date, $to as xs:date) {

  let $database := db:open("santadb", "data")

  for $x in $database//Book/Agenda/Booking
  where $x[$from<Date][Date<$to]
  return update:output(<info>
            <Date>{$x/Date/text()}</Date>
            <availability>{$x/Availability/text()}</availability>
         </info>),
        update:output("If the date you are looking for is not here, its because is totally available.")
};