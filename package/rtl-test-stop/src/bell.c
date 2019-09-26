/*
 * Copyright 2019 RnD Center "ELVEES", JSC
 */

#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <stdio.h>

#define die(fmt) {		\
    printf("bell. "fmt);	\
    return 1; 			\
}

#define msg(fmt) {		\
    printf("bell. "fmt); 	\
}

int main() {
    const int magic = MVAL;
    const off_t addr = MADDR;
    int fd;
    size_t psz;
    off_t base;
    off_t off;
    void *mem;

    /* try to print banner */
    msg("is loaded\n");

    msg("do open\n");
    if ((fd = open("/dev/mem", O_RDWR | O_SYNC)) < 0)
        die("open failed\n");

    /* write magic */
    msg("get page\n");
    if ((psz = sysconf(_SC_PAGE_SIZE))< 0)
        die("page failed\n");

    base = addr & ~(psz - 1);
    off = addr & (psz - 1);

    msg("do mmap\n");
    mem = mmap(NULL, off + sizeof(magic), PROT_WRITE, MAP_SHARED, fd, base);
    if (mem == MAP_FAILED)
        die("mmap failed\n");

    msg("do write\n");
    *((int*)(mem + off)) = magic;

    msg("do unmap\n");
    if (munmap(mem, off + sizeof(magic)) < 0)
        die("munmap failed\n");

    msg("do close\n");
    if (close(fd) < 0)
        die("close failed\n");

    msg("prepare to die\n");
    for(;;)
        sleep(1);
}
