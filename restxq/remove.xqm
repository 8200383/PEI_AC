xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("remove")
  %rest:POST("{$xml}")
  %rest:consumes("application/xml")
  updating
  function local:remove($xml as item()) {

    let $xsd := "../xsd/CancelReservationSchema.xsd"

    let $validation := try {
        validate:xsd($xml, $xsd)
    } catch validate:* {
        <error>
            <code>{$err:code}</code>
            <cause>{$err:description}</cause>
        </error>
    }

    let $database_exists := if (not(db:exists("santadb", "data"))) then (
        <error>
            <code>Database not found</code>
        </error>
    )

    return (update:output($database_exists), local:deleteBooking($xml//@id))
};

declare updating function local:deleteBooking($id as xs:integer) {
    let $database := db:open("santadb", "data")

    return (
        update:output("Succesfully Deleted!"),
        delete node $database/Book/Agenda/Booking[Id=$id]
    )
};