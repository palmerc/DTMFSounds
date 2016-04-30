## DTMF Tone Generator

A Swift based DTMF tone generator. I wanted to play with generating Linear PCM for the purposes of using an FFT, so I came up with this as a starting point.

Running the playground will take a string and turn it into a series of tones that play on the internal speaker. You can change the sample rate and the mark and space length to get different outputs. For some really cool sounds try dropping the sample rate below the Nyquist limit.
