-module(parens_match).
-export([start/0]).

% To execute Erlang, please declare the module as "solution"
% and define a method named "start" on it.

start() ->
  true = parens_match("(a[0]+b[2c[6]]) {24 + 53}"),
  true = parens_match("f(e(d))"),
  true = parens_match("[()]{}([])"),
  false = parens_match("((b)"),
  false = parens_match("(c]"),
  false = parens_match("{(a[])"),
  false = parens_match("([)]"),
  true = parens_match(""),
  io:format("All tests pass ~n").

%% Write a function that returns true if the parentheses in a
%% given string are balanced. The function must handle parens
%% (), square brackets [], and curly braces {}.
parens_match(List) ->
  parents_match_loop(List, []). 
  
parents_match_loop( [] , Stack ) ->
  length(Stack) == 0;

parents_match_loop([Element | List] , Stack) ->  
  case Element of
    $( ->
      parents_match_loop(List, Stack ++ [Element]);      
    $) ->
      Last = lists:last(Stack),
      case Last of 
        $( ->
          parents_match_loop(List, lists:droplast(Stack)); 
        _ ->
          false
      end;
    $[ ->
      parents_match_loop(List, Stack ++ [Element]);
    $] ->
      Last = lists:last(Stack),
      case Last of 
        $[ ->
          parents_match_loop(List, lists:droplast(Stack)); 
        _ ->
          false
      end;
    ${ ->
      parents_match_loop(List, Stack ++ [Element]);
    $} ->
      Last = lists:last(Stack),
      case Last of 
        ${ ->
          parents_match_loop(List, lists:droplast(Stack)); 
        _ ->
          false
      end;
    _ ->
      parents_match_loop(List, Stack)      
  end.
    
