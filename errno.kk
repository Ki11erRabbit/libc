
module errno

extern import
    c file "errno-inline.c"

extern get-errno() : int
    c "kk_get_errno"

pub type errno
    E2BIG
    EACCES
    EADDRINUSE
    EADDRNOTAVAIL
    EAFNOSUPPORT
    EAGAIN
    EALREADY
    EBADE
    EBADF
    EBADFD
    EBADMSG
    EBADR
    EBADRQC
    EBADSLT
    EBUSY
    ECANCELED
    ECHILD
    ECHRNG
    ECOMM
    ECONNABORTED
    ECONNREFUSED
    ECONNRESET
    EDEADLK
    EDEADLOCK
    EDESTADDRREQ
    EDOM
    EDQUOT
    EEXIST
    EFAULT
    EFBIG
    EHOSTDOWN
    EHOSTUNREACH
    EHWPOISON
    EIDRM
    EILSEQ
    EINPROGRESS
    EINTR
    EINVAL
    EIO
    EISCONN
    EISDIR
    EISNAM
    EKEYEXPIRED
    EKEYREJECTED
    EKEYREVOKED
    EL2HLT
    EL2NSYNC
    EL3HLT
    EL3RST
    ELIBACC
    ELIBBAD
    ELIBMAX
    ELIBSCN
    ELIBEXEC
    ELNRNG
    ELOOP
    EMEDIUMTYPE
    EMFILE
    EMLINK
    EMSGSIZE
    EMULTIHOP
    ENAMETOOLONG
    ENETDOWN
    ENETRESET
    ENETUNREACH
    ENFILE
    ENOANO
    ENOBUFS
    ENODATA
    ENODEV
    ENOENT
    ENOEXEC
    ENOKEY
    ENOLCK
    ENOLINK
    ENOMEDIUM
    ENOMEM
    ENOMSG
    ENONET
    ENOPKG
    ENOPROTOOPT
    ENOSPC
    ENOSR
    ENOSTR
    ENOSYS
    ENOTBLK
    ENOTCONN
    ENOTDIR
    ENOTEMPTY
    ENOTRECOVERABLE
    ENOTSOCK
    ENOTSUP
    ENOTTY
    ENOTUNIQ
    ENXIO
    EOPNOTSUPP
    EOVERFLOW
    EOWNERDEAD
    EPERM
    EPFNOSUPPORT
    EPIPE
    EPROTO
    EPROTONOSUPPORT
    EPROTOTYPE
    ERANGE
    EREMCHG
    EREMOTE
    EREMOTEIO
    ERESTART
    ERFKILL
    EROFS
    ESHUTDOWN
    ESPIPE
    ESOCKTNOSUPPORT
    ESRCH
    ESTALE
    ESTRPIPE
    ETIME
    ETIMEDOUT
    ETOOMANYREFS
    ETXTBSY
    EUCLEAN
    EUNATCH
    EUSERS
    EWOULDBLOCK
    EXDEV
    EXFULL

pub fun errno() : <exn|_e> errno
    match get-errno()
        1 -> EPERM
        2 -> ENOENT
        3 -> ESRCH
        4 -> EINTR
        5 -> EIO
        6 -> ENXIO
        7 -> E2BIG
        8 -> ENOEXEC
        9 -> EBADF
        10 -> ECHILD
        11 -> EAGAIN
        12 -> ENOMEM
        13 -> EACCES
        14 -> EFAULT
        15 -> ENOTBLK
        16 -> EBUSY
        17 -> EEXIST
        18 -> EXDEV
        19 -> ENODEV
        20 -> ENOTDIR
        21 -> EISDIR
        22 -> EINVAL
        23 -> ENFILE
        24 -> EMFILE
        25 -> ENOTTY
        26 -> ETXTBSY
        27 -> EFBIG
        28 -> ENOSPC
        29 -> ESPIPE
        30 -> EROFS
        31 -> EMLINK
        32 -> EPIPE
        33 -> EDOM
        34 -> ERANGE
        35 -> EDEADLK
        36 -> ENAMETOOLONG
        37 -> ENOLCK
        38 -> ENOSYS
        39 -> ENOTEMPTY
        40 -> ELOOP
        42 -> ENOMSG
        43 -> EIDRM
        44 -> ECHRNG
        45 -> EL2NSYNC
        46 -> EL3HLT
        47 -> EL3RST
        48 -> ELNRNG
        49 -> EUNATCH
        //50 -> ENOCSI
        51 -> EL2HLT
        52 -> EBADE
        53 -> EBADR
        54 -> EXFULL
        55 -> ENOANO
        56 -> EBADRQC
        57 -> EBADSLT
        //59 -> EBFONT
        60 -> ENOSTR
        61 -> ENODATA
        62 -> ETIME
        63 -> ENOSR
        64 -> ENONET
        65 -> ENOPKG
        66 -> EREMOTE
        67 -> ENOLINK
        //68 -> EADV
        //69 -> ESRMNT
        70 -> ECOMM
        71 -> EPROTO
        72 -> EMULTIHOP
        //73 -> EDOTDOT
        74 -> EBADMSG
        75 -> EOVERFLOW
        76 -> ENOTUNIQ
        77 -> EBADFD
        78 -> EREMCHG
        79 -> ELIBACC
        80 -> ELIBBAD
        81 -> ELIBSCN
        82 -> ELIBMAX
        83 -> ELIBEXEC
        84 -> EILSEQ
        85 -> ERESTART
        86 -> ESTRPIPE
        87 -> EUSERS
        88 -> ENOTSOCK
        89 -> EDESTADDRREQ
        90 -> EMSGSIZE
        91 -> EPROTOTYPE
        92 -> ENOPROTOOPT
        93 -> EPROTONOSUPPORT
        94 -> ESOCKTNOSUPPORT
        95 -> EOPNOTSUPP
        96 -> EPFNOSUPPORT
        97 -> EAFNOSUPPORT
        98 -> EADDRINUSE
        99 -> EADDRNOTAVAIL
        100 -> ENETDOWN
        101 -> ENETUNREACH
        102 -> ENETRESET
        103 -> ECONNABORTED
        104 -> ECONNRESET
        105 -> ENOBUFS
        106 -> EISCONN
        107 -> ENOTCONN
        108 -> ESHUTDOWN
        109 -> ETOOMANYREFS
        110 -> ETIMEDOUT
        111 -> ECONNREFUSED
        112 -> EHOSTDOWN
        113 -> EHOSTUNREACH
        114 -> EALREADY
        115 -> EINPROGRESS
        116 -> ESTALE
        117 -> EUCLEAN
        //118 -> ENOTNAM
        //119 -> ENAVAIL
        120 -> EISNAM
        121 -> EREMOTEIO
        122 -> EDQUOT
        123 -> ENOMEDIUM
        124 -> EMEDIUMTYPE
        125 -> ECANCELED
        126 -> ENOKEY
        127 -> EKEYEXPIRED
        128 -> EKEYREVOKED
        129 -> EKEYREJECTED
        130 -> EOWNERDEAD
        131 -> ENOTRECOVERABLE
        132 -> ERFKILL
        133 -> EHWPOISON

pub fun show(err : errno) : string {
    match err
        E2BIG -> "E2BIG: Argument list too long"
        EACCES -> "EACCES: Permission denied"
        EADDRINUSE -> "EADDRINUSE: Address already in use"
        EADDRNOTAVAIL -> "EADDRNOTAVAIL: Cannot assign requested address"
        EAFNOSUPPORT -> "EAFNOSUPPORT: Address family not supported"
        EAGAIN -> "EAGAIN: Resource temporarily unavailable"
        EALREADY -> "EALREADY: Connection already in progress"
        EBADE -> "EBADE: Invalid exchange"
        EBADF -> "EBADF: Bad file descriptor"
        EBADFD -> "EBADFD: File descriptor in bad state"
        EBADMSG -> "EBADMSG: Bad message"
        EBADR -> "EBADR: Invalid request descriptor"
        EBADRQC -> "EBADRQC: Invalid request code"
        EBADSLT -> "EBADSLT: Invalid slot"
        EBUSY -> "EBUSY: Device or resource busy"
        ECANCELED -> "ECANCELED: Operation canceled"
        ECHILD -> "ECHILD: No child processes"
        ECHRNG -> "ECHRNG: Channel number out of range"
        ECOMM -> "ECOMM: Communication error on send"
        ECONNABORTED -> "ECONNABORTED: Connection aborted"
        ECONNREFUSED -> "ECONNREFUSED: Connection refused"
        ECONNRESET -> "ECONNRESET: Connection reset"
        EDEADLK -> "EDEADLK: Resource deadlock would occur"
        EDEADLOCK -> "EDEADLOCK: Resource deadlock would occur"
        EDESTADDRREQ -> "EDESTADDRREQ: Destination address required"
        EDOM -> "EDOM: Math argument out of domain of func"
        EDQUOT -> "EDQUOT: Reserved"
        EEXIST -> "EEXIST: File exists"
        EFAULT -> "EFAULT: Bad address"
        EFBIG -> "EFBIG: File too large"
        EHOSTDOWN -> "EHOSTDOWN: Host is down"
        EHOSTUNREACH -> "EHOSTUNREACH: No route to host"
        EHWPOISON -> "EHWPOISON: Memory page has hardware error"
        EIDRM -> "EIDRM: Identifier removed"
        EILSEQ -> "EILSEQ: Illegal byte sequence"
        EINPROGRESS -> "EINPROGRESS: Operation in progress"
        EINTR -> "EINTR: Interrupted system call"
        EINVAL -> "EINVAL: Invalid argument"
        EIO -> "EIO: I/O error"
        EISCONN -> "EISCONN: Socket is connected"
        EISDIR -> "EISDIR: Is a directory"
        EISNAM -> "EISNAM: Is a named type file"
        EKEYEXPIRED -> "EKEYEXPIRED: Key has expired"
        EKEYREJECTED -> "EKEYREJECTED: Key was rejected by service"
        EKEYREVOKED -> "EKEYREVOKED: Key has been revoked"
        EL2HLT -> "EL2HLT: Level 2 halted"
        EL2NSYNC -> "EL2NSYNC: Level 2 not synchronized"
        EL3HLT -> "EL3HLT: Level 3 halted"
        EL3RST -> "EL3RST: Level 3 reset"
        ELIBACC -> "ELIBACC: Cannot access a needed shared library"
        ELIBBAD -> "ELIBBAD: Accessing a corrupted shared library"
        ELIBMAX -> "ELIBMAX: Attempting to link in too many shared libraries"
        ELIBSCN -> "ELIBSCN: .lib section in a.out corrupted"
        ELIBEXEC -> "ELIBEXEC: Cannot exec a shared library directly"
        ELNRNG -> "ELNRNG: Link number out of range"
        ELOOP -> "ELOOP: Too many symbolic links encountered"
        EMEDIUMTYPE -> "EMEDIUMTYPE: Wrong medium type"
        EMFILE -> "EMFILE: Too many open files"
        EMLINK -> "EMLINK: Too many links"
        EMSGSIZE -> "EMSGSIZE: Message too long"
        EMULTIHOP -> "EMULTIHOP: Reserved"
        ENAMETOOLONG -> "ENAMETOOLONG: File name too long"
        ENETDOWN -> "ENETDOWN: Network is down"
        ENETRESET -> "ENETRESET: Connection aborted by network"
        ENETUNREACH -> "ENETUNREACH: Network unreachable"
        ENFILE -> "ENFILE: Too many open files in system"
        ENOANO -> "ENOANO: No anode"
        ENOBUFS -> "ENOBUFS: No buffer space available"
        ENODATA -> "ENODATA: The named attribute does not exist, or the process has no access to this attribute"
        ENODEV -> "ENODEV: No such device"
        ENOENT -> "ENOENT: No such file or directory"
        ENOEXEC -> "ENOEXEC: Exec format error"
        ENOKEY -> "ENOKEY: Required key not available"
        ENOLCK -> "ENOLCK: No locks available"
        ENOLINK -> "ENOLINK: Link has been severed"
        ENOMEDIUM -> "ENOMEDIUM: No medium found"
        ENOMEM -> "ENOMEM: Not enough space/cannot allocate memory"
        ENOMSG -> "ENOMSG: No message of desired type"
        ENONET -> "ENONET: Machine is not on the network"
        ENOPKG -> "ENOPKG: Package not installed"
        ENOPROTOOPT -> "ENOPROTOOPT: Protocol not available"
        ENOSPC -> "ENOSPC: No space left on device"
        ENOSR -> "ENOSR: No STREAM resources"
        ENOSTR -> "ENOSTR: Not a STREAM"
        ENOSYS -> "ENOSYS: Function not implemented"
        ENOTBLK -> "ENOTBLK: Block device required"
        ENOTCONN -> "ENOTCONN: The socket is not connected"
        ENOTDIR -> "ENOTDIR: Not a directory"
        ENOTEMPTY -> "ENOTEMPTY: Directory not empty"
        ENOTRECOVERABLE -> "ENOTRECOVERABLE: State not recoverable"
        ENOTSOCK -> "ENOTSOCK: Not a socket"
        ENOTSUP -> "ENOTSUP: Not supported"
        ENOTTY -> "ENOTTY: Inappropriate I/O control operation"
        ENOTUNIQ -> "ENOTUNIQ: Name not unique on network"
        ENXIO -> "ENXIO: No such device or address"
        EOPNOTSUPP -> "EOPNOTSUPP: Operation not supported on socket"
        EOVERFLOW -> "EOVERFLOW: Value too large to be stored in data type"
        EOWNERDEAD -> "EOWNERDEAD: Owner died"
        EPERM -> "EPERM: Operation not permitted"
        EPFNOSUPPORT -> "EPFNOSUPPORT: Protocol family not supported"
        EPIPE -> "EPIPE: Broken pipe"
        EPROTO -> "EPROTO: Protocol error"
        EPROTONOSUPPORT -> "EPROTONOSUPPORT: Protocol not supported"
        EPROTOTYPE -> "EPROTOTYPE: Protocol wrong type for socket"
        ERANGE -> "ERANGE: Result too large"
        EREMCHG -> "EREMCHG: Remote address changed"
        EREMOTE -> "EREMOTE: Object is remote"
        EREMOTEIO -> "EREMOTEIO: Remote I/O error"
        ERESTART -> "ERESTART: Interrupted system call should be restarted"
        ERFKILL -> "ERFKILL: Operation not possible due to RF-kill"
        EROFS -> "EROFS: Read-only file system"
        ESHUTDOWN -> "ESHUTDOWN: Cannot send after transport endpoint shutdown"
        ESPIPE -> "ESPIPE: Invalid seek"
        ESOCKTNOSUPPORT -> "ESOCKTNOSUPPORT: Socket type not supported"
        ESRCH -> "ESRCH: No such process"
        ESTALE -> "ESTALE: Stale file handle"
        ESTRPIPE -> "ESTRPIPE: Streams pipe error"
        ETIME -> "ETIME: Timer expired"
        ETIMEDOUT -> "ETIMEDOUT: Connection timed out"
        ETOOMANYREFS -> "ETOOMANYREFS: Too many references: cannot splice"
        ETXTBSY -> "ETXTBSY: Text file busy"
        EUCLEAN -> "EUCLEAN: Structure needs cleaning"
        EUNATCH -> "EUNATCH: Protocol driver not attached"
        EUSERS -> "EUSERS: Too many users"
        EWOULDBLOCK -> "EWOULDBLOCK: Operation would block"
        EXDEV -> "EXDEV: Cross-device link"
        EXFULL -> "EXFULL: Exchange full"

}

pub type libcResult<a>
    Success(a : a)
    Failure(errno : errno)


pub fun unwrap(res : libcResult<a>) : <exn> a 
    match res
        Success(a) -> a
        Failure(e) -> throw(e.show())