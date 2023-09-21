# OS3ILV WS23/24 Assignment
This repository hosts the description of the assignment for OS3ILV WS23/24


## Goal of the Assignment

Practice **Process Management** by creating a simple multi-process program in C in which each process performs a specific task.

To solve the assignment, you must implement process creation, scheduling, synchronization, and termination mechanisms.

## High-level Description of the Assignment

Your task is to implement a Multi-player Rock Paper Scissors platform.

The platform consists of:
- A central "server", i.e., a daemon process or service, that receives and executes commands for creating new games, joining new games, making moves, creating reports, maintaining the leaderboard, etc.
- A client component, i.e., a process, that communicates to the server and allows users to play (multiple) games at the same time and check the leaderboard.

### The Gameplay

There are a few different ways to approach the game. Our approach works like this:
- Start a game by specifying how many players will play (N) and the target points to accumulate to end the game (X).
- After N players join the game on the RPS platform, the game can start.
- At each round, players submit their hand gesture (rock, paper, or scissors)
- When all the players submit their hand gestures, the system computes the points: Players get points when their hand gesture wins over other players.
- The game proceeds in rounds until a player scores at least X points. The player(s) with the highest number of points win(s).
- After the game ends, a game report is generated, and the leaderboard is updated (overall score, played matches, and matches won).

## Potential (Abstract) Test Cases

Potential system test cases look like this:
- Start the platform (pay attention to shared states!)
- Pretend to create some clients
- Create a game
- Play the clients (send some commands)
- Check the conformance of the system's response to all the clients
