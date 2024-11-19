vsim -assertdebug -coverage +access+r top
run -all
acdb save;
acdb report -db fcover.acdb -txt -o cov.txt -verbose
exec cat cov.txt;