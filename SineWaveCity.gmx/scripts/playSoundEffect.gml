if audio_is_playing(argument[0]) {
  audio_stop_sound(argument[0]);
}

audio_play_sound(argument[0],1,false);
