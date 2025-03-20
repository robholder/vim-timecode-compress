# Untested starting point for conversion of vim-function to Python (for future use in SRTEdit gui app).
import re

def compress_timecodes(srt_file, current_line):
    """
    Compresses timecodes in an SRT file from the current line backward to ensure
    2-millisecond gaps between timecodes.
    """
    # Define the timecode regex pattern
    timecode_pattern = r'(\d{2}):(\d{2}):(\d{2}),(\d{3}) --> (\d{2}):(\d{2}):(\d{2}),(\d{3})'
    
    # Read the SRT file into a list of lines
    with open(srt_file, 'r', encoding='utf-8') as file:
        lines = file.readlines()
    
    # Check the current line for a valid timecode
    match = re.match(timecode_pattern, lines[current_line - 1])
    if not match:
        print("No valid timecode found on the current line.")
        return
    
    # Extract the current line's start time for reference
    start_hour, start_minute, start_second = match.group(1, 2, 3)
    
    # Initialize the "searchcount" counter
    searchcount = 1
    
    # Process lines backward starting from the previous line
    for i in range(current_line - 2, -1, -1):
        match = re.match(timecode_pattern, lines[i])
        if match:
            # Calculate the millisecond values for the gap
            start_count = f'{(searchcount * 2) - 1:03d}'
            end_count = f'{(searchcount * 2):03d}'
            
            # Update the line with compressed timecodes
            updated_line = f"{start_hour}:{start_minute}:{start_second},{start_count} --> " \
                           f"{start_hour}:{start_minute}:{start_second},{end_count}\n"
            lines[i] = updated_line
            
            # Increment the search count
            searchcount += 1
    
    # Write the updated lines back to the SRT file
    with open(srt_file, 'w', encoding='utf-8') as file:
        file.writelines(lines)
    
    print("Processed timecodes and updated previous lines.")

# Example usage:
# Place the cursor on the first line *not* to change in the SRT file, and call:
compress_timecodes('example.srt', 10)  # Replace 'example.srt' with your file and 10 with the line number.
