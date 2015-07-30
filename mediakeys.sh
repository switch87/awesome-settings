#!/bin/bash
# $1: Mediaplayer or if no mediaplayer given command
# $2: Command (only if in comkbination with mediaplayer)

# mediaplayers: all players that the script should automatically controll, players with more priority first
# standardPlayer: player to start if no other is active
# uri: uri to play is no player active, may be a file, playlist, url, ...
mediaPlayers=( "vlc" "spotify" "banshee" )
standardPlayer="banshee"
uri="http://176.31.235.147:8000"

function getPlayerStatus
{
    # return values:
    #       0: Stopped
    #       1: Playing
    #       2: Paused
    #       3: Program not running
    pstatus=$( $qdbus"Player.PlaybackStatus" ) 
    if [ $? == 0 ]    
    then
        if [ $pstatus == "Stopped" ]
        then
            echo 0
        elif [ $pstatus == "Playing" ]
        then
            echo 1
        else
            echo 2
        fi
    else
        echo 3
    fi
}

function startFavUri
{
    if [ $playerStatus == 3 ]
    then
        $( $player )& 
        sleep 5 
    fi
    $( $favUri )
}

function mediaKey
{
    player=$1
    commando=$2
    if [ !$playerSelected ]
    then
        playerSelected=true
        selectedPlayer=$player
    fi
    qdbus="qdbus org.mpris.MediaPlayer2.$player /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2."
    favUri=$qdbus"Player.OpenUri $uri"
    playerStatus=$(getPlayerStatus)
    echo $player \($playerStatus\) - $commando - selected - $selectedPlayer
    if [ $commando == play ]
    then
        echo commando is play
        if [ $playerStatus == 1 ] # Playing
        then
            echo playing
            if [ $( $qdbus"Player.CanPause" ) == true ]
            then
                echo CanPause
                $( $qdbus"Player.Pause" )&
            else
                echo CantPause
                $( $qdbus"Player.Stop" )&
            fi
        elif [ $playerStatus == 3 ] # Program not running
        then
            if [ $player == $standardPlayer ]
            then
                startFavUri
            else
                #mediaKey $standardPlayer play
                playerSelected=false
            fi
        elif [ $( $qdbus"Player.CanPause" ) == true ] # number or video paused 
        then
            echo can play
            $( $qdbus"Player.PlayPause" )&
        else
            if [ $player != $standardPlayer ]
            then
                $( $qdbus"Quit" )&
                playerSelected=false
            else
                mediaKey $player play 
            fi
        fi

    elif [ $commando == pauseOrNothing ]
    then
        if [ $playerStatus != 3 ]
        then
            $( $qdbus"Player.Pause" )&
        fi

    elif [ $commando == next ]
    then
        if [ $( $qdbus"Player.CanGoNext" ) ]
        then
            $( $qdbus"Player.Next" )&
        elif [ $playerStatus == 3 ]
        then
            playerSelected=false
     elif [ $commando == prev ]
    then
        if [ $( $qdbus"Player.CanGoPrevious" ) ]
        then
            $( $qdbus"Player.Previous" )&
        elif [ $playerStatus == 3 ]
        then
            playerSelected=false
        fi
   fi
    elif [ $commando == fav ]
    then
        startFavUri
    else
        echo commando not known
    fi
}

playerSelected=false
selectedPlayer=""
if [ $2 ]
then
    playerSelected=true
    commando=$2
    mediaKey $1 $2
else
    commando=$1
fi
for player in "${mediaPlayers[@]}"
do
    echo $playerSelected
    if [ $playerSelected == true ]
    then
        echo 1
        if [ $selectedPlayer != $player ]
        then
            mediaKey $player pauseOrNothing
        fi
    else
        echo 2
        mediaKey $player $commando 
    fi
done
