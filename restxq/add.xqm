
module namespace local = 'http://basex.org';

declare %updating
%rest:path("/addv2")
%rest:POST("{$body}")
%rest:consumes("application/xml", "text/xml")
function local:addv2($body as document-node()) {

    let $xsd := "../xsd/ReservationSchema.xsd"
    let $is_not_valid := validate:xsd($body, $xsd)
    let $database := db:open("santadb", "data")//Bookings

    let $generated_id := fn:count($database/*) + 1
    let $number_of_members := fn:count($body/*/*/*[name(.) = "Family"]/*)
    let $members := $body/*/*/*[name(.) = "Family"]/*[name(.) = "Member"]

    let $preferred_dates := $body/*/*/*[name(.) = "Days"]/*
    let $has_availability := local:find_availability($preferred_dates)

    let $booking := document {
        element Booking {
            element Id {$generated_id},
            element NumberOfElements {$number_of_members},
            element ScheduleDate {$has_availability},
            element Members {$members}
        }
      }

    return (
        if ($is_not_valid) then (fn:error(xs:QName("Validation"), "The XML is invalid")),
        if (not($database)) then (fn:error(xs:QName("Database"), "Database can't be open")),
        if (not($has_availability)) then (
            fn:error(xs:QName("Availability"), "These dates are allready full")
        ) else (
            update:output("Successfully booked!"),
            insert node $booking as first into $database
        )
    )
};

declare function local:find_availability($dates as item()*) {
    let $db := db:open("santadb", "data")//Bookings

    for $date in $dates
    where fn:count($db/*/[ScheduleDate = $date/text()]) < 1
    return $date/text()
};