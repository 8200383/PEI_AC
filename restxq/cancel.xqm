xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("cancel")
%rest:query-param("id", "{$id}")
%rest:DELETE
updating
function local:cancel($id as xs:integer) {

    let $database := db:open("santadb", "data")

    return (
        if (not($database)) then (fn:error(xs:QName("Database"), "Database can't be open")),
        update:output("Successfully canceled!"),
        replace value of node $database/Bookings/Booking[Id=$id]/Canceled with fn:true()
    )
};