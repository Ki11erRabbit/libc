
module fcntl

import libc-types

extern import
    c file "fcntl-inline.c"

val linux_specific_base : int = 1024

/* open/fcntl */
pub val o_accmode : int = 3
pub val o_rdonly : int = 0
pub val o_wronly : int = 1
pub val o_rdwr   : int = 2
pub val o_creat  : int = 64 // Not fcntl
pub val o_excl   : int = 128 // Not fcntl
pub val o_noctty : int = 256 // Not fcntl
pub val o_trunc  : int = 512 // Not fcntl
pub val o_append : int = 1024
pub val o_nonblock : int = 2048
pub val o_ndelay : int = o_nonblock
pub val o_sync   : int = 1052672
pub val o_fsync  : int = o_sync
pub val o_async  : int = 8192


extern open_wrapper(path : string, flags : int) : int
    c "kk_open_wrapper"

pub fun open(path : string, flags : int) : <exn|_e> libcResult<fileDescriptor>
    val file = open_wrapper(path, flags)
    if file == -1 then
        return Failure(errno())
    else
        return Success(file.fd())


/* fcntl second argument */

pub val f_dupfd : flag = 0
pub val f_getfd : flag = 1
pub val f_setfd : flag = 2
pub val f_getfl : flag = 3
pub val f_setfl : flag = 4  

/* for SetLease and GetLease */
pub type lease
    RDLCK
    WRLCK
    UNLCK

fun int(l : lease) : int
    match l
        RDLCK -> 0
        WRLCK -> 1
        UNLCK -> 2

fun lease(i : int) : <exn|_e> lease
    match i
        0 -> RDLCK
        1 -> WRLCK
        2 -> UNLCK

/* flags for Notify */
pub val dn_access : flag = 0x00000001
pub val dn_modify : flag = 0x00000002
pub val dn_create : flag = 0x00000004
pub val dn_delete : flag = 0x00000008
pub val dn_rename : flag = 0x00000010
pub val dn_attrib : flag = 0x00000020
pub val dn_multishot : flag = 0x80000000

/* seals */
pub val seal_seal : int = 0x0001
pub val seal_shrink : int = 0x0002
pub val seal_grow : int = 0x0004
pub val seal_write : int = 0x0008
pub val seal_future_write : int = 0x0010

/* rw hints */
pub type rwHint
    WriteLifeNotSet
    WriteLifeNone
    WriteLifeShort
    WriteLifeMedium
    WriteLifeLong
    WriteLifeExtreme

fun int(hint : rwHint) : int 
    match hint 
        WriteLifeNotSet -> 0
        WriteLifeNone -> 1
        WriteLifeShort -> 2
        WriteLifeMedium -> 3
        WriteLifeLong -> 4
        WriteLifeExtreme -> 5

pub type fcntlOp
    // Duplicating a file descriptor
    DupFd(fd : fileDescriptor)
    DupCloexecFd(fd : fileDescriptor)
    // File descriptor flags
    GetFd
    SetFd(flags : flag)
    // File status flags
    GetFl
    SetFl(flags : int)
    // Advisory record locking
    /*
    Setlk(flock : flock)
    Setlkw(flock : flock)
    Getlk(flock : flock)
    // Open file description locks (non-POSIX)
    FdSetLk(flock : flock)
    FdSetLkw(flock : flock)
    FdGetLk(flock : flock)
    */
    // Managing signals
    GetOwn
    SetOwn(pid: pid)
    /*
    GetOwnEx(owner : owner_ex)
    SetOwnEx(owner : owner_ex)
    */
    GetSig
    SetSig(sig : int)
    // Leases
    SetLease(lease : lease)
    GetLease
    // File and directory change notification (dnotify)
    Notify(flag : flag)
    // Changing the capacity of a pipe
    SetPipeSize(size : int)
    GetPipeSize
    // File Sealing
    AddSeals(seals : int)
    GetSeals
    // File read/write hints
    /*GetRwHint
    SetRwHint(hint : rwHint)
    GetFileRwHint
    SetFileRwHint(hint : rwHint)*/

fun int(op : fcntlOp) : int 
    match op {
        DupFd(_) -> 0
        DupCloexecFd(_) -> linux_specific_base + 6
        GetFd -> 1
        SetFd(_) -> 2
        GetFl -> 3
        SetFl(_) -> 4
        GetOwn -> 9
        SetOwn(_) -> 8
        GetSig -> 11
        SetSig(_) -> 10
        GetLease -> linux_specific_base + 1
        SetLease(_) -> linux_specific_base + 0
        Notify(_) -> linux_specific_base + 2
        GetPipeSize -> linux_specific_base + 7
        SetPipeSize(_) -> linux_specific_base + 7
        AddSeals(_) -> linux_specific_base + 9
        GetSeals -> linux_specific_base + 10
        /*GetRwHint(_) -> linux_specific_base + 11
        SetRwHint(_) -> linux_specific_base + 12
        GetFileRwHint(_) -> linux_specific_base + 13
        SetFileRwHint(_) -> linux_specific_base + 14*/

    }

pub type fcntlResult
    Dup_Fd(fd : fileDescriptor)
    GetFdFlags(flags : flag)
    GetFlFlags(flags : flag)
    GetFdLease(lease : lease)
    GetFdOwn(pid : pid)
    GetSignal(sig : int)
    PipeSize(size : int)
    GetFdSeals(seals : int)
    //GetRwHint(hint : rwHint)
    FcntlSuccess


extern fcntl_wrapper_void(fd : int, cmd : int) : int
    c "kk_fcntl_wrapper_void"

extern fcntl_wrapper_arg(fd : int, cmd : int, arg : int) : int
    c "kk_fcntl_wrapper_arg"


pub fun fcntl(fd : fileDescriptor, cmd : fcntlOp) : <exn|_e> libcResult<fcntlResult>
    match cmd {
        DupFd(fd2) -> {
            val res : int = fcntl_wrapper_arg(fd.int(), cmd.int(), fd2.int())
            if res == -1 then
                return Failure(errno())
            else
                return Success(Dup_Fd(libc-types/fd(res)))
        }
        DupCloexecFd(fd2) -> {
            val res : int = fcntl_wrapper_arg(fd.int(), cmd.int(), fd2.int())
            if res == -1 then
                return Failure(errno())
            else
                return Success(Dup_Fd(libc-types/fd(res)))
        }
        GetFd -> {
            val res = fcntl_wrapper_void(fd.int(), cmd.int())
            if res == -1 then
                return Failure(errno())
            else
                return Success(GetFdFlags(res))
        }
        SetFd(flags) -> {
            val res = fcntl_wrapper_arg(fd.int(), cmd.int(), flags)
            if res == -1 then
                return Failure(errno())
            else
                return Success(FcntlSuccess)
        }
        GetFl -> {
            val res = fcntl_wrapper_void(fd.int(), cmd.int())
            if res == -1 then
                return Failure(errno())
            else
                return Success(GetFlFlags(res))
        }
        SetFl(flags) -> {
            val res = fcntl_wrapper_arg(fd.int(), cmd.int(), flags)
            if res == -1 then
                return Failure(errno())
            else
                return Success(FcntlSuccess)
        }
        GetOwn -> {
            val res = fcntl_wrapper_void(fd.int(), cmd.int())
            if res == -1 then
                return Failure(errno())
            else
                return Success(GetFdOwn(res))
        }
        SetOwn(pid) -> {
            val res = fcntl_wrapper_arg(fd.int(), cmd.int(), pid)
            if res == -1 then
                return Failure(errno())
            else
                return Success(FcntlSuccess)
        }
        GetSig -> {
            val res = fcntl_wrapper_void(fd.int(), cmd.int())
            if res == -1 then
                return Failure(errno())
            else
                return Success(GetSignal(res))
        }
        SetSig(sig) -> {
            val res = fcntl_wrapper_arg(fd.int(), cmd.int(), sig)
            if res == -1 then
                return Failure(errno())
            else
                return Success(FcntlSuccess)
        }
        SetLease(lease) -> {
            val res = fcntl_wrapper_arg(fd.int(), cmd.int(), lease.int())
            if res == -1 then
                return Failure(errno())
            else
                return Success(FcntlSuccess)
        }
        GetLease -> {
            val res = fcntl_wrapper_void(fd.int(), cmd.int())
            if res == -1 then
                return Failure(errno())
            else
                return Success(GetFdLease(res.lease()))
        }
        Notify(flag) -> {
            val res = fcntl_wrapper_arg(fd.int(), cmd.int(), flag)
            if res == -1 then
                return Failure(errno())
            else
                return Success(FcntlSuccess)
        }
        SetPipeSize(size) -> {
            val res = fcntl_wrapper_arg(fd.int(), cmd.int(), size)
            if res == -1 then
                return Failure(errno())
            else
                return Success(PipeSize(res))
        }
        GetPipeSize -> {
            val res = fcntl_wrapper_void(fd.int(), cmd.int())
            if res == -1 then
                return Failure(errno())
            else
                return Success(PipeSize(res))
        }
        AddSeals(seals) -> {
            val res = fcntl_wrapper_arg(fd.int(), cmd.int(), seals)
            if res == -1 then
                return Failure(errno())
            else
                return Success(FcntlSuccess)
        }
        GetSeals -> {
            val res = fcntl_wrapper_void(fd.int(), cmd.int())
            if res == -1 then
                return Failure(errno())
            else
                return Success(GetFdSeals(res))
        }
        /*GetRwHint(hint) -> {
            val res = fcntl_wrapper_arg(fd.int(), cmd.int(), hint.int())
            if res == -1 then
                return Failure(errno())
            else
                return Success(GetRwHint(res.rwHint()))
        }
        SetRwHint(hint) -> {
            val res = fcntl_wrapper_arg(fd.int(), cmd.int(), hint.int())
            if res == -1 then
                return Failure(errno())
            else
                return Success(Other)
        }*/


    }


