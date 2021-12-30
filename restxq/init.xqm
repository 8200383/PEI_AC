xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %updating
%rest:path("init")
%rest:GET
function local:init() {
     update:output("Database created"),
     db:create("santadb", <Bookings/>, "data")
};
