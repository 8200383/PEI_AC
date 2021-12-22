xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("add")
	%rest:POST("{$xml}")
	%rest:consumes("application/xml")
	%updating
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

    let $output := if (db:exists("santadb", "data")) then (
        let $database := db:open("santadb", "data")
        let $query := $database/Reservations/Reservation

        return <res>None</res>
    ) else (
        <error>
            <code>Database not found</code>
        </error>
    )

    return (update:output($validation), update:output($output))
};
