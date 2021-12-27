xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("export")
    %rest:GET
    function local:export() {

    let $database := db:open("santadb", "data")

    let $jsonSerialize :=  json:serialize($database, map { 'format': 'jsonml' })
    return file:write("JsonFile.json", $jsonSerialize)
};