module socket


pub import libc-types

extern import
    c file "socket-inline.c"

pub extern bitwise_or(a : int, b : int) : int
    c "kk_bitwise_or"

pub type socketDomain
    Unix
    Local
    INet
    AX25
    IPX
    AppleTalk
    X25
    INet6
    DECet
    Key
    NetLink
    Packet
    ReliableDatagramSockets
    PPPOX
    LogicalLinkControl
    InfiniBand
    MultiprotocolLabelSwitching
    ControllerAreaNetwork
    TIPC
    Bluetooth
    ALG
    VSock
    KernelConnectionMultiplexer
    ExpressDataPath

pub fun int(domain : socketDomain) : int
    match domain
        Unix -> 1
        Local -> 1
        INet -> 2
        AX25 -> 3
        IPX -> 4
        AppleTalk -> 5
        X25 -> 9
        INet6 -> 10
        DECet -> 12
        Key -> 15
        NetLink -> 16
        Packet -> 17
        ReliableDatagramSockets -> 21
        PPPOX -> 24
        LogicalLinkControl -> 26
        InfiniBand -> 27
        MultiprotocolLabelSwitching -> 28
        ControllerAreaNetwork -> 29
        TIPC -> 30
        Bluetooth -> 31
        ALG -> 38
        VSock -> 40
        KernelConnectionMultiplexer -> 41
        ExpressDataPath -> 44




pub type socketType
    Stream
    Datagram
    SeqPacket
    Raw
    ReliableDatagram

pub fun int(sock_type : socketType) : int
    match sock_type
        Stream -> 1
        Datagram -> 2
        SeqPacket -> 5
        Raw -> 3
        ReliableDatagram -> 4

pub val sock_nonblocking = 2048
pub val sock_cloexec = 524288

extern socket_wrapper(domain : int, sock_type : int, protocol : int) : int
    c "kk_socket_wrapper"


pub fun socket(domain : socketDomain, sock_type : socketType, sock_options : int, protocol : int) : <exn|_e> libcResult<fileDescriptor>
    val res = socket_wrapper(domain.int(), bitwise_or(sock_type.int(), sock_options), protocol)
    if res == -1 then
        Failure(errno())
    else
        Success(res.fd())

//socket level
pub val sol_Socket = 1

//setsockopt optnames
pub val so_Debug = 1
pub val so_ReuseAddr = 2
pub val so_Type = 3
pub val so_Error = 4
pub val so_DontRoute = 5
pub val so_Broadcast = 6
pub val so_SNDBUF = 7
pub val so_RCVBUF = 8
pub val so_SNDBUFFORCE = 32
pub val so_RCVBUFFORCE = 33
pub val so_KeepAlive = 9
pub val so_OOBInline = 10
pub val so_NoCheck = 11
pub val so_Priority = 12
pub val so_Linger = 13
pub val so_BSDCompat = 14
pub val so_ReusePort = 15

pub val so_SecurityAuthentication = 22
pub val so_Security_Encryption_Transport = 23
pub val so_Security_Encryption_Network = 24

pub val so_BindTodevice = 25
pub val so_Attach_Filter = 26
pub val so_Detach_Filter = 27
pub val so_Get_Filter = so_Attach_Filter
pub val so_PeerName = 28
pub val so_AcceptConn = 30
pub val so_PeerSec = 31
pub val so_PassSec = 34
//todo: finish adding from /usr/include/asm-generic/socket.h




extern setsockopt_wrapper(socket_fd : int, level : int, optname : int, optval : vector<int>) : int
    c "kk_setsockopt_wrapper"


pub fun setsockopt(socket : fileDescriptor, level : int, optname : int, optval : list<int>) : <exn|_e> libcResult<int>
    val res = setsockopt_wrapper(socket.int(), level, optname, optval.vector())
    if res == -1 then
        Failure(errno())
    else
        Success(res)

pub type socketAddress
    IPV4 {
        family : int
        port : int
        addr : string
    }
    IPV6 {
        family : int
        port : int
        flowinfo : int
        addr : string
        scope_id : int
    }

pub fun int(addr_type : socketAddress) : int
    match addr_type
        IPV4(_,_,_) -> 2
        IPV6(_,_,_,_,_) -> 10

/*extern addr_wrapper(addr_type : int, addr : string) : int
    c "kk_addr_wrapper"

pub fun address(addr_type : socketAddress, addr : string) : <exn|_e> libcResult<int>
    val res = addr_wrapper(addr_type.int(), addr)
    if res == -1 then
        Failure(errno())
    else
        Success(res)*/

extern bind_wrapper_ipv4(socket_fd : int, addr_family : int, addr_port : int, addr_addr : string) : int
    c "kk_bind_wrapper_ipv4"
extern bind_wrapper_ipv6(socket_fd : int, addr_family : int, addr_port : int, addr_flowinfo : int, addr_addr : string, addr_scope_id : int) : int
    c "kk_bind_wrapper_ipv6"

pub fun bind(socket : fileDescriptor, addr : socketAddress) : <exn|_e> libcResult<int>
    match addr
        IPV4 (family, port, addr) -> {
            val res = bind_wrapper_ipv4(socket.int(), family, port, addr)
            if res == -1 then
                Failure(errno())
            else
                Success(res)
        }
        IPV6 (family, port, flowinfo, addr, scope_id) -> {
            val res = bind_wrapper_ipv6(socket.int(), family, port, flowinfo, addr, scope_id)
            if res == -1 then
                Failure(errno())
            else
                Success(res)
        }


extern accept_wrapper_ipv4(socket_fd : int, addr_family : int, addr_port : int, addr_addr : string) : int
    c "kk_accept_wrapper_ipv4"

extern accept_wrapper_ipv6(socket_fd : int, addr_family : int, addr_port : int, addr_flowinfo : int, addr_addr : string, addr_scope_id : int) : int
    c "kk_accept_wrapper_ipv6"

pub fun accept(socket : fileDescriptor, addr : socketAddress) : <exn|_e> libcResult<fileDescriptor>
    match addr
        IPV4 (family, port, addr) -> {
            val res = accept_wrapper_ipv4(socket.int(), family, port, addr)
            if res == -1 then
                Failure(errno())
            else
                Success(res.fd())
        }
        IPV6 (family, port, flowinfo, addr, scope_id) -> {
            val res = accept_wrapper_ipv6(socket.int(), family, port, flowinfo, addr, scope_id)
            if res == -1 then
                Failure(errno())
            else
                Success(res.fd())
        }


extern listen_wrapper(socket_fd : int, backlog : int) : int
    c "kk_listen_wrapper"


pub fun listen(socket : fileDescriptor, backlog : int) : <exn|_e> libcResult<int>
    val res = listen_wrapper(socket.int(), backlog)
    if res == -1 then
        Failure(errno())
    else
        Success(res)