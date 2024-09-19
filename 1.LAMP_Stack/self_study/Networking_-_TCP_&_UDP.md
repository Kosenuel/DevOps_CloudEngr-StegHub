# Networking - Understanding TCP and UDP

### Introduction

__In the Open Systems Interconnection (OSI) Model, the User Datagram Protocol (UDP) and Transmission Control Protocol (TCP) are primary protocols that play critical roles in facilitating efficient and reliable data transmission across networks. These protocols operate at the __Network Layer__ of the OSI Model. When deploying, or setting up an application for use, it is important to choose the right protocol as this would greatly affect how the application performs.__

### 1. TCP: This protocol is proven to be reliable (in data transfer) and follows ordered delivery of data packets.

- __Definition:__ The TCP protocol is one that prioritises connection and as such it ensures that it establishes a connection between the sender and receiver before data exchange begins.
This protocol has proven to be reliable because it ensures that data packets reaches their destinations safely (without errors) and that they are delivered in an ordered manner (in the same sequence that they were sent).

- __Characteristics of TCP:__

  - __Connection-oriented:__ This character of TCP makes it to Establish a connection before trying to communicate.

  - __Reliability:__ TCP achieves this by usuing acknowledgement and retransmission mechanisms to ensure accurate delivery.

  - __Orderliness:__ TCP ensures that the order/sequence in which files are sent over the network are the same order/sequence they arrive and are assembled in the client's end.

  - __Flow control:__ TCP ensure that the flow of data inside a network are regulated to prevent network congestion.

  - __Header overhead:__ TCP usually have large headers because of the measures it invests/has in place to ensure reliability and flow control.


- __Applications:__ 
Areas where TCP protocols would be recommended for application:
  - Web browsing (HTTP)
  - Email (SMTP, IMAP, POP3)
  - File transfer (FTP)
  - Remote access (SSH, Telnet)

### 2. UDP: This protocol is usually Lighweight and has Low-Overhead

- __Definition:__ 
UDP is a protocol that unlike TCP doesn't ensures that a connection is established before brocasting data. It provides a lightweight and efficient mechanism for transmitting data packets.

- __Characteristics of UDP:__

  - __Connectionless Mode of data transfer:__ UDP transmits data packets independently without ensuring that a connection has been made.

  - __Unreliability:__ UDP does not guaranty the safe delivery or sequence order of data packets that it transmits

  - __Low overhead:__ UDP headers are usually small in comparison to its counter part TCP, this is because UDP does not do any stringent checks on ensuring reliability of communication.

  - __No flow control:__ Unlike TCP, UDP does not regulate data flow, this often results in network congestion when traffic is high.

- __Applications:__ The areas were protocols like UDP are recommended are areas where real-time communication and low-overhead size are a critical factor. These areas include:
  - Streaming media (utilizes UDP-based protocols like RTP)
  - Online gaming (real-time communication is important here)
  - Voice over IP (VoIP) related activities
  - DNS (Domain Name Service) querying


  ### 3. Key Differences: TCP vs UDP

  | __Feature__ | __TCP__   | __UDP__   |
  |-------------|-----------|-----------|
  | __Connection type__  | Connection-oriented |  Connectionless  |
  | __Reliability__  | Reliable with acknowledgement and retransmission mechanism  | Not reliable, does not guarantee data delivery or order  |
  | __Ordering__  | Ensures data retains the order/sequence in which they are transmitted  | Does not guarantee data orderliness  |
  | __Header overhead__  | Has larger header size because it ensures data integrity and flow control | Has small header size because it doesn't bother to ensure transmitted data integrity  |
  | __Flow control__  | Regulates data flow in the network to prevent congestion  | Does not regulate data flow  |
  | __Use cases__  | email communication, web browsing, secure file transfer, etc... | streaming media, gaming, and any thing needing real time communication  |


  __Conclusion__
  
  When designing systems that communicates over the network, it is very important to select the right protocol to use in systems. TCP and UDP specializes in transmitting data over the network, but they prioritize/specialize on different aspect of data transmission. TCP blossoms in reliable file transfers while UDP excels in real-time data transfer. This should be in your mind while working or deciding on what protocol(s) to use in any system that needs to communicate in a network.


