xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("list")
    %rest:query-param("wantFile","{$wantFile}")
    %rest:GET
    updating
    function local:list($wantFile as xs:string?) {

    let $database := db:open("santadb", "data")

    return if($wantFile="yes") then(
         update:output($database), file:write("xmlFile.xml", $database)
    ) else (
        update:output($database)
    )
};