pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    property string searchText: ""
    property int selectedIndex: 0

    readonly property var applications: DesktopEntries.applications.values

    readonly property var filteredApplications: {
        const query = searchText.trim().toLowerCase()

        if (!query)
        return applications

        return applications.filter(app => {
            return app.name.toLowerCase().includes(query)
            || app.genericName.toLowerCase().includes(query)
            || app.keywords.some(keyword =>
            keyword.toLowerCase().includes(query)
        )
    })
}

    function search(text) {
        searchText = text
        selectedIndex = 0
    }

    function selectNext() {
        if (filteredApplications.length === 0)
        return

        selectedIndex = Math.min(
            selectedIndex + 1,
            filteredApplications.length - 1
        )
    }

    function selectPrevious() {
        if (filteredApplications.length === 0)
        return

        selectedIndex = Math.max(
            selectedIndex - 1,
            0
        )
    }

    function launchSelected() {
        if (filteredApplications.length === 0)
        return

        const app = filteredApplications[selectedIndex]

        app.execute()
    }
}
