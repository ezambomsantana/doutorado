-module(platform_request).

-include_lib("../deps/amqp_client/include/amqp_client.hrl").

-export([
         start_server/0, make_call/4, receive_park/2, verify_park_by_actor_name/2, call_parking_service/6, init_file_service/0, save_timestamp/6
        ]).

start_server( ) ->
	
	FileServicePID = spawn(platform_request, init_file_service , [ ]),
	run_server( FileServicePID ).

run_server( FileServicePID ) ->

	receive
% estacionamento
		{ make_call , ActorName , Coordinates , Time } -> make_call( ActorName , Coordinates , FileServicePID , Time );
		{ receive_park, ActorName , Park } -> receive_park( ActorName , Park );
		{ verify_park_by_actor_name , ActorName , PID } -> verify_park_by_actor_name( ActorName , PID )
% saude
	end,
	run_server( FileServicePID ).

make_call( ActorName , Coordinates , FileServicePID , Time ) ->
	spawn(platform_request, call_parking_service , [ ActorName , Coordinates , self() , 500 , FileServicePID , Time ]).

receive_park( ActorName , Park ) ->
        put (ActorName , Park ).

verify_park_by_actor_name( ActorName , PID ) ->
       Park = get( ActorName ),
       case Park of
	    undefined -> PID ! { nok };
	    _ -> erase( ActorName ), PID !  { ok , ActorName , Park }
       end.

		
call_parking_service( ActorName , Coordinates , PID , Radius , FileServicePID , Time ) ->

    inets:start(),

    { { Year, Month, Day }, { Hour, Minute, Second } } = calendar:local_time(),
    FirstTimestamp = lists:flatten( io_lib:format( "~4..0w-~2..0w-~2..0wT~2..0w:~2..0w:~2..0w",
                                          [ Year, Month, Day, Hour, Minute, Second ] ) ),
%kong-proxy
%172.19.66.212
    URL = "http://kong-proxy:8000/discovery/resources?capability=parking_monitoring;lat=" ++ element( 1 , Coordinates ) ++ ";lon=" ++ element( 2 , Coordinates ) ++ ";radius=" ++ integer_to_list( Radius ) ++ ";available.eq=true",

    FirstMiliseconds = get_timestamp(),

  case httpc:request(get, {URL, []}, [], []) of
	{ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} ->
   		{ { Year2, Month2, Day2 }, { Hour2, Minute2, Second2 } } = calendar:local_time(),
    		SecondTimestamp = lists:flatten( io_lib:format( "~4..0w-~2..0w-~2..0wT~2..0w:~2..0w:~2..0w",
                                          [ Year2, Month2, Day2, Hour2, Minute2, Second2 ] ) ),
		
    		SecondMiliseconds = get_timestamp(),

		case length(Body) < 30 of
		
			true -> 
				FileServicePID ! { save_timestamp , FirstTimestamp , SecondTimestamp , Time , FirstMiliseconds , SecondMiliseconds },
				call_parking_service( ActorName , Coordinates , PID , Radius * 2 , FileServicePID , Time );
			false -> 

				RegExp = "uuid.*",
				Park = case re:run(Body, RegExp) of
				  {match, Captured} -> 
					Index = element( 1 , list_utils:get_element_at( Captured , 1 ) ),
					string:sub_string( Body , Index + 8, Index + 43)					
				end,


				FileServicePID ! { save_timestamp , FirstTimestamp , SecondTimestamp , Time , FirstMiliseconds , SecondMiliseconds },
				PID ! { receive_park , ActorName , Park }
	        end;

	{ok, {{_Version, 504, _ReasonPhrase}, _Headers, _Body}} ->
             { { Year2, Month2, Day2 }, { Hour2, Minute2, Second2 } } = calendar:local_time(),
             SecondTimestamp = lists:flatten( io_lib:format( "~4..0w-~2..0w-~2..0wT~2..0w:~2..0w:~2..0w",
                                          [ Year2, Month2, Day2, Hour2, Minute2, Second2 ] ) ),

	     SecondMiliseconds = get_timestamp(),
  		
	     FileServicePID ! { save_error , FirstTimestamp , SecondTimestamp , "timeout" , Time , FirstMiliseconds , SecondMiliseconds };


	{ error , Reason } ->
             { { Year2, Month2, Day2 }, { Hour2, Minute2, Second2 } } = calendar:local_time(),
             SecondTimestamp = lists:flatten( io_lib:format( "~4..0w-~2..0w-~2..0wT~2..0w:~2..0w:~2..0w",
                                          [ Year2, Month2, Day2, Hour2, Minute2, Second2 ] ) ),
  		
             SecondMiliseconds = get_timestamp(),

	     FileServicePID ! { save_error , FirstTimestamp , SecondTimestamp , Reason , Time , FirstMiliseconds , SecondMiliseconds }
  end.


get_timestamp() ->
  {Mega, Sec, Micro} = os:timestamp(),
  (Mega*1000000 + Sec)*1000 + round(Micro/1000).

init_file_service() ->

	File = file_utils:open( "../output/response_time.csv" , _Opts=[ write , delayed_write ] ),
        put ( file , File ),
	run_file_service().

run_file_service() ->
	receive
		{ save_timestamp , FirstTimestamp , SecondTimestamp , Time , FirstMiliseconds , SecondMiliseconds } -> 
 		   save_timestamp( "success" , FirstTimestamp , SecondTimestamp , Time , FirstMiliseconds , SecondMiliseconds );
		{ save_error , FirstTimestamp , SecondTimestamp , Reason , Time , FirstMiliseconds , SecondMiliseconds } -> 
		   save_timestamp_error( "error" , FirstTimestamp , SecondTimestamp , Reason , Time , FirstMiliseconds , SecondMiliseconds )
	end,
	run_file_service( ).


save_timestamp( Result , FirstTimestamp , SecondTimestamp , Time , FirstMiliseconds , SecondMiliseconds ) ->

	File = get( file ),	

	file_utils:write( File, "~s,~s,~s,~w,~w,~w\n" , [ Result , FirstTimestamp , SecondTimestamp , Time , FirstMiliseconds , SecondMiliseconds ] ).


save_timestamp_error( Result , FirstTimestamp , SecondTimestamp , Reason , Time , FirstMiliseconds , SecondMiliseconds ) ->

	File = get( file ),	

	file_utils:write( File, "~s,~s,~s,~w,~s,~w,~w\n" , [ Result , FirstTimestamp , SecondTimestamp , Time , Reason , FirstMiliseconds , SecondMiliseconds ] ).
