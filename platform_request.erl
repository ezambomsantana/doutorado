-module(platform_request).

-include_lib("../deps/amqp_client/include/amqp_client.hrl").

-export([
         start_service/3, get_data_park/0
        ]).


start_service ( ActorName , CarCoordinates , Channel ) ->

	Park = call_parking_service( CarCoordinates ),

	publish_data( ActorName , Park , "data_stream" , Channel ).

publish_data( ActorName , Park , _Topic  , Channel ) ->

	Exchange = #'exchange.declare'{ exchange = <<"simulator_exchange">>,
                                    type = <<"topic">> },

	#'exchange.declare_ok'{} = amqp_channel:call( Channel, Exchange ),

	Publish = #'basic.publish'{ exchange = <<"simulator_exchange">>,
                                routing_key = list_to_binary( ActorName ) },

	amqp_channel:cast( Channel,
					   Publish,
					   #amqp_msg{ payload = list_to_binary( Park ) }).


		
call_parking_service( _Coordinates ) ->
	"teste".

 %   URL = "http://104.154.60.75:8000/discovery/resources?capability=parking_monitoring;lat=" ++ element( 1 , Coordinates ) ++ ";lon=" ++ element( 2 , Coordinates ) ++ ";radius=5000;available.eq=true",

  %  {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} =
   %   httpc:request(get, {URL, []}, [], []),

    %string:sub_string(Body, 24, 59).





get_data_park() ->
    receive
        {#'basic.deliver'{routing_key = RoutingKey}, #amqp_msg{payload = Body}} ->
            io:format(" [x] ~p:~p~n", [RoutingKey, Body]),
	    "certo";
        Any ->
            io:format("received unexpected Any: ~p~n", [Any]),
	    "any"
    end.
