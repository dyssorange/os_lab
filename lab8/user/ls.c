#include <ulib.h>
#include <stdio.h>
#include <dir.h>
#include <error.h>

#define printf(...) fprintf(1, __VA_ARGS__)

static int
list_dir(const char *path)
{
    DIR *dirp = opendir(path);
    if (dirp == NULL)
    {
        return -E_NOENT;
    }
    struct dirent *de;
    while ((de = readdir(dirp)) != NULL)
    {
        if (de->name[0] != '\0')
        {
            printf("%s\n", de->name);
        }
    }
    closedir(dirp);
    return 0;
}

int
main(int argc, char **argv)
{
    const char *path = (argc >= 2) ? argv[1] : ".";
    int ret = list_dir(path);
    if (ret != 0 && argc < 2)
    {
        ret = list_dir("/");
    }
    if (ret != 0)
    {
        printf("ls: %e\n", ret);
        return ret;
    }
    return 0;
}
