module socket

extern import
    c file "socket-inline.c"

import libc-types

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

pub val Sock_Nonblocking = 2048
pub val Sock_Cloexec = 524288

extern socket_wrapper(domain : int, sock_type : int, protocol : int) : int
    c "kk_socket_wrapper"


pub fun socket(domain : socketDomain, sock_type : socketType, sock_options : int, protocol : int) : <exn|_e> libcResult<fileDescriptor>
    val res = socket_wrapper(domain.int(), sock_type.int() | sock_options, protocol)
    if res == -1 then
        Failure(errno())
    else
        Success(res.fd())


pub type socketAddress
    IPV4 {
        family : int
        port : int
        addr : int // should be in network byte order
    }
    IPV6 {
        family : int
        port : int
        flowinfo : int
        addr : string // should be 16 bytes long and a list of int
        scope_id : int
    }
    

extern accept_wrapper_ipv4(socket_fd : int, addr_family : int, addr_port : int, addr_addr : int) : int
    c "kk_accept_wrapper_ipv4"

extern accept_wrapper_ipv6(socket_fd : int, addr_family : int, addr_port : int, addr_flowinfo : int, addr_addr : string, addr_scope_id : int) : int
    c "kk_accept_wrapper_ipv6"

pub fun accept(socket : fileDescriptor, addr : socketAddress) : <exn|_e> libcResult<fileDescriptor>
    match addr
        IPV4 {family, port, addr} -> {
            val res = accept_wrapper_ipv4(socket.int(), family, port, addr)
            if res == -1 then
                Failure(errno())
            else
                Success(res.fd())
        }
        IPV6 {family, port, flowinfo, addr, scope_id} -> {
            val res = accept_wrapper_ipv6(socket.int(), family, port, flowinfo, addr, scope_id)
            if res == -1 then
                Failure(errno())
            else
                Success(res.fd())
        }