#include <sys/socket.h>



static inline kk_integer_t kk_socket_wrapper(kk_integer_t domain, kk_integer_t type, kk_integer_t protocol, kk_context_t* _ctx) {
    uint64_t val1 = (domain.ibox - 1) / 4;
    uint64_t val2 = (type.ibox - 1) / 4;
    uint64_t val3 = (protocol.ibox - 1) / 4;
    return kk_integer_from_small(socket(val1, val2, val3));
}

