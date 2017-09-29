-module(platform_request).

-export([
         call_parking_service/1
        ]).
		
call_parking_service( Coordinate ) ->
    {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} =
      httpc:request(get, {"http://www.erlang.org", []}, [], []),
	  
	Body.
