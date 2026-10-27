#!/usr/bin/env bash
# SpotiBar MPRIS Controller Script
# HearneLabs

CMD="${1:-get}"
TARGET_PLAYER="${2:-spotify}"

resolve_player() {
    if playerctl -p "$TARGET_PLAYER" status >/dev/null 2>&1; then
        echo "$TARGET_PLAYER"
        return
    fi
    # If explicit target not found, check if any other instance of spotify or mpris is running
    local any_spotify
    any_spotify=$(playerctl -l 2>/dev/null | grep -iE 'spotify' | head -n 1)
    if [ -n "$any_spotify" ]; then
        echo "$any_spotify"
        return
    fi
    # Fallback to any active media player
    local any_player
    any_player=$(playerctl -l 2>/dev/null | head -n 1)
    if [ -n "$any_player" ]; then
        echo "$any_player"
        return
    fi
    echo ""
}

PLAYER=$(resolve_player)

case "$CMD" in
    get)
        if [ -n "$PLAYER" ]; then
            INFO=$(playerctl -p "$PLAYER" metadata --format '{{status}}|||{{title}}|||{{artist}}|||{{album}}|||{{mpris:artUrl}}|||{{position}}|||{{mpris:length}}' 2>/dev/null)
            if [ -n "$INFO" ]; then
                echo "$INFO"
            else
                STATUS=$(playerctl -p "$PLAYER" status 2>/dev/null || echo "Stopped")
                echo "$STATUS|||Spotify Ready|||No Active Track||||||0|||0"
            fi
        else
            echo "Offline|||Spotify Offline|||Click to Launch||||||0|||0"
        fi
        ;;
    play-pause)
        if [ -n "$PLAYER" ]; then
            playerctl -p "$PLAYER" play-pause
        else
            if command -v spotify-launcher >/dev/null 2>&1; then
                spotify-launcher &
            elif command -v spotify >/dev/null 2>&1; then
                spotify &
            fi
        fi
        ;;
    next)
        if [ -n "$PLAYER" ]; then
            playerctl -p "$PLAYER" next
        fi
        ;;
    previous)
        if [ -n "$PLAYER" ]; then
            playerctl -p "$PLAYER" previous
        fi
        ;;
    raise)
        if [ -n "$PLAYER" ]; then
            qdbus6 org.mpris.MediaPlayer2."$PLAYER" /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Raise >/dev/null 2>&1 || true
        else
            if command -v spotify-launcher >/dev/null 2>&1; then
                spotify-launcher &
            elif command -v spotify >/dev/null 2>&1; then
                spotify &
            fi
        fi
        ;;
    *)
        echo "Unknown command: $CMD"
        exit 1
        ;;
esac
