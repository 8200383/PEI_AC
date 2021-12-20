module namespace page = 'http://basex.org/modules/web-page';

declare %rest:path("hello")
	%rest:GET
	function page:hello() {
	<response>
		<server>BaseX</server>
		<type>RESTXQ API</type>
	</response>
};
