xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("init")
    %rest:GET
    %updating
    function local:init() {

    let $xmlSchema := <Book>
                        <Reservations/>
                        <Agenda/>
                      </Book>

    return (update:output("Database created"),
           db:create("santadb", $xmlSchema, "data"))
};
