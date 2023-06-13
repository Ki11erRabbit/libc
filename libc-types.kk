module libc-types

pub import errno

pub alias pid = int
pub alias flag = int

pub type fileDescriptor
    STDIN
    STDOUT
    STDERR
    Other(fd : int)


pub fun fd(fd : int) : fileDescriptor
    if fd == 0 then
        STDIN
    elif fd == 1 then
        STDOUT
    elif fd == 2 then
        STDERR
    else
        Other(fd)

pub fun int(fd : fileDescriptor) : int
    match fd 
        STDIN -> 0
        STDOUT -> 1
        STDERR -> 2
        Other(fd_) -> fd_

pub type libcResult<a>
    Success(a : a)
    Failure(errno : errno)


pub fun unwrap(res : libcResult<a>) : <exn> a 
    match res
        Success(a) -> a
        Failure(e) -> throw(e.show())