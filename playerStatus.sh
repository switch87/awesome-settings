#!/bin/bash

echo $( qdbus org.mpris.MediaPlayer2.$1 /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlaybackStatus ) > /tmp/awesomeps1

