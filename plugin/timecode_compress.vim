" timecode_compress: A plugin for searching backward for timecodes and compressing
" them to a duration of milliseconds. (A useful pre-process if shifting timecodes backwards).
"
" TimecodeCompress: A function to process timecodes near the start of an SRT file from
" the current line backwards to compress into gaps of 2 milliseconds duration.
"
" Place the cursor in the first timecode line NOT to change, and <Leader>tt
"
function! TimecodeCompress()
    " Get the current line content
    let current_line_content = getline('.')

    " Define the SRT timecode pattern (matches the format HH:MM:SS,mmm)
    let timecode_pattern = '\v(\d{2}):(\d{2}):(\d{2}),(\d{3}) --\> (\d{2}):(\d{2}):(\d{2}),(\d{3})'

    " Check if the current line contains a timecode
    if current_line_content =~ timecode_pattern
        
        " Use matchlist() to extract timecode sections
        let matches = matchlist(current_line_content, timecode_pattern)

        " The extracted timecode sections
        let start_hour = matches[1]
        let start_minute = matches[2]
        let start_second = matches[3]
        "let start_millisecond = matches[4]
        "let end_hour = matches[5]
        "let end_minute = matches[6]
        "let end_second = matches[7]
        "let end_millisecond = matches[8]

        " Move the cursor to the previous line before starting the search for
        " previous timecode lines:
        if line('.') > 1
            call cursor(line('.') - 1, 1)  " Move one line up, to the first column
        endif

        " Search backwards for the next (previous) timecode pattern to edit:
        let prev_line_number = search(timecode_pattern, 'bW')

        " Count how many timecodes there are before the selected one
        " Initialize variables
        let searchcount = 1
        let current_pos = getpos('.')  " Save the current cursor position

        " Start searching backward from the current position and store the
        " count in 'searchcount'
        while search(timecode_pattern, 'bW') > 0
            let searchcount += 1
        endwhile

        " Restore the cursor position
        call setpos('.', current_pos)

        while prev_line_number > 0

            let start_count = printf('%03d', (searchcount * 2) - 1)
            let end_count = printf('%03d', (searchcount * 2))

            let updated_prev_line = start_hour . ':' . start_minute . ':' . start_second . ',' . start_count .
                         \' --> ' . start_hour . ':' . start_minute . ':' . start_second . ',' . end_count
            " Replace the timecode with the millisecond version
            call setline(prev_line_number, updated_prev_line)

            " Find the next (previous) timecode line:
            let prev_line_number = search(timecode_pattern, 'bW')
            " Adjust the remaining timecode count:
            let searchcount = searchcount - 1

        endwhile

        echo "Processed timecodes and updated previous lines."
    else
        echo "No valid timecode found on the current line."
    endif
endfunction

" Map the function to a key, for example, <Leader>t
nnoremap <Leader>tt :call TimecodeCompress()<CR>
"
" Define a user command to call the function
command! TimecodeCompress call TimecodeCompress()

