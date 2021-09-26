-module(tld).
-export([refresh/0]).

-define(TMPFILE, "public_suffix_list.dat").

%% ============
%%     API
%% ============
refresh() ->
    io:format("===== Currently refreshing..."),
    os:cmd("curl https://publicsuffix.org/list/public_suffix_list.dat -o " ++ ?TMPFILE),
    refresh(file, ?TMPFILE),
    io:format("===== Process completed.~n").

refresh(file, File) ->
    {ok, Data}   = file:read(File),
    ParsedBin    = binary:split(Data, <<"\n">>, [global]),
    ContentLines = [ strip(ContentLine) || ContentLine <- ParsedBin ].




