module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("hello")
	%rest:GET
	function local:hello() {
	<response>
		<server>BaseX</server>
		<type>RESTXQ API</type>
	</response>
};
