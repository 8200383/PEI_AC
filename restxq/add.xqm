xquery version "3.1";

module namespace page = 'http://basex.org/modules/web-page';

declare %rest:path("add")
	%rest:POST("{$xml}")
	%rest:consumes("application/xml")
	function page:add($xml as item()) as item() {

    let $xsd := "../xsd/ReservationSchema.xsd"

    let $res := try {
        let $notValid := validate:xsd($xml, $xsd)

        return if ($notValid) then (
            <res>Not Valid</res>
        ) else (
            <res>Valid</res>
        )

    } catch validate:* {
        <res>
            <code>{$err:code}</code>
            <cause>{$err:description}</cause>
        </res>
    }

    return $res
};
