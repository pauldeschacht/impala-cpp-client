#include <sys/socket.h>
#include <netinet/in.h>

#include "ImpalaService.h"
#include <transport/TSocket.h>
#include <transport/TBufferTransports.h>
#include <protocol/TBinaryProtocol.h>

using namespace apache::thrift;
using namespace apache::thrift::protocol;
using namespace apache::thrift::transport;

int main(int argc, char **argv) {
  boost::shared_ptr<TSocket> socket(new TSocket("nceoricloud02", 21000));
  boost::shared_ptr<TTransport> transport(new TBufferedTransport(socket));
  boost::shared_ptr<TProtocol> protocol(new TBinaryProtocol(transport));

  impala::ImpalaServiceClient client(protocol);
  transport->open();
  client.PingImpalaService();
 

  beeswax::Results results;
  beeswax::Query query;
  query.query = "SELECT * FROM document LIMIT 10";

  beeswax::QueryHandle queryHandle;
  client.query(queryHandle,query);

  client.fetch(results,queryHandle, false, 100);

  unsigned int num_cols = results.columns.size();
  for(unsigned int i=0; i<results.columns.size(); i++) {
    std::cout << results.columns[i] << std::endl;
  }
  std::cout << std::endl;
  const std::vector<std::string>& data = results.data;
  for(unsigned int i=0; i<data.size(); i++) {
    std::cout << data[i] << " ";
    if (i%num_cols==0) {
      std::cout << std::endl << "----------------------------" << std::endl;
    }
  }
  transport->close();

  return 0;
}
