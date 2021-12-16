#pragma once

#include <memory>
#include <string>
#include <unordered_set>

// Represents the shared server state
class shared_state {
  std::string doc_root_;

public:
  explicit shared_state(std::string doc_root);

  std::string const &doc_root() const noexcept { return doc_root_; }
};
