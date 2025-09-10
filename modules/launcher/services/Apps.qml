pragma Singleton

import qs.config
import qs.utils
import Caelestia
import Quickshell
import QtQuick

Searcher {
    id: root

    function launch(entry: DesktopEntry): void {
        appDb.incrementFrequency(entry.id);
        if (entry.runInTerminal)
            Quickshell.execDetached({
                command: ["app2unit", "--", ...Config.general.apps.terminal, `${Quickshell.shellDir}/assets/wrap_term_launch.sh`, ...entry.command],
                workingDirectory: entry.workingDirectory || Paths.home
            });
        else
            Quickshell.execDetached({
                command: entry.command,
                workingDirectory: entry.workingDirectory || Paths.home
            });
    }

    function search(search: string): list<DesktopEntry> {
        const prefix = Config.launcher.actionPrefix;
        if (search.startsWith(prefix)) {
            if (search === prefix) {
                return [];
            }

            const weights = [1];

            if (!search.startsWith(`${prefix}t `))
                return query(search).map(e => e.entry);
        }

        const results = query(search.slice(prefix.length + 2)).map(e => e.entry);
        if (search.startsWith(`${prefix}t `))
            return results.filter(a => a.runInTerminal);
        return results;
    }

    function getSearchableText(item: QtObject): string {
        const keys = ["name", "desc", "execString", "wmClass", "genericName", "categories", "keywords"];
        return keys.map(k => item[k]).join(" ");
    }

    list: appDb.apps
    useFuzzy: Config.launcher.useFuzzy.apps

    AppDb {
        id: appDb

        QtObject {
            required property DesktopEntry modelData
            readonly property string id: modelData.id
            readonly property string name: modelData.name
            readonly property string desc: modelData.comment
            readonly property string execString: modelData.execString
            readonly property string wmClass: modelData.startupClass
            readonly property string genericName: modelData.genericName
            readonly property string categories: modelData.categories.join(" ")
            readonly property string keywords: modelData.keywords.join(" ")
        }
        path: `${Paths.state}/apps.sqlite`
        entries: DesktopEntries.applications.values.filter(a => !Config.launcher.hiddenApps.includes(a.id))
    }
    // Variants {
    //     id: variants
    //     model: [...DesktopEntries.applications.values].filter(a => !Config.launcher.hiddenApps.includes(a.id)).sort((a, b) => a.name.localeCompare(b.name))
    //     QtObject {
    //         required property DesktopEntry modelData
    //         readonly property string id: modelData.id
    //         readonly property string name: modelData.name
    //         readonly property string desc: modelData.comment
    //         readonly property string execString: modelData.execString
    //         readonly property string wmClass: modelData.startupClass
    //         readonly property string genericName: modelData.genericName
    //         readonly property string categories: modelData.categories.join(" ")
    //         readonly property string keywords: modelData.keywords.join(" ")
    //     }
    // }
}