# Fish FZF

Yet another [fzf] plugin for [Fish].

Unlike the [others](#alternatives), this plugin tries to pack as much as possible into a single "do what I mean" shortcut. Edit a file? `cd` to a directory? Just insert it into the command line? Many things like this can be determined from context.

## Installation

Run `make install`, or use [Fisher]:

```fish
fisher install mk12/fish-fzf
```

## Keybindings

The main keybinding is <kbd>Ctrl</kbd><kbd>O</kbd>:

- <kbd>Ctrl</kbd><kbd>O</kbd> calls `__fzf_insert file` to search files.

For convenience, you can also jump directly into a different mode with these keybindings:

- <kbd>Ctrl</kbd><kbd>Q</kbd> calls `__fzf_insert directory` to search directories.
- <kbd>Alt</kbd><kbd>Z</kbd> calls `__fzf_insert z` to search [z] directories.

This plugin also offers a fzf version of `history-search-backward`:

- <kbd>Ctrl</kbd><kbd>R</kbd> calls `__fzf_history` to search command history.

## Usage

Press <kbd>Ctrl</kbd><kbd>O</kbd> to launch fzf.

If you've already typed a path, or part of one, it will start there. Otherwise, it will start in the working directoy. Within fzf, you get these keybindings:

- <kbd>Enter</kbd> selects a result.
- <kbd>Tab</kbd> selects multiple results.
- <kbd>Ctrl</kbd><kbd>O</kbd> switches to searching files.
- <kbd>Ctrl</kbd><kbd>Q</kbd> switches to searching directories.
- <kbd>Alt</kbd><kbd>Z</kbd> switches to searching [z] directories.
- <kbd>Alt</kbd><kbd>↑</kbd> goes up to the parent directory.
- <kbd>Alt</kbd><kbd>↓</kbd> goes into the current item's directory.
- <kbd>Alt</kbd><kbd>H</kbd> goes to your home directory.
- <kbd>Alt</kbd><kbd>.</kbd> toggles showing hidden paths.
- <kbd>Alt</kbd><kbd>I</kbd> toggles showing ignored paths.

When you make a selection, it will normally be inserted in the command line. But if the command line was empty before and you only selected one item:

- If it's a directory, `cd` to it.
- If it's a file, open it with `$EDITOR`.

To prevent this, use <kbd>Alt</kbd><kbd>Enter</kbd>.

## Alternatives

- [jethrokuan/fzf](https://github.com/jethrokuan/fzf)
- [PatrickF1/fzf.fish](https://github.com/PatrickF1/fzf.fish)

## License

© 2022 Mitchell Kember

Fish FZF is available under the MIT License; see [LICENSE](LICENSE.md) for details.

[fzf]: https://github.com/junegunn/fzf
[Fish]: https://fishshell.com
[Fisher]: https://github.com/jorgebucaran/fisher
[z]: https://github.com/jethrokuan/z
