#pragma once

#include "net.hpp"
#include <memory>
#include <string>

// Forward declaration
class shared_state;

// Accepts incoming connections and launches the sessions
class listener : public std::enable_shared_from_this<listener>
{
  tcp::acceptor acceptor_;
  tcp::socket socket_;
  std::shared_ptr<shared_state> state_;

  void fail(error_code ec, char const* what);
  void on_accept(error_code ec);

public:
  listener(net::io_context& ioc,
           tcp::endpoint endpoint,
           std::shared_ptr<shared_state> const& state);

  // Start accepting incoming connections
  void run();
};
