xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("remove")
  %rest:query-param("id","{$id}")
  %rest:DELETE
  %rest:consumes("application/xml")
  updating
  function local:remove($id as xs:integer) {

    let $database_exists := if (not(db:exists("santadb", "data"))) then (
        <error>
            <code>Database not found</code>
        </error>
    )

    return (update:output($database_exists), local:deleteBooking($id))
};

declare updating function local:deleteBooking($bookingId as xs:integer) {
    let $database := db:open("santadb", "data")

    return (
        update:output("Succesfully Deleted!"),
        delete node $database/Book/Agenda/Booking[Id=$bookingId]
    )
};