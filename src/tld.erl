-module(tld).
-export([refresh/2]).

-define(TMPFILE, "public_suffix_list.dat").

%-record(suffix, { rule, labels }).


%% =============
%%      API
%% =============
%refresh() ->
%    io:format("===== Refreshing list and ruleset, please wait..."),
%    os:cmd("curl https://publicsuffix.org/list/public_suffix_list.dat -o " ++ ?TMPFILE),
%    refresh(file, ?TMPFILE),
%    io:format("===== refresh() completed.~n").
%extract().
%domain().
%subdomain().
%suffix().

%% =============
%%   INTERNALS
%% =============
refresh(file, File) ->
    {ok, Data}     = file:read_file(File),  % is binary
    DataFmt1       = binary:split(Data, <<"\n">>, [global]),
    DataFmt2a      = [ trim_ws(E) || E <- DataFmt1,
                                          E /= <<>>,
                                          boolf_comment(E)
                     ],
    DataFmt2b      = [ binary:split(trim_ws(E), <<".">>, [global]) ||
                           E <- DataFmt1,
                                E /= <<>>,
                                boolf_comment(E)
                     ],
    DataFmt2c      = [ lists:reverse(binary:split(trim_ws(E), <<".">>, [global])) ||
                           E <- DataFmt1,
                                E /= <<>>,
                                boolf_comment(E)
                     ],

    %io:format("~p~n", [DataFmt2c]).
    file:write_file("splittrim.txt", io_lib:fwrite("~p~n", [DataFmt2b])).


trim_ws(<<$\s, Rest/binary>>) -> trim_ws(Rest);
trim_ws(Bin) -> Bin.

boolf_comment(A) ->
    case A of
        <<"//", _/binary>> -> false;
        _              -> true
    end.

% #suffix{rule = 'ac', labels = []}.

% [
%  #suffix{rule = 'ac', labels = ['ac',..]},
%  #suffix{rule = 'ad', labels = ['ad',..]},
%  #suffix{rule = 'ae', labels = ['ae',..]},
% ]

% Convert as many data to atoms and numbers.
