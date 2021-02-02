#include <stdio.h>
#include <stdlib.h>
#include <vlc/vlc.h>

int main(int argc, char* argv[])
{
    libvlc_instance_t * inst;
    libvlc_media_player_t *mp;
    libvlc_media_t *m;
    
    inst = libvlc_new (0, NULL); /* Load the VLC engine */
 
    m = libvlc_media_new_path (inst, /* Create a new item */
           "http://127.0.0.1:8080/streaming/300_full.mp4");
       
    mp = libvlc_media_player_new_from_media (m); /* Create a media player playing environement */
    
    libvlc_media_release (m); /* No need to keep the media now */

#if 0
    /* This is a non working code that show how to hooks into a window,
     * if we have a window around */
     libvlc_media_player_set_xdrawable (mp, xdrawable);
#endif

    libvlc_media_player_play (mp); /* play the media_player */
   
    sleep (50); /* Let it play a bit */
   
    libvlc_media_player_stop (mp); /* Stop playing */

    libvlc_media_player_release (mp); /* Free the media_player */

    libvlc_release (inst);

    return 0;
}
