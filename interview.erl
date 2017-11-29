-module(convert).


-export([ roman_to_number/1 ]).

roman_to_number(String) ->
    
    Element = lists:nth( 1 , String ),
    Number = case Element of
        $I -> 1;
        $V -> 5;
        $X -> 10
    end,
    roman_to_number( tl( String ) , Number , Number ).

roman_to_number( [] , Acc , _Last ) ->

    Acc;

roman_to_number( String , Acc , Last ) ->

    Element = lists:nth( 1 , String ),
    Number = case Element of
        $I -> 1;
        $V -> 5;
	$X -> 10
    end,


    case Number > Last of
        true -> 
           roman_to_number( tl( String ) , ( Acc - Last) + (Number - Last) , Number );
        false ->
	   roman_to_number( tl( String ) , Acc + Number , Number )
    end.




   
