xquery version "3.1";

module namespace ava = 'http://basex.org/availability';

declare
%rest:path("availability")
%rest:query-param("from","{$from}")
%rest:query-param("to","{$to}")
%rest:GET
function ava:availability($from as xs:string?, $to as xs:string?) {

    let $database := db:open("santadb", "data")//Bookings
    let $bookings := $database/Booking[Canceled = fn:false()]

    return (
        if (not($database)) then (fn:error(xs:QName("Database"), "Database can't be open")),
        if (not($from) and not($to)) then (
            for $x in $bookings
            let $scheduleDate := xs:date($x/ScheduleDate)
            group by $scheduleDate
            return (
                <Availability>
                    <Date>{$scheduleDate}</Date>
                    <AvailableSlots>{50 - count($x)}</AvailableSlots>
                </Availability>
            )
        ) else (
            if(xs:date($from) > xs:date($to)) then (
                fn:error(xs:QName("Validation"), "Starting date is higher then ending date!")
            ) else (
                for $x in $bookings
                let $scheduleDate := xs:date($x/ScheduleDate)
                where $scheduleDate >= xs:date($from) and $scheduleDate <= xs:date($to)
                group by $scheduleDate
                return (
                    <Availability>
                        <Date>{$scheduleDate}</Date>
                        <AvailableSlots>{50 - count($x)}</AvailableSlots>
                    </Availability>
               )
            )
        )
        ,<Info> If the date you are looking for is not here its because all slots are available </Info>
    )
};