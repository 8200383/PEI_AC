xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("availibilty")
  %rest:query-param("from","{$from}")
  %rest:query-param("to","{$to}")
  %rest:GET
  updating
  function local:availibilty($from as xs:string?, $to as xs:string?) {

  let $database := db:open("santadb", "data")

  return if (not($from) or not($to)) then(
      for $x in $database//Book/Agenda/Booking
      return update:output(<info>
                <Date>{$x/Date/text()}</Date>
                <availability>{$x/Availability/text()}</availability>
             </info>),
            update:output("If the date you are looking for is not here, its because is totally available.")
  )else(
      for $x in $database//Book/Agenda/Booking
      where $x[xs:date($from)<Date][Date<xs:date($to)]
      return update:output(<info>
                <Date>{$x/Date/text()}</Date>
                <availability>{$x/Availability/text()}</availability>
             </info>),
            update:output("If the date you are looking for is not here and it's between the dates that you put, its because is totally available.")
  )
};