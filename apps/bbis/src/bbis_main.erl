-module(bbis_main).

-export( [init/2] ).

init( Req0, State ) ->
	{ok, Html} = index_dtl:render(),
	Req = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/html">>
		}, Html, Req0),
	{ ok, Req, State }.
