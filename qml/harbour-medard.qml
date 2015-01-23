import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "pages"

ApplicationWindow
{
    id: root

    // NEW
    property var domainslist
    property int domainIndex: getSetting('region')
    property string forecastId: getSetting('forecast')
    property int language: 1
    property int forecastIndex: 0
    property var initdates
    signal autoIncrement // for controlling it from the cover
    signal autoDecrement // for controlling it from the cover
    property alias currentIndex: weatherView.currentIndex
    property bool loading: false
    // end NEW

    initialPage: ForecastView { id: weatherView }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")


    property var db: null

    function openDB() {
        if(db !== null) return;

        db = LocalStorage.openDatabaseSync("harbour-medard", "0.5", "Medard Weather Forecast", 100000);

        try {
            db.transaction(function(tx){
                tx.executeSql('CREATE TABLE IF NOT EXISTS settings(key TEXT UNIQUE, value TEXT)');
                var table  = tx.executeSql("SELECT * FROM settings");
                // Insert default values
                if (table.rows.length === 0) {
                    tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["region", 0]);
                    tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["forecast", 'precip']);
                    tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["forecastIndex", 2]);
                    tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["language", 1]);
                };
            });
        } catch (err) {
            console.log("Error creating table in database: " + err);
        };
    }


    function saveSetting(key, value) {
        openDB();
        db.transaction( function(tx){
            tx.executeSql('INSERT OR REPLACE INTO settings VALUES(?, ?)', [key, value]);
        });
    }

    function getSetting(key) {
        openDB();
        var res = "";
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT value FROM settings WHERE key=?;', [key]);
            res = rs.rows.item(0).value;
        });
        return res;
    }

    ListModel {
        id: forecastsModel
    }

    function fillTypes(thisIndex) {
        forecastsModel.clear()
        var currentForecastsLength = domainslist[thisIndex].forecasts.length
        for (var i = 0; i < currentForecastsLength; i++) {
            forecastsModel.append(domainslist[thisIndex].forecasts[i])
        }
    }
    onDomainslistChanged: {
        fillTypes(0)
    }

    function loadModel() {
        var idatesLength = initdates.length;
        var dateNow = Date.now()/1000
        var hoursSince = Math.round((dateNow - initdates[0])/3600)
        var hoursAvailable = 48-hoursSince
        picModel.clear()
        for (var i = 0; i < hoursAvailable; i++) {
            var targetDate = (Math.round(dateNow/3600)+i)*3600
            picModel.append({'initdate': initdates[0], 'initdate2': initdates[2], 'targetdate': targetDate})
        }
    }
    ListModel {
        id: picModel
    }
}
