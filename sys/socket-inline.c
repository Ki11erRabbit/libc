#include <sys/socket.h>
#include <arpa/inet.h>
#include <string.h>

#include <stdint.h>


static inline kk_integer_t kk_bitwise_or(kk_integer_t a, kk_integer_t b, kk_context_t* _ctx) {
    uint64_t val1 = (a.ibox - 1) / 4;
    uint64_t val2 = (b.ibox - 1) / 4;
    return kk_integer_from_small(val1 | val2);
}


/*static inline kk_integer_t kk_addr_wrapper(kk_integer_t type, kk_string_t addr, kk_context_t* _ctx) {
    uint64_t protocol = (type.ibox - 1) / 4;
    if (protocol == AF_INET) {
        struct sockaddr_in addr_in;
        addr_in.sin_family = protocol;
        addr_in.sin_port = 0;
        addr_in.sin_addr.s_addr = inet_addr(kk_string_cbuf_borrow(addr, NULL));

        if (addr_in.sin_addr.s_addr == -1) {
            return kk_integer_from_small(-1);
        }

        return kk_integer_from_small(addr_in.sin_addr);
    }
    else if (protocol == AF_INET6) {
        struct sockaddr_in6 addr_in6;
        addr_in6.sin6_family = protocol;
        int res = inet_pton(AF_INET6, kk_string_cbuf_borrow(addr, NULL), &addr_in6.sin6_addr);
        if (res == -1) {
            return kk_integer_from_small(-1);
        }
        return kk_integer_from_small((*(long long*)addr_in6.sin6_addr));
    }
}*/


static inline kk_integer_t kk_socket_wrapper(kk_integer_t domain, kk_integer_t type, kk_integer_t protocol, kk_context_t* _ctx) {
    uint64_t val1 = (domain.ibox - 1) / 4;
    uint64_t val2 = (type.ibox - 1) / 4;
    uint64_t val3 = (protocol.ibox - 1) / 4;
    return kk_integer_from_small(socket(val1, val2, val3));
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

static inline kk_integer_t kk_setsockopt_wrapper(kk_integer_t socketfd, kk_integer_t level, kk_integer_t optname, kk_vector_t optval, kk_context_t* _ctx) {
    uint64_t socket_fd = (socketfd.ibox - 1) / 4;
    uint64_t lvl = (level.ibox - 1) / 4;
    uint64_t opt_name = (optname.ibox - 1) / 4;
    uint32_t *opt_val = malloc(sizeof(uint32_t) * kk_vector_len_borrow(optval));
    for (kk_ssize_t i = 0; i < kk_vector_len_borrow(optval); i++) {
        kk_box_t arg = kk_vector_at_borrow(optval, i);
        opt_val[i] = (arg.box - 1) / 4;
    }

    int ret = setsockopt(socket_fd, lvl, opt_name, opt_val, kk_vector_len_borrow(optval));
    free(opt_val);
    kk_vector_drop(optval, _ctx);
    return kk_integer_from_small(ret);
}

static inline kk_integer_t kk_bind_wrapper_ipv4(kk_integer_t socketfd, kk_integer_t family, kk_integer_t port, kk_string_t address, kk_context_t* _ctx) {
    u_int32_t socket_fd = (socketfd.ibox - 1) / 4;
    struct sockaddr_in addr;
    addr.sin_family = (family.ibox - 1) / 4;
    addr.sin_port = (port.ibox - 1) / 4;
    addr.sin_addr.s_addr = inet_addr(kk_string_cbuf_borrow(address, NULL));

    if (addr.sin_addr.s_addr == -1) {
        return kk_integer_from_small(-1);
    }

    int ret = bind(socket_fd, (struct sockaddr*)&addr, sizeof(addr));
    return kk_integer_from_small(ret);
}

static inline kk_integer_t kk_bind_wrapper_ipv6(kk_integer_t socketfd, kk_integer_t family, kk_integer_t port, kk_integer_t flowinfo, kk_string_t address, kk_integer_t scope_id, kk_context_t* _ctx) {
    u_int32_t socket_fd = (socketfd.ibox - 1) / 4;
    struct sockaddr_in6 addr;
    addr.sin6_family = (family.ibox - 1) / 4;
    addr.sin6_port = (port.ibox - 1) / 4;
    addr.sin6_flowinfo = (flowinfo.ibox - 1) / 4;
    int res = inet_pton(AF_INET6, kk_string_cbuf_borrow(address, NULL), &addr.sin6_addr);
    if (res == -1) {
        return kk_integer_from_small(-1);
    }
    /*u_int64_t temp = (address.ibox - 1) / 4;
    //u_int8_t addr[16] = &temp;
    memcpy(addr.sin6_addr.s6_addr, &temp, 16);*/
    addr.sin6_scope_id = (scope_id.ibox - 1) / 4;

    int ret = bind(socket_fd, (struct sockaddr*)&addr, sizeof(addr));
    return kk_integer_from_small(ret);
}




static inline kk_integer_t kk_accept_wrapper_ipv4(kk_integer_t socketfd, kk_integer_t family, kk_integer_t port, kk_string_t address, kk_context_t* _ctx) {
    u_int32_t socket_fd = (socketfd.ibox - 1) / 4;
    struct sockaddr_in addr;
    addr.sin_family = (family.ibox - 1) / 4;
    addr.sin_port = (port.ibox - 1) / 4;
    addr.sin_addr.s_addr = inet_addr(kk_string_cbuf_borrow(address, NULL));

    if (addr.sin_addr.s_addr == -1) {
        return kk_integer_from_small(-1);
    }

    u_int32_t addr_size = sizeof(addr);
    
    return kk_integer_from_small(accept(socket_fd, (struct sockaddr*)&addr, addr_size));
}


static inline kk_integer_t kk_accept_wrapper_ipv6(kk_integer_t socketfd, kk_integer_t family, kk_integer_t port, kk_integer_t flowinfo,kk_string_t address, kk_integer_t scope_id, kk_context_t* _ctx) {
    u_int32_t socket_fd = (socketfd.ibox - 1) / 4;
    struct sockaddr_in6 addr;
    addr.sin6_family = (family.ibox - 1) / 4;
    addr.sin6_port = (port.ibox - 1) / 4;
    addr.sin6_flowinfo = (flowinfo.ibox - 1) / 4;
    int res = inet_pton(AF_INET6, kk_string_cbuf_borrow(address, NULL), &addr.sin6_addr);
    if (res == -1) {
        return kk_integer_from_small(-1);
    }
    /*u_int64_t temp = (address.ibox - 1) / 4;
    //u_int8_t addr[16] = &temp;
    memcpy(addr.sin6_addr.s6_addr, &temp, 16);*/
    addr.sin6_scope_id = (scope_id.ibox - 1) / 4;

    u_int32_t addr_size = sizeof(addr);
    
    return kk_integer_from_small(accept(socket_fd, (struct sockaddr*)&addr, &addr_size));
}


static inline kk_integer_t kk_listen_wrapper(kk_integer_t socketfd, kk_integer_t backlog, kk_context_t* _ctx) {
    u_int32_t socket_fd = (socketfd.ibox - 1) / 4;
    u_int32_t back_log = (backlog.ibox - 1) / 4;
    return kk_integer_from_small(listen(socket_fd, back_log));
}