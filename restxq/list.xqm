xquery version "3.1";

module namespace local = 'http://basex.org';

declare %updating
%rest:path("list")
%rest:GET
function local:list() {

    let $database := db:open("santadb", "data")

    return update:output($database)
};