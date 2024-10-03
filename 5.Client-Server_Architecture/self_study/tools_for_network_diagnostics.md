# Study: Network Diagnostic tools

Whenever a website feels slower to load or sometimes you just cannot connect to that system over the other end of the internet, what you need to troubleshoot and restore connectivity is some good network troubleshooting tools e.g: Ping and Trace-route.

## Ping: The Internet's Echo

### What is Ping

Ping is when a computer sends a message to another computer or network device over the local network or the internet, and gets or waits to get a reply from that device. This is used to do a range of cool thing like: measure the connection latency between devices or test device reachability.

### How to Use Ping

This is how you use this tool:

1. Open up your computer's command line interface (CLI).
2. Type this command:

```bash
ping google.com
```

(You can replace "google.com" with any website you want to check!)

### What Ping Tells You

When you use Ping, it gives you a bunch of info. Let's break it down:

1. It tells you who it's talking to and how big the message is.
2. Then it shows you the replies, like this:
   ```
   Reply from 172.217.16.142: bytes=32 time=15ms TTL=57
   ```
   This means:
   - The computer at 172.217.16.142 (Google, in this case) answered
   - The message was 32 bytes big (that's tiny!)
   - It took 15 milliseconds to get there and back (super fast!)
   - TTL is like a countdown for how many computers the message can jump through

3. At the end, it gives you a summary which tells you how many messages made it through and how fast they were on average.

### What Does It All Mean?

- If Ping comes back fast and doesn't lose any messages, your internet connection to that website is working great!
- If it's slow or loses messages, there might be some internet traffic jams or other problems.
- If you get no reply at all, it is either the website is down, or there's a big roadblock somewhere on the internet!

## Traceroute: The Internet Road Trip

### What is Traceroute?

If Ping is like shouting in a cave, Traceroute is like a road trip across the internet! It shows you every stop (which is also called "hops") your message makes on its way to the website and back.

### How to Use Traceroute

This is how we normally go about using trace route:

On Windows:
```bash
tracert google.com
```

On Mac or Linux:
```bash
traceroute google.com
```

### What Traceroute Shows You

Traceroute gives you a step-by-step guide of your message's journey. It looks something like this:

```
 1    <1ms    <1ms    <1ms  192.168.1.1
 2     *        *        *     Request timed out.
 3    20ms    19ms    19ms  10.20.30.40
```

What's this mean?
1. The first number is the hop count - how many stops the message has made.
2. The next three numbers are how long it took to get a reply (in milliseconds).
3. The last part is the address of the computer or network device at that stop.

Sometimes you might see stars (*) instead of times. This is when the packet makes a stop where no one (no network device or computer) answered the door (acknowledged)!

### What Can Traceroute Tell Us?

- If everything's working fine, you'll see a nice list of stops, each one taking a bit longer as your message travels further.
- If you see a big jump in time between two stops, there might be a traffic jam there!
- If you see a bunch of stars (*) and then the next stop is much further away, your message might have taken a detour - another route.

## Closing Up

Ping and Traceroute are like your very own internet troubleshooting/diagnostic kit. With Ping, you can check if a website is up and how fast it responds. With Traceroute, you can see the whole journey your messages take across the internet!
