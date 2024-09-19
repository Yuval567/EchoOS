#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
#define WHITE_ON_BLACK 0x0f

void set_char_at_video_memory(char character, int offset) 
{
    unsigned char *vidmem = (unsigned char *) VIDEO_ADDRESS;
    vidmem[offset] = character;
    vidmem[offset + 1] = WHITE_ON_BLACK;
}

void clear_screen()
{
    for (int i = 0; i < MAX_COLS * MAX_ROWS; ++i) 
    {
        set_char_at_video_memory(' ', i * 2);
    }
}

void print_string(char* string)
{
    int i = 0;
    while (string[i] != 0)
    {
        set_char_at_video_memory(string[i], i * 2);
        i++;
    }
}

void main() 
{
    clear_screen();
    char message[] = "Hello Kernel!";
    print_string(message);
}