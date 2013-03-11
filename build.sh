#
# http://wiki.apache.org/thrift/ThriftUsageC%2B%2B
#
rm -rf gen-cpp
thrift -gen cpp ./thrift/ImpalaService.thrift
thrift -gen cpp ./thrift/beeswax.thrift
thrift -gen cpp ./thrift/cli_service.thrift
thrift -gen cpp ./thrift/Status.thrift
thrift -gen cpp ./thrift/Types.thrift
thrift -gen cpp ./thrift/hive_metastore.thrift
thrift -gen cpp ./thrift/fb303.thrift

#
# compile generated code
# on Ubuntu 64 bit, uint32 is not known by default ==> add -std=c++0x option
#
cd gen-cpp
rm -rf obj
mkdir obj
g++ -std=c++0x -Wall -I/usr/local/include/thrift -c beeswax_types.cpp -o obj/beeswax_types.o
g++ -std=c++0x -Wall -I/usr/local/include/thrift -c cli_service_types.cpp -o obj/cli_service_types.o
g++ -std=c++0x -Wall -I/usr/local/include/thrift -c fb303_types.cpp -o obj/fb303_types.o
g++ -std=c++0x -Wall -I/usr/local/include/thrift -c hive_metastore_types.cpp -o obj/hive_metastore_types.o
g++ -std=c++0x -Wall -I/usr/local/include/thrift -c ImpalaService_types.cpp -o obj/ImpalaService_types.o
g++ -std=c++0x -Wall -I/usr/local/include/thrift -c Status_types.cpp -o obj/Status_types.o

g++ -std=c++0x -Wall -I/usr/local/include/thrift -c beeswax_constants.cpp -o obj/beeswax_constants.o
g++ -std=c++0x -Wall -I/usr/local/include/thrift -c cli_service_constants.cpp -o obj/cli_service_constants.o
g++ -std=c++0x -Wall -I/usr/local/include/thrift -c fb303_constants.cpp -o obj/fb303_constants.o
g++ -std=c++0x -Wall -I/usr/local/include/thrift -c hive_metastore_constants.cpp -o obj/hive_metastore_constants.o
g++ -std=c++0x -Wall -I/usr/local/include/thrift -c ImpalaService_constants.cpp -o obj/ImpalaService_constants.o
g++ -std=c++0x -Wall -I/usr/local/include/thrift -c Status_constants.cpp -o obj/Status_constants.o

g++ -std=c++0x -Wall -I/usr/local/include/thrift -c ImpalaService.cpp -o obj/ImpalaService.o
g++ -std=c++0x -Wall -I/usr/local/include/thrift -c BeeswaxService.cpp -o obj/BeeswaxService.o

# combine into one object file called "ImpalaClient.o"
cd obj 
ld -r beeswax_types.o beeswax_constants.o cli_service_types.o cli_service_constants.o fb303_types.o fb303_constants.o Status_types.o Status_constants.o ImpalaService_types.o ImpalaService_constants.o ImpalaService.o BeeswaxService.o hive_metastore_constants.o hive_metastore_types.o -o ImpalaClient.o
cd ../..
#
# compile client code for testing
#
cd test
rm -rf obj
mkdir obj
g++ -std=c++0x -Wall -I/usr/local/include/thrift -I../gen-cpp/ -c src/client.cpp -o obj/client.o
#
# link 
#
# for libthrift
export LD_LIBRARY_PATH=/usr/local/lib/

#g++ -std=c++0x -L/usr/local/lib -L../gen-cpp/obj client.o ImpalaService_constants.o ImpalaService_types.o ImpalaService.o beeswax_constants.o beeswax_types.o BeeswaxService.o Status_types.o Status_constants.o hive_metastore_constants.o hive_metastore_types.o -o obj/client -lthrift

g++ -std=c++0x -L/usr/local/lib obj/client.o ../gen-cpp/obj/ImpalaClient.o -o obj/client -lthrift 
