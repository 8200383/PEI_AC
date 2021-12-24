xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("list")
    %rest:GET
    function local:list() {

    let $database := db:open("santadb", "data")

    return $database
};