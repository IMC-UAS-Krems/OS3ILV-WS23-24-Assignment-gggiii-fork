# OS3ILV WS23/24 Assignment
This repository hosts the description of the assignment for OS3ILV WS23/24


## Goal of the Assignment

Practice **Process Management** by creating a simple multi-process program in C in which each process performs a specific task.

To solve the assignment, you must implement process creation, scheduling, synchronization, and termination mechanisms.

## High-level Description of the Assignment

Your task is to implement a Multi-player Rock Paper Scissors platform.

The platform consists of:

- A central "server", i.e., a daemon process or service, that runs in background. It receives commands for creating new games, joining new games, making moves, creating reports, maintaining the leaderboard, etc. and executes them.
- A client component, i.e., a process, that communicates to the server and allows users to play (multiple) games at the same time and check the leaderboard.

    > Note: It should be possible to start multiple, concurrent instances of the client components on the same machine!

### The Gameplay

There are a few different ways to approach the rock paper scissor with multiple players. Informally, our approach works like this:

- Start a game by specifying how many players will play (N) and the target points to accumulate to end the game (X).
- After N players join the game on the RPS platform, the game can start.
- At each round, players submit their hand gesture (rock, paper, or scissors)
- When all the players submit their hand gestures, the system computes the points: Players get points when their hand gesture wins over other players.
- The game proceeds in rounds until a player scores at least X points. The player(s) with the highest number of points win(s).
- After the game ends, a game report is generated, and the leaderboard is updated (overall score, played matches, and matches won).

## Potential (Abstract) Test Cases

You should write unit and system tests. A potential system test cases look like this:

- Start the central "server" 
- Pretend to or actually create some clients
- One client creates a game
- Many clients join the game
- Client concurrently play the game by sending some commands

While the test is running, the output of all the clients and the central "server" should be collected and stored to check the conformance of their behaviors

# Dependencies and Requirements

The assignment requires you to develop C code. The best way to approach this is to use a Linux or a Mac OS distribution, that come already equipped with `gcc` (to compile C) and `make` (to automate the building of the project).

In case you work in Windows, you can chose one of the following options:

1. VM. Install a system level virtualization system (VirtualBox, Parallels, VMWare, etc.), and create a Linux VM. Connect to the VM and work on it.
2. Container. Install docker and create a linux docker image. You can mount your disk into the running docker instance and write the code using your IDE as usual. But you must execute `make` from within the running docker instance (for example, using `docker exec`).
3. WSL. Install Windows Subsystem for Linux (WSL) and write the code using your IDE as usual. But you must execute `make` from within the running WSL. According to [this article](https://code.visualstudio.com/docs/remote/wsl) you can configure VisualStudio to run commands directly via WSL.

## External Libraries
The project should not rely on any external library besides those used for testing and code coverage.

For testing, you'll use the [Unity framework](http://www.throwtheswitch.org/unity) and for coverage you'll use (standard) `gcov`. Both those dependencies should be already handled by the given assignment (typing `make reps` should install them).

# Additional reading

If you are not familiar with developing and testing C programs you can google for any basic tutorial about it and start practicing **NOW**!

> Note: You can suggest any tutorial you have found useful to the lecturer so it can be included here. Please, open a pull request for doing so

## C Programming
Here some refs about C programming:

- [https://www.w3schools.com/c/](https://www.w3schools.com/c/)

## Make
Here some refs about `make`:

- [https://makefiletutorial.com/](https://makefiletutorial.com/)

## Unit testing and coverage
Here some refs about testing and computing coverage of C programs:

- [https://moderncprogramming.com/what-is-the-best-unit-testing-framework-in-c-for-you/](https://moderncprogramming.com/what-is-the-best-unit-testing-framework-in-c-for-you/)
- [https://moderncprogramming.com/what-is-the-best-unit-test-method-naming-convention-in-c/](https://moderncprogramming.com/what-is-the-best-unit-test-method-naming-convention-in-c/)
- [https://github.com/shenxianpeng/gcov-example](https://github.com/shenxianpeng/gcov-example)
- [https://medium.com/@kasra_mp/introduction-to-c-unit-testing-with-the-unity-framework-15903823ce8a](https://medium.com/@kasra_mp/introduction-to-c-unit-testing-with-the-unity-framework-15903823ce8a)