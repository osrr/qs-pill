pragma Singleton

import Quickshell

Singleton {
    id: root

    enum SurfaceType {
        Clock,
        ControlCenter,
        Launcher,
        Wallpaper,
        Theme
    }

    function source(currentSurface) {
        switch(currentSurface) {
            case SurfaceRegistery.SurfaceType.Clock:
                return "../views/ClockSurface.qml";

            case SurfaceRegistery.SurfaceType.ControlCenter:
                return "../views/CCSurface.qml";

            case SurfaceRegistery.SurfaceType.Launcher:
                return "../views/LauncherSurface.qml";

            case SurfaceRegistery.SurfaceType.Wallpaper:
                return "../views/WallpaperSurface.qml";

            case SurfaceRegistery.SurfaceType.Theme:
                return "../views/ThemeSurface.qml";

            default:
                return "../views/ClockSurface.qml"
        }
    }

}
