#include "shared_state.hpp"

shared_state::shared_state(std::string doc_root)
  : doc_root_(std::move(doc_root))
{}
