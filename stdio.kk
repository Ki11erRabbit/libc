module stdio

import libc-types

extern import
    c file "stdio-inline.c"

pub alias flag = int

// An alias to a pointer to be used for file handles
// aka FILE*
pub alias file = int


pub extern eprint(str : string) : <console> ()
    c "kk_eprint"

pub extern eprintln(str : string) : <console> ()
    c "kk_eprintln"

extern init_stdin() : int
    c "kk_initialize_stdin"

extern init_stdout() : int
    c "kk_initialize_stdout"

extern init_stderr() : int
    c "kk_initialize_stderr"


pub val stdin = init_stdin()
pub val stdout = init_stdout()
pub val stderr = init_stderr()

pub extern fprint(f : file, str : string) : <console,fsys> ()
    c "kk_fprint"


extern fflush_wrapper(f : file) : int
    c "kk_fflush_wrapper"

pub fun flush(f : maybe<file>) : <console,fsys,exn|_e> libcResult<int>
    val res = match f
        Just(file) -> fflush_wrapper(file)
        Nothing -> fflush_wrapper(0)
    if res == 0 then
        Success(res)
    else
        Failure(errno())


extern fopen_wrapper(path : string, mode : string) : file
    c "kk_fopen_wrapper"

pub fun fopen(path : string, mode : string) : <fsys,exn|_e> libcResult<file>
    val res = fopen_wrapper(path, mode)
    if res == 0 then
        Failure(errno())
    else
        Success(res)

extern fclose_wrapper(f : file) : int
    c "kk_fclose_wrapper"

pub fun fclose(f : file) : <console,fsys,exn|_e> libcResult<int>
    val res = fclose_wrapper(f)
    if res == 0 then
        Success(res)
    else
        Failure(errno())

extern fileno_wrapper(f : file) : int
    c "kk_fileno_wrapper"

pub fun fileno(file : file) : <fsys,exn|_e> libcResult<fileDescriptor>
    val res = fileno_wrapper(file)
    if res == 0 then
        Failure(errno())
    else
        Success(res.fd())


pub extern perror(str : string) : <console> ()
    c "kk_perror"


pub fun main() 
    val file = match fopen("test.txt", "w")
        Success(f) -> f
        Failure(e) -> {
            eprintln("Error opening file")
            2
        }
    
    fprint(file, "Hello, world!\n")

    match fclose(file)
        Success(_) -> ()
        Failure(e) -> {
            eprintln("Error closing file")
            ()
        }
