# vim-timecode-compress
A Vim plugin to retime and compress all SRT timecodes (preceding the current timecode at the cursor location) and increment them backwards in milliseconds.

The plugin searches backward for preceding timecodes and compresses them to a duration of milliseconds. (A useful pre-process if shifting timecodes backwards using other SRT editing tools).

## Installation
### Using vim-plug
Add the following to your `.vimrc` or `init.vim`:

Plug 'robholder/vim-timecode-compress'


Run `:PlugInstall` to install.

## Usage
- Use place cursor on first timecode line to remain unchanged, then `:TimecodeCompress` to compress all preceding timecode lines to milliseconds duration.
- Or place cursor on first timecode line to remain unchanged, then press `<Leader>t`.
