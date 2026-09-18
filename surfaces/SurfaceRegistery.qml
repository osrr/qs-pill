pragma Singleton

import Quickshell

Singleton {
    id: root

    enum SurfaceType {
        Clock,
        Dashboard,
        Launcher,
        Wallpaper
    }

    function source(currentSurface) {
        switch(currentSurface) {
            case SurfaceRegistery.SurfaceType.Clock:
                return "../views/ClockSurface.qml";

            case SurfaceRegistery.SurfaceType.Dashboard:
                return "../views/DashboardSurface.qml";

            case SurfaceRegistery.SurfaceType.Launcher:
                return "../views/LauncherSurface.qml";

            case SurfaceRegistery.SurfaceType.Wallpaper:
                return "../views/WallpaperSurface.qml";

            default:
                return "../views/ClockSurface.qml"
        }
    }

}
