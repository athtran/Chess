# Chess

Classic two player turned based board game, readapted as a console game built in pure Ruby.

![wow these guys are bad players](/demo.gif)

## How to install

Clone the repo or download the zip. Open your console or terminal, and navigate to the newly created folder called Chess. Execute the file by running the following command in the terminal.

```ruby
ruby game.rb
```

## Key Features

**Cursor Controls** Ease of access due to cursor controls instead of coordinate input.

**Move Highlighting** Highlights every single possible move per piece. King turns red in the event of a check. Pieces are unable to move into spaces that result in the player losing the game.

**Saved Game State** The game uses YAML to save the game at any point in time. Players can restart a saved game at start up of the program, or start a new game. An example of a saved game state is included in the repo.
