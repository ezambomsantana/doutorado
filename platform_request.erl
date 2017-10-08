-module(platform_request).

-include_lib("../deps/amqp_client/include/amqp_client.hrl").

-export([
         start_service/2
        ]).


start_service ( ActorName , CarCoordinates ) ->

	Park = call_parking_service( CarCoordinates ),

	publish_data( ActorName , Park , "data_stream" ).

publish_data( ActorName , Park , _Topic ) ->

	{ _ , Pwd } = file:get_cwd(),

	RoutingKey = string:concat( "car", ActorName),

	AmqpClientPath = string:concat( Pwd, "/../deps/amqp_client"),

	EbinPath = string:concat( AmqpClientPath, "/ebin" ),
	CommonPath = string:concat( AmqpClientPath, "/include/rabbit_common/ebin" ),

    	code:add_pathsa( [ AmqpClientPath , EbinPath , CommonPath ]	 ),

	{ ok, Connection } = amqp_connection:start( #amqp_params_network{} ),
	{ ok, Channel } = amqp_connection:open_channel( Connection ),

	Exchange = #'exchange.declare'{ exchange = <<"simulator_exchange">>,
                                    type = <<"topic">> },
	#'exchange.declare_ok'{} = amqp_channel:call( Channel, Exchange ),

	Publish = #'basic.publish'{ exchange = <<"simulator_exchange">>,
                                routing_key = list_to_binary( RoutingKey ) },

	amqp_channel:cast( Channel,
					   Publish,
					   #amqp_msg{ payload = list_to_binary( Park ) }).


		
call_parking_service( _Coordinates ) ->
	"teste".

 %   URL = "http://104.154.60.75:8000/discovery/resources?capability=parking_monitoring;lat=" ++ element( 1 , Coordinates ) ++ ";lon=" ++ element( 2 , Coordinates ) ++ ";radius=5000;available.eq=true",

  %  {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} =
   %   httpc:request(get, {URL, []}, [], []),

    %string:sub_string(Body, 24, 59).
