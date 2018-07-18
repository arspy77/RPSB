program writer;

var
	endingfile : file of boolean;
	endingunlock : array [1..5] of boolean;
	i : integer;
begin
	for i:= 1 to 5 do
	begin
		endingunlock[i] := false;
	end;
	assign(endingfile, 'ending.dat');
	rewrite(endingfile);
	for i:= 1 to 5 do
	begin
		write(endingfile, endingunlock[i]);
	end;
	close(endingfile);
end.
