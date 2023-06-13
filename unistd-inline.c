
#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include <errno.h>



static inline kk_integer_t kk_alarm_wrapper(kk_integer_t seconds, kk_context_t* _ctx) {
    uint64_t val = (seconds.ibox - 1) / 4;
    return kk_integer_from_small(alarm(val));
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

    kk_integer_t ret = kk_integer_from_small(write(val, kk_string_cbuf_borrow(str, &str_length), len));
    kk_string_drop(str, _ctx);
    return ret;
}

static inline kk_integer_t kk_write_wrapper_vec(kk_integer_t fd, kk_vector_t vec, kk_integer_t length,kk_context_t* _ctx) {
    uint64_t val = (fd.ibox - 1) / 4;
    uint64_t len = (length.ibox - 1) / 4;
    kk_ssize_t vec_length;

    kk_integer_t ret = kk_integer_from_small(write(val, kk_vector_buf_borrow(vec, &vec_length), len));
    kk_vector_drop(vec, _ctx);
    return ret;
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

    kk_string_t ret_str = kk_string_alloc_from_qutf8(buf, _ctx);
    free(buf);
    return ret_str;
}

//
//  Process management
//

static inline kk_integer_t kk_fork_wrapper(kk_context_t* _ctx) {
    return kk_integer_from_small(fork());
}


static inline kk_integer_t kk_execv_wrapper(kk_string_t path, kk_vector_t args, kk_context_t* _ctx) {
    kk_ssize_t path_length;
    const char* path_buf = kk_string_cbuf_borrow(path, &path_length);
    char** args_buf = malloc(sizeof(char*) * (kk_vector_len_borrow(args) + 1));
    for (kk_ssize_t i = 0; i < kk_vector_len_borrow(args); i++) {
        kk_box_t arg = kk_vector_at_borrow(args, i);
        kk_ssize_t arg_length;
        args_buf[i] = kk_string_cbuf_borrow(kk_string_unbox(arg), &arg_length);
    }
    args_buf[kk_vector_len_borrow(args)] = NULL;
    int ret = execv(path_buf, args_buf);
    free(args_buf);
    kk_string_drop(path, _ctx);
    kk_vector_drop(args, _ctx);
    return kk_integer_from_small(ret);
}

static inline kk_integer_t kk_getpid_wrapper(kk_context_t* _ctx) {
    return kk_integer_from_small(getpid());
}

static inline kk_integer_t kk_getppid_wrapper(kk_context_t* _ctx) {
    return kk_integer_from_small(getppid());
}

static inline kk_integer_t kk_getpgrp_wrapper(kk_context_t* _ctx) {
    return kk_integer_from_small(getpgrp());
}

static inline kk_integer_t kk_getpgid_wrapper(kk_integer_t pid, kk_context_t* _ctx) {
    uint64_t val = (pid.ibox - 1) / 4;
    return kk_integer_from_small(getpgid(val));
}



static inline kk_integer_t kk_sleep_wrapper(kk_integer_t secs, kk_context_t* _ctx) {
    uint64_t val = (secs.ibox - 1) / 4;
    return kk_integer_from_small(sleep(val));
}
