# Mazing

This is a project that explores the Elixir programming language and related
libraries and tools through mazes.


* Graph algorithms
  * Depth-first search
* Maze algorithms
  * Binary tree
  * Sidewinder
* OTP
* Agents
  * Movement inside maze
  * Trails

The maze is populated with autonomous agents, implemented as GenServers.

There is a mazing_ui project that implements a web ui using Phoenix Framework and
channels.

This project is inspired by the book _Mazes for programmers_ by Jamis Buck.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `mazing` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:mazing, "~> 0.1.0"}]
    end
    ```

  2. Ensure `mazing` is started before your application:

    ```elixir
    def application do
      [applications: [:mazing]]
    end
    ```
