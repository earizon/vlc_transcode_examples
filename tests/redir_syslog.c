// Ref: http://mischasan.wordpress.com/2011/05/25/redirecting-stderr-to-syslog/
// http://www.gnu.org/software/libc/manual/html_node/Submitting-Syslog-Messages.html               

#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <syslog.h>

static char const *priov[] = {
    "EMERG:", "ALERT:", "CRIT:", "ERR:", "WARNING:", "NOTICE:", "INFO:", "DEBUG:"
};

static int noop(void) {return 0;}


     
     
     



static size_t writer(void *cookie, char const *data, size_t leng)
{
    (void)  cookie;
    int     p = LOG_DEBUG;
    int len = 0; 
    do {
        len = strlen(priov[p]);
    } while (memcmp(data, priov[p], len) && --p >= 0);

    if (p < 0) {
        p = LOG_ALERT;
    } else { 
        data += len, leng -= len;
    }

    while (*data == ' ' ) {
        /* remove leading whitespaces*/
        ++data, --leng; 
   }

    syslog(p, "%.*s", leng, data);
    return  leng;
}

static cookie_io_functions_t log_fns = {
    (void*) noop, (void*) writer, (void*) noop, (void*) noop
};

void tolog(FILE **pfp)
{
    setvbuf(*pfp = fopencookie(NULL, "w", log_fns), NULL, _IOLBF, 0);
}

int main(int nargs, char** args){
    setlogmask (LOG_UPTO (LOG_NOTICE));
    openlog ("transcoder", LOG_CONS | LOG_PID | LOG_NDELAY, LOG_LOCAL1);
    tolog(&stderr);
    tolog(&stdout);
    printf("WARNING:asdf");
    closelog ();
}
