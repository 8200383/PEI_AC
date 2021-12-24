xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("add")
  %rest:POST("{$xml}")
  %rest:consumes("application/xml")
  updating
  function local:add($xml as item()) {

    let $xsd := "../xsd/ReservationSchema.xsd"

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

    return (update:output($database_exists), local:booking("2021-03-24"))
};

declare updating function local:booking($preferred_date as xs:string) {
    let $database := db:open("santadb", "data")

    let $booking := <Booking>
                        <Date>{$preferred_date}</Date>
                        <Families>1</Families>
                    </Booking>

    for $x in $database//Book/Agenda/Booking
        let $query := $x/Date
        return if ($query = $preferred_date) then (

            let $limit := $x/Families
            return if ($limit < 3) then (
                update:output("Succesfully Booked!"),
                replace value of node $limit with $limit + 1
            ) else (
                update:output("This date is allready full!")
            )

        ) else (
            update:output("Succesfully Booked!"),
            insert node $booking into $database//Agenda
        )
};