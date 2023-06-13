#include <fcntl.h>
#include <stdint.h>




static inline kk_integer_t kk_open_wrapper(kk_string_t path, kk_integer_t flags, kk_context_t* _ctx) {
    uint64_t val = (flags.ibox - 1) / 4;
    kk_ssize_t path_length;

    kk_integer_t ret = kk_integer_from_small(open(kk_string_cbuf_borrow(path, &path_length), val));
    kk_string_drop(path, _ctx);
    return ret;
}


static inline kk_integer_t kk_fcntl_wrapper_void(kk_integer_t fd, kk_integer_t cmd, kk_context_t* _ctx) {
    uint64_t file_descriptor = (fd.ibox - 1) / 4;
    uint64_t val = (cmd.ibox - 1) / 4;
    return kk_integer_from_small(fcntl(file_descriptor, val));
}

static inline kk_integer_t kk_fcntl_wrapper_arg(kk_integer fd, kk_integer_t cmd, kk_integer_t arg, kk_context_t* _ctx) {
    uint64_t file_descriptor = (fd.ibox - 1) / 4;
    uint64_t val = (cmd.ibox - 1) / 4;
    uint64_t arg_val = (arg.ibox - 1) / 4;
    return kk_integer_from_small(fcntl(file_descriptor, val, arg_val));
}

/*static inline kk_integer_t kk_fcntl_wrapper_rw_hint(kk_integer fd, kk_integer cmd, kk_context_t* _ctx) {
    uint64_t file_descriptor = (fd.ibox - 1) / 4;
    uint64_t val = (cmd.ibox - 1) / 4;
    uint64_t  kk_integer_from_small(fcntl(file_descriptor, val, 0));
}*/