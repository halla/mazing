# Mazing

This is a project that explores the Elixir programming language and related
libraries and tools through mazes.


* Graph traversal algorithms
  * Depth-first search
  * Breadth-first search
* Maze algorithms
  * Binary tree
  * Sidewinder
* OTP
  * Maze state is a persistent world populated by autonomous agents
* Agents
  * Movement inside maze
  * Trails
* Umbrella project
  * Web ui separated from mazing app itself
  * Probably overkill...

The maze is populated with autonomous agents, implemented as GenServers.

This project is inspired by the book _Mazes for programmers_ by Jamis Buck.

## Installation

* Seems to be a bit broken now...
* 
* git clone
* assuming you have elixir and yarn installed...
* mix deps.get  (and the normal elixir stuff... )
* mazing/apps/mazing_ui/assets$ yarn install 
* mix phx.server
* see the running maze in your browser(s)
