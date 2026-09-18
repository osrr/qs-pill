pragma Singleton

import Quickshell
import Quickshell.Services.Mpris
import QtQuick

Singleton {
    id: root

    property MprisPlayer activePlayer: null

    readonly property string title: activePlayer?.trackTitle ?? ""
    readonly property string artist: activePlayer?.trackArtist ?? ""
    readonly property string album: activePlayer?.trackAlbum ?? ""
    readonly property string artUrl: activePlayer?.trackArtUrl ?? ""

    readonly property bool isPlaying: activePlayer?.isPlaying ?? false
    readonly property bool canGoNext: activePlayer?.canGoNext ?? false
    readonly property bool canGoPrevious: activePlayer?.canGoPrevious ?? false
    readonly property bool canPlay: activePlayer?.canPlay ?? false
    readonly property bool canPause: activePlayer?.canPause ?? false

    readonly property real position: activePlayer?.position ?? 0
    readonly property real length: activePlayer?.length ?? 0

    function next() {
        if (activePlayer && activePlayer.canGoNext)
            activePlayer.next();
    }

    function previous() {
        if (activePlayer && activePlayer.canGoPrevious)
            activePlayer.previous();
    }

    function togglePlaying() {
        if (activePlayer)
            activePlayer.togglePlaying();
    }

    function updateActivePlayer() {
        const players = Mpris.players.values;

        // current player got closed entirely -> drop it
        if (activePlayer && !players.includes(activePlayer))
            activePlayer = null;

        // some OTHER player started playing -> switch to it
        const playing = players.find(p => p.isPlaying && p !== activePlayer);
        if (playing) {
            activePlayer = playing;
            return;
        }

        // nothing currently playing and we have no player at all yet -> pick any
        if (!activePlayer && players.length > 1)
            activePlayer = players[1];
    }

    Component.onCompleted: updateActivePlayer()

    Connections {
        target: Mpris.players
        function onValuesChanged() {
            root.updateActivePlayer();
        }
    }

    Instantiator {
        model: Mpris.players.values
        delegate: Connections {
            target: modelData
            function onIsPlayingChanged() {
                root.updateActivePlayer();
            }
        }
    }
}
