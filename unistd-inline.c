
#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include <errno.h>

#include "std_core.h"



static inline kk_integer_t kk_alarm_wrapper(kk_integer_t seconds, kk_context_t* _ctx) {
    uint64_t val = (seconds.ibox - 1) / 4;
    return kk_integer_from_small(alarm(val));
}

static inline kk_integer_t kk_fork_wrapper(kk_context_t* _ctx) {
    return kk_integer_from_small(fork());
}

static inline kk_integer_t kk_dup_wrapper(kk_integer_t fd, kk_context_t* _ctx) {
    uint64_t val = (fd.ibox - 1) / 4;
    return kk_integer_from_small(dup(val));
}

static inline kk_integer_t kk_dup2_wrapper(kk_integer_t fd1, kk_integer_t fd2, kk_context_t* _ctx) {
    uint64_t val1 = (fd1.ibox - 1) / 4;
    uint64_t val2 = (fd2.ibox - 1) / 4;
    return kk_integer_from_small(dup2(val1, val2));
}

static inline kk_integer_t kk_close_wrapper(kk_integer_t fd, kk_context_t* _ctx) {
    uint64_t val = (fd.ibox - 1) / 4;
    return kk_integer_from_small(close(val));
}


/*static inline kk_box_t kk_pipe_wrapper(kk_context_t* _ctx) {
    int pipefds_arr[2];
    int ret = pipe(pipefds_arr);
    /*kk_std_core_types__Tuple3_ pipefds;
    pipefds.fst = _kk_box_new_value(ret);
    pipefds.snd = _kk_box_new_value(pipefds_arr[0]);
    pipefds.thd = _kk_box_new_value(pipefds_arr[1]);
    //kk_box_t* pipefds_ptr = kk_box_ptr(pipefds);
    //pipefds_ptr[0] = kk_integer_box(pipefds_arr[0]);
    //pipefds_ptr[1] = kk_integer_box(pipefds_arr[1]);
    return kk_std_core_types__new_dash__lp__comma__comma__rp_(_kk_box_new_value(ret),
                                                              _kk_box_new_value(pipefds_arr[0]),
                                                              _kk_box_new_value(pipefds_arr[1]),_ctx);
    //return kk_integer_from_small(ret);
}*/

/*static inline kk_std_core_list kk_pipe_wrapper(kk_context_t* ctx) {
    int pipefds_arr[2];
    int ret = pipe(pipefds_arr);

    kk_std_core__list result;
    kk_std_core__list read;
    kk_std_core__list write = kk_std_core_new_Cons(kk_reuse_null, kk_integer_box(kk_integer_from_small(pipefds_arr[1])), kk_std_core__new_Nil(ctx),ctx);
    read = kk_std_core_new_Cons(kk_reuse_null, kk_integer_box(kk_integer_from_small(pipefds_arr[0])), write,ctx);
    result = kk_std_core_new_Cons(kk_reuse_null, kk_integer_box(kk_integer_from_small(ret)), read,ctx);
    return result;
}*/

/*
    This is aboslutely terrible, but I will change it once there is good documentation on how to create tuples or lists in the C API for Koka.
*/
static inline kk_integer_t kk_pipe_wrapper(kk_context_t* _ctx) {
    int pipefds_arr[2];
    int ret = pipe(pipefds_arr);
    if (ret == -1) {
        return kk_integer_from_small(-1);
    }
    int encoded_ret = pipefds_arr[0] * 10000 + pipefds_arr[1];
    return kk_integer_from_small(encoded_ret);
}

static inline kk_integer_t kk_write_wrapper_str(kk_integer_t fd, kk_string_t str, kk_integer_t length,kk_context_t* _ctx) {
    uint64_t val = (fd.ibox - 1) / 4;
    uint64_t len = (length.ibox - 1) / 4;
    kk_ssize_t str_length;

    return kk_integer_from_small(write(val, kk_string_cbuf_borrow(str, &str_length), len));
}

static inline kk_integer_t kk_write_wrapper_vec(kk_integer_t fd, kk_vector_t vec, kk_integer_t length,kk_context_t* _ctx) {
    uint64_t val = (fd.ibox - 1) / 4;
    uint64_t len = (length.ibox - 1) / 4;
    kk_ssize_t vec_length;

    return kk_integer_from_small(write(val, kk_vector_buf_borrow(vec, &vec_length), len));
}

/*
    This should return a tuple of (bytes_read, string)
    However, I don't know how to create a tuple in the C API for Koka.
*/
static inline kk_string_t kk_read_wrapper(kk_integer_t fd, kk_integer_t amount, kk_context_t* _ctx) {
    uint64_t val = (fd.ibox - 1) / 4;
    uint64_t len = (amount.ibox - 1) / 4 + 1;
    char* buf = malloc(len);
    memset(buf, 0, len+1);
    int ret = read(val, buf, len);
    if (ret == -1) {
        free(buf);
        return kk_string_alloc_raw("", true, _ctx);
    }
    else if (ret == 0) {
        free(buf);
        errno = 0;
        return kk_string_alloc_raw("", true, _ctx);
    }
    kk_string_t ret_str = kk_string_alloc_raw(buf, false, _ctx);
    free(buf);
    return ret_str;
}


static inline kk_integer_t kk_sleep_wrapper(kk_integer_t secs, kk_context_t* _ctx) {
    uint64_t val = (secs.ibox - 1) / 4;
    return kk_integer_from_small(sleep(val));
}
