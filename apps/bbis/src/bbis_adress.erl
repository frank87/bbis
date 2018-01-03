-module(bbis_adress).

-behaviour(gen_server).
-export( [ init/1, handle_call/3, handle_cast/2, handle_info/2 ] ).

init( _ ) -> 
	RouteTable = { '_', [ { "/", bbis_main, [] } ] },
	Dispatch = cowboy_router:compile( [ RouteTable ] ),
	{ ok, _ } = cowboy:start_clear( bbis_listener,
					[{port, 8080}],
					#{ env => #{dispatch => Dispatch} }
				      ),
	{ ok, RouteTable }.

handle_call( {add_route, Path, Handler }, _, { Host, RouteList } ) -> 
	RouteTable = { Host, [ { Path, Handler, [] }| RouteList ] },
	Dispatch = cowboy_route:compile( [ RouteTable ] ),
	{ ok, _ } = cowboy:set_env( bbis_listener,
				    dispatch,
				    Dispatch ),
	{ reply, ok, RouteTable };
handle_call( list, _, RouteTable ) ->
	{ reply, RouteTable, RouteTable }.

handle_cast( {add_route, Path, Handler }, { Host, RouteList } ) ->
	RouteTable = { Host, [ { Path, Handler, [] }| RouteList ] },
	Dispatch = cowboy_router:compile( RouteTable ),
	{ ok, _ } = cowboy:set_env( bbis_listener,
				    dispatch,
				    Dispatch ),
	{ noreply, RouteTable }.

handle_info( _, State ) -> { noreply, State }.
