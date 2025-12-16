#include <stdio.h>
#include <string.h>
#include <ulib.h>

static char buf[4096 * 2]; // two pages

int main(void)
{
    // parent writes initial values
    buf[0] = 0x1;
    buf[4096] = 0x2;

    int pid = fork();
    if (pid < 0)
    {
        panic("fork failed\n");
    }
    if (pid == 0)
    {
        // child: see parent's data, then modify (should trigger COW)
        assert(buf[0] == 0x1 && buf[4096] == 0x2);
        buf[0] = 0x3;
        buf[4096] = 0x4;
        exit(0);
    }

    // parent: wait child, then verify its own view unchanged
    assert(wait() == 0);
    assert(buf[0] == 0x1 && buf[4096] == 0x2);

    // parent can still write afterwards
    buf[0] = 0x5;
    buf[4096] = 0x6;

    cprintf("cowtest passed.\n");
    return 0;
}



