
module unistd

import errno

extern import
    c file "unistd-inline.c"


extern alarm-wrapper(seconds : int) : int
    c "kk_alarm_wrapper"


pub type alarm
    NoAlarm
    TimeLeft(seconds : int)

pub fun alarm(seconds : int) : alarm
    val sec = alarm-wrapper(seconds)
    if sec == 0 then
        NoAlarm
    else
        TimeLeft(sec)


extern dup-wrapper(fd : int) : int
    c "kk_dup_wrapper"

pub type fileDescriptor
    STDIN
    STDOUT
    STDERR
    Other(fd : int)

pub fun int(fd : fileDescriptor) : int
    match fd 
        STDIN -> 0
        STDOUT -> 1
        STDERR -> 2
        Other(fd_) -> fd_

pub fun dup(fd : fileDescriptor) : <exn|_e> libcResult<fileDescriptor>

    val res = dup-wrapper(fd.int())
    if res == -1 then
        Failure(errno())
    else
        Success(Other(res))


extern dup2-wrapper(fd : int, newFd : int) : int
    c "kk_dup2_wrapper"

pub fun dup2(fd : fileDescriptor, newFd : fileDescriptor) : <exn|_e> libcResult<fileDescriptor>
    val res = dup2-wrapper(fd.int(), newFd.int())
    if res == -1 then
        Failure(errno())
    else
        Success(Other(res))

extern close-wrapper(fd : int) : int
    c "kk_close_wrapper"

pub fun close(fd : fileDescriptor) : <exn|_e> libcResult<int>
    val res = close-wrapper(fd.int())
    if res == -1 then
        Failure(errno())
    else
        Success(res)

/*extern pipe-wrapper() : list<int>
    c "kk_pipe_wrapper"

pub fun pipe() : <exn|_e> libcResult<(fileDescriptor, fileDescriptor)>
    val lst = pipe-wrapper()
    match lst[0]
        Nothing -> Failure(errno())
        Just(-1) -> Failure(errno())
        Just(_) -> match lst[1]
            Nothing -> Failure(errno())
            Just(fd1) -> match lst[2]
                Nothing -> Failure(errno())
                Just(fd2) -> Success((Other(fd1), Other(fd2)))*/

extern pipe-wrapper() : int
    c "kk_pipe_wrapper"

pub fun pipe() : <exn|_e> libcResult<(fileDescriptor, fileDescriptor)>
    val res = pipe-wrapper()
    if res == -1 then
        Failure(errno())
    else
        Success((Other(res / 10000), Other(res % 10000)))

extern write-wrapper-str(fd : int, buf : string, count : int) : int
    c "kk_write_wrapper_str"

extern write-wrapper-vec(fd : int, buf : vector<a>, count : int) : int
    c "kk_write_wrapper_vec"


pub fun write(buf : string, fd : fileDescriptor, amount : int) : <io-total,blocking,exn|_e> libcResult<int>
    val res = write-wrapper-str(fd.int(), buf, amount)
    if res == -1 then
        Failure(errno())
    else
        Success(res)

pub fun write(buf : vector<a>, fd : fileDescriptor) : <io-total,blocking,exn|_e> libcResult<int>
    val res = write-wrapper-vec(fd.int(), buf, buf.length())
    if res == -1 then
        Failure(errno())
    else
        Success(res)


extern read-wrapper(fd : int, count : int) : string
    c "kk_read_wrapper"

pub fun read(fd : fileDescriptor, amount : int) : <io-total,blocking,exn|_e> libcResult<string>
    val res = read-wrapper(fd.int(), amount)
    if res == "" then
        match errno()
            NOERROR -> Success(res)
            _ -> Failure(errno())
    else
        Success(res)

extern fork-wrapper() : int
    c "kk_fork_wrapper"

pub type fork :: X

type forkResult 
    Parent(pid : int)
    Child

pub fun fork() : <fork,exn|_e> libcResult<forkResult>
    val pid = fork-wrapper()
    if pid == 0 then
        Success(Child)
    elif pid == -1 then
        Failure(errno())
    else
        Success(Parent(pid))



extern sleep-wrapper(seconds : int) : int
    c "kk_sleep_wrapper"

pub fun sleep(seconds : int) : <exn|_e> libcResult<int>
    val res = sleep-wrapper(seconds)
    if res == -1 then
        Failure(errno())
    else
        Success(res)


fun main() {

    val pipe = pipe()
    val (read_end, write_end) = match pipe 
        Success(pair) -> pair
        Failure(errno) -> {
            println("Error: " ++ errno.show())
            (STDIN, STDOUT)
        }

    
    "writing to pipe\n".write(write_end,16)


    val str = read(read_end, 16)

    match str
        Success(str) -> println("read from pipe: " ++ str)
        Failure(errno) -> println("Error: " ++ errno.show())

   
    
}