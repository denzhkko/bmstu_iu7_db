#include "http_session.hpp"
#include <iostream>
#include <string>

#include <ozo/connection_info.h>
#include <ozo/request.h>
#include <ozo/shortcuts.h>

#include <inja/inja.hpp>

// Append an HTTP rel-path to a local filesystem path.
// The returned path is normalized for the platform.
std::string path_cat(boost::beast::string_view base,
                     boost::beast::string_view path) {
  if (base.empty())
    return path.to_string();
  std::string result = base.to_string();
#if BOOST_MSVC
  char constexpr path_separator = '\\';
  if (result.back() == path_separator)
    result.resize(result.size() - 1);
  result.append(path.data(), path.size());
  for (auto &c : result)
    if (c == '/')
      c = path_separator;
#else
  char constexpr path_separator = '/';
  if (result.back() == path_separator)
    result.resize(result.size() - 1);
  result.append(path.data(), path.size());
#endif
  return result;
}

http_session::http_session(tcp::socket socket,
                           std::shared_ptr<shared_state> const &state,
                           net::io_context &ioc)
    : socket_(std::move(socket)), state_(state), ioc_(ioc) {}

void http_session::run() {
  // Read a request
  http::async_read(
      socket_, buffer_, req_,
      [self = shared_from_this()](error_code ec, std::size_t bytes) {
        self->on_read(ec, bytes);
      });
}

// Report a failure
void http_session::fail(error_code ec, char const *what) {
  // Don't report on canceled operations
  if (ec == net::error::operation_aborted)
    return;

  std::cerr << what << ": " << ec.message() << "\n";
}

void http_session::on_read(error_code ec, std::size_t) {
  // This means they closed the connection
  if (ec == http::error::end_of_stream) {
    socket_.shutdown(tcp::socket::shutdown_send, ec);
    return;
  }

  // Handle the error, if any
  if (ec)
    return fail(ec, "read");

  std::cout << req_.target() << std::endl;
  if ("/song_cnt" == req_.target()) {
    std::cout << "DB request required" << std::endl;
    //    ozo::rows_of<std::int64_t> rows;
    auto rows_ptr = std::make_shared<ozo::rows_of<std::int64_t>>();

    ozo::connection_info conn_info("host=localhost port=5432 user=deniska "
                                   "password=deniska dbname=musicdb");

    using namespace ozo::literals;

    const auto query = "SELECT count(*) FROM songs"_SQL;

    ozo::request(
        ozo::make_connector(conn_info, ioc_), query, ozo::into(*rows_ptr),
        [self = shared_from_this(), rows_ptr, query](ozo::error_code ec,
                                                     auto conn) {
          if (ec) {
            std::cerr << ec.message() << ozo::error_message(conn) << std::endl;
            return;
          }

          std::int64_t answer = std::get<0>((*rows_ptr)[0]);

          inja::json data;
          data["title"] = std::string{"Scalar request"};
          data["query"] = ozo::to_const_char(query.build().text);
          data["res"] = answer;

          inja::Environment env;
          inja::Template temp = env.parse_template("./templates/scaler.html");
          std::string page = env.render(temp, data);

          http::response<http::string_body> res{http::status::bad_request,
                                                self->req_.version()};
          res.set(http::field::server, BOOST_BEAST_VERSION_STRING);
          res.set(http::field::content_type, "text/html");
          res.keep_alive(self->req_.keep_alive());
          res.body() = page;
          res.prepare_payload();

          self->do_write(res);
        });
  } else if ("/table" == req_.target()) {
    std::cout << "ttt" << std::endl;
    std::cout << "DB request required" << std::endl;
    //    ozo::rows_of<std::int64_t> rows;
    auto rows_ptr = std::make_shared<ozo::rows_of<std::string, std::string>>();

    ozo::connection_info conn_info("host=localhost port=5432 user=deniska "
                                   "password=deniska dbname=musicdb");

    using namespace ozo::literals;

    const auto query =
        "SELECT b.name, s.name FROM songs s  JOIN rel_bands_sing_songs r ON s.id = r.id_song JOIN bands b ON r.id_band = b.id WHERE s.language = 'English' "_SQL;

    ozo::request(
        ozo::make_connector(conn_info, ioc_), query, ozo::into(*rows_ptr),
        [self = shared_from_this(), rows_ptr, query](ozo::error_code ec,
                                                     auto conn) {
          if (ec) {
            std::cerr << ec.message() << ozo::error_message(conn) << std::endl;
            return;
          }

          inja::json data;
          data["table"] = *rows_ptr;
          data["query"] = ozo::to_const_char(query.build().text);
          data["tablename"] = "Песни на русском";

          inja::Environment env;
          inja::Template temp = env.parse_template("./templates/table.html");
          std::string page = env.render(temp, data);

          http::response<http::string_body> res{http::status::bad_request,
                                                self->req_.version()};
          res.set(http::field::server, BOOST_BEAST_VERSION_STRING);
          res.set(http::field::content_type, "text/html");
          res.keep_alive(self->req_.keep_alive());
          res.body() = page;
          res.prepare_payload();

          self->do_write(res);
        });
  } else {
    http::response<http::string_body> res{http::status::bad_request,
                                          req_.version()};
    res.set(http::field::server, BOOST_BEAST_VERSION_STRING);
    res.set(http::field::content_type, "text/html");
    res.keep_alive(req_.keep_alive());
    res.body() = std::string{"Deniska"};
    res.prepare_payload();

    do_write(res);
  }
}

void http_session::do_write(http::response<http::string_body> const &res) {
  using response_type = typename std::decay<decltype(res)>::type;
  auto sp = std::make_shared<response_type>(std::forward<decltype(res)>(res));

  auto self = shared_from_this();
  http::async_write(this->socket_, *sp,
                    [self, sp](error_code ec, std::size_t bytes) {
                      self->on_write(ec, bytes, sp->need_eof());
                    });
}

void http_session::on_write(error_code ec, std::size_t, bool close) {
  // Handle the error, if any
  if (ec)
    return fail(ec, "write");

  if (close) {
    // This means we should close the connection, usually because
    // the response indicated the "Connection: close" semantic.
    socket_.shutdown(tcp::socket::shutdown_send, ec);
    return;
  }

  // Clear contents of the request message,
  // otherwise the read behavior is undefined.
  req_ = {};

  // Read another request
  http::async_read(
      socket_, buffer_, req_,
      [self = shared_from_this()](error_code ec, std::size_t bytes) {
        self->on_read(ec, bytes);
      });
}
