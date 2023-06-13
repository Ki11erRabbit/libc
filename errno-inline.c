#include <errno.h>


static inline kk_integer_t kk_get_errno(kk_context_t* _ctx) {
  return kk_integer_from_small(errno);
}