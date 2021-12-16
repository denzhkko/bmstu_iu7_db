#pragma once

#include "beast.hpp"
#include "net.hpp"
#include "shared_state.hpp"
#include <boost/asio.hpp>
#include <cstdlib>
#include <memory>

/** Represents an established HTTP connection
 */
class http_session : public std::enable_shared_from_this<http_session> {
  tcp::socket socket_;
  beast::flat_buffer buffer_;
  std::shared_ptr<shared_state> state_;
  http::request<http::string_body> req_;
  net::io_context &ioc_;

  void fail(error_code ec, char const *what);
  void on_read(error_code ec, std::size_t);
  void do_write(http::response<http::string_body> const &res);
  void on_write(error_code ec, std::size_t, bool close);

public:
  http_session(tcp::socket socket, std::shared_ptr<shared_state> const &state,
               net::io_context &ioc);

  void run();
};
