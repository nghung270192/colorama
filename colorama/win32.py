
# from winbase.h
STDOUT = -11
STDERR = -12

try:
    from ctypes import windll
except ImportError:
    windll = None
    SetConsoleTextAttribute = lambda *_: None
else:
    from ctypes import (
        byref, Structure, c_char, c_short, c_uint32, c_ushort
    )

    handles = {
        STDOUT: windll.kernel32.GetStdHandle(STDOUT),
        STDERR: windll.kernel32.GetStdHandle(STDERR),
    }

    SHORT = c_short
    WORD = c_ushort
    DWORD = c_uint32
    TCHAR = c_char

    class COORD(Structure):
        """struct in wincon.h"""
        _fields_ = [
            ('X', SHORT),
            ('Y', SHORT),
        ]

    class  SMALL_RECT(Structure):
        """struct in wincon.h."""
        _fields_ = [
            ("Left", SHORT),
            ("Top", SHORT),
            ("Right", SHORT),
            ("Bottom", SHORT),
        ]

    class CONSOLE_SCREEN_BUFFER_INFO(Structure):
        """struct in wincon.h."""
        _fields_ = [
            ("dwSize", COORD),
            ("dwCursorPosition", COORD),
            ("wAttributes", WORD),
            ("srWindow", SMALL_RECT),
            ("dwMaximumWindowSize", COORD),
        ]

    def GetConsoleScreenBufferInfo(stream_id):
        handle = handles[stream_id]
        csbi = CONSOLE_SCREEN_BUFFER_INFO()
        success = windll.kernel32.GetConsoleScreenBufferInfo(
            handle, byref(csbi))
        assert success
        return csbi

    def SetConsoleTextAttribute(stream_id, attrs):
        handle = handles[stream_id]
        success = windll.kernel32.SetConsoleTextAttribute(handle, attrs)
        assert success

    def SetConsoleCursorPosition(stream_id, position):
        handle = handles[stream_id]
        position = COORD(*position)
        success = windll.kernel32.SetConsoleCursorPosition(handle, position)
        assert success

    def FillConsoleOutputCharacter(stream_id, char, length, start):
        handle = handles[stream_id]
        char = TCHAR(char)
        length = DWORD(length)
        start = COORD(*start)
        num_written = DWORD(0)
        # AttributeError: function 'FillConsoleOutputCharacter' not found
        # could it just be that my types are wrong?
        success = windll.kernel32.FillConsoleOutputCharacter(
            handle, char, length, start, byref(num_written))
        assert success
        return num_written.value


if __name__=='__main__':
    # SetConsoleTextAttribute(STDOUT, 7)
    #FillConsoleOutputCharacter(STDOUT, '.', 81, (1, 2))
    # SetConsoleCursorPosition(STDOUT, (1, 2))
    print GetConsoleScreenBufferInfo(STDOUT)
