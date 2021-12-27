xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("add")
  %rest:POST("{$xml}")
  %rest:consumes("application/xml")
  updating
  function local:add($xml as item()) {

    let $xsd := "../xsd/ReservationSchema.xsd"

    let $validation := validate:xsd($xml, $xsd)

    let $database_exists := if (not(db:exists("santadb", "data"))) then (
        <error>
            <code>Database not found</code>
        </error>
    )

    return (
        update:output($validation),
        update:output($database_exists),
        local:booking("2021-03-24")
    )
};

declare updating function local:booking($preferred_date as xs:string) {
    let $database := db:open("santadb", "data")

    (:TODO: verificar repetitividade e negatividade do inteiro:)
    let $booking := <Booking>
                        <Id>{random:integer()}</Id>
                        <Date>{$preferred_date}</Date>
                        <Families>1</Families>
                    </Booking>

    for $x in $database//Book/Agenda
    let $query := $x/Booking/Date
    return if ($query = $preferred_date) then (

        let $limit := $x/Booking/Families
        return if ($limit < 50) then (
            update:output("Succesfully Booked!"),
            replace value of node $limit with $limit + 1
        ) else (
            update:output("This date is allready full!")
        )

    ) else (
        update:output("Succesfully Booked!"),
        insert node $booking into $database//Book/Agenda
    )
};