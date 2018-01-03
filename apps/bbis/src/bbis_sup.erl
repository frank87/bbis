%%%-------------------------------------------------------------------
%% @doc bbis top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(bbis_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    {ok, { {one_for_all, 0, 1}, [ 
	{ bbis_adress, 
	  	{gen_server,start_link,[ bbis_adress, [], [] ]}, 
		permanent,
	       	5000,
	       	worker,
	       	[bbis_adress,bbis_main ]  } 
	]} }.

%%====================================================================
%% Internal functions
%%====================================================================
