# `mt19937`: MT19937 implementation in pure Haskell
What it says on the box.

Only the PRNG itself is implemented. If you'd like to use this as a PRNG in any
capacity, you'll need to wrap it into some monad or some such.

Doesn't seem too useful? You'd be surprised. This was originally written while
decoding a file header which was bafflingly encoded using a set-seed MT19937.

## License
Provided under the MIT license. See `LICENSE` for license text.
