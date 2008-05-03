rem wsdl2h http://www.cs.fsu.edu/~engelen/calc.wsdl -s -o calc.h
wsdl2h http://218.28.10.208:8080/wsdl/calc.wsdl -s -o calc.h
soapcpp2 -S calc.h