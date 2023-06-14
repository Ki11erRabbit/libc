#include <stdio.h>
#include <stdint.h>

static inline void kk_eprint(kk_string_t str, kk_context_t* _ctx) {
    kk_ssize_t str_length;
    fprintf(stderr, "%s", kk_string_cbuf_borrow(str, &str_length));
    kk_string_drop(str, _ctx);
}


static inline void kk_eprintln(kk_string_t str, kk_context_t* _ctx) {
    kk_ssize_t str_length;
    fprintf(stderr, "%s\n", kk_string_cbuf_borrow(str, &str_length));
    kk_string_drop(str, _ctx);
}


static inline kk_integer_t kk_initialize_stdin(kk_context_t* _ctx) {
    return kk_integer_from_small((uint64_t)stdin);
}
static inline kk_integer_t kk_initialize_stdout(kk_context_t* _ctx) {
    return kk_integer_from_small((uint64_t)stdout);
}
static inline kk_integer_t kk_initialize_stderr(kk_context_t* _ctx) {
    return kk_integer_from_small((uint64_t)stderr);
}

static inline void kk_fprint(kk_integer_t fileptr, kk_string_t str, kk_context_t* _ctx) {
    kk_ssize_t str_length;
    FILE* file = (FILE*)((fileptr.ibox - 1) / 4);
    fprintf(file, "%s", kk_string_cbuf_borrow(str, &str_length));
    kk_string_drop(str, _ctx);
}

static inline void kk_fprintln(kk_integer_t fileptr, kk_string_t str, kk_context_t* _ctx) {
    kk_ssize_t str_length;
    FILE* file = (FILE*)((fileptr.ibox - 1) / 4);
    fprintf(file, "%s\n", kk_string_cbuf_borrow(str, &str_length));
    kk_string_drop(str, _ctx);
}

static inline kk_integer_t kk_fflush_wrapper(kk_integer_t fileptr, kk_context_t* _ctx) {
    FILE* file = (FILE*)((fileptr.ibox - 1) / 4);
    return kk_integer_from_small(fflush(file));
}

static inline kk_integer_t kk_fopen_wrapper(kk_string_t pathname, kk_string_t mode, kk_context_t* _ctx) {
    kk_ssize_t path_length;
    kk_ssize_t mode_length;
    FILE* file = fopen(kk_string_cbuf_borrow(pathname, &path_length), kk_string_cbuf_borrow(mode, &mode_length));
    kk_string_drop(pathname, _ctx);
    kk_string_drop(mode, _ctx);

    if (file == NULL) {
        return kk_integer_from_small(0);
    }
    return kk_integer_from_small((uint64_t)file);
}

static inline kk_integer_t kk_fclose_wrapper(kk_integer_t fileptr, kk_context_t* _ctx) {
    FILE* file = (FILE*)((fileptr.ibox - 1) / 4);
    return kk_integer_from_small(fclose(file));
}

static inline kk_integer_t kk_fileno_wrapper(kk_integer_t fileptr, kk_context_t* _ctx) {
    FILE* file = (FILE*)((fileptr.ibox - 1) / 4);
    return kk_integer_from_small(fileno(file));
}



static inline void kk_perror(kk_string_t str, kk_context_t* _ctx) {
    kk_ssize_t str_length;
    perror(kk_string_cbuf_borrow(str, &str_length));
    kk_string_drop(str, _ctx);
}