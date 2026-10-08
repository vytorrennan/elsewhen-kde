import QtQuick
import QtTest
import "../package/contents/ui"
import "../package/contents/ui/Commons" as Compat

TestCase {
    name: "ElsewhenPlasma"
    when: windowShown
    width: 388
    height: 600
    visible: true

    Item {
    id: fixture
    width: 388
    height: 600
    Rectangle { anchors.fill: parent; color: "#eff0f1" }

    WorldClock {
        id: clock
        anchors.fill: parent
        opened: true
        settings: ({zones: "São Paulo|America/Sao_Paulo, London|Europe/London, Tokyo|Asia/Tokyo", hour24: true})
    }
    }

    function test_themeHelpers() {
        verify(Compat.Color.popups !== undefined)
        verify(Compat.Color.popups.background.a > 0)
        verify(Compat.Color.foreground.a > 0)
        compare(clock.foreground, Compat.Color.foreground)
        verify(Compat.Border.flat(Compat.Color.foreground, 1).width === 1)
    }

    function test_clockAndGlobe() {
        tryVerify(function() { return clock.clockRows.length === 3 && clock.clockRows.every(function(r) { return r.ready }) }, 10000)
        compare(clock.clockRows[0].offsetMinutes, -180)
        compare(clock.clockRows[2].offsetMinutes, 540)
        verify(clock.localZone !== "")
        tryVerify(function() { return clock.zoneOptions.length > 100 }, 10000)
        clock.addCity("America/New_York", "New York")
        compare(clock.zones.length, 4)
        clock.removeCityAt(3)
        compare(clock.zones.length, 3)
        clock.toggleHour24()
        compare(clock.hour24, false)
        clock.toggleHour24()
        compare(clock.hour24, true)
        clock.shiftHour(1)
        compare(clock.scrubMinutes, 60)
        clock.scrubMinutes = 0
        var globe = findChild(clock, "globeLoader")
        verify(globe !== null)
        clock.setGlobeMode(true, false)
        tryVerify(function() { return globe.item !== null && globe.item.land.length > 0 && globe.item.cities.length > 0 }, 5000)
        tryVerify(function() { return Object.keys(globe.item.offsets).length > 20 }, 10000)
        tryCompare(clock, "zoom", 1, 3000)
        globe.item.goTo("Tokyo", "Asia/Tokyo")
        wait(1200)
        fixture.grabToImage(function(result) { result.saveToFile(Qt.resolvedUrl("../globe.png").toString().replace("file://", "")) })
        wait(300)
        clock.setGlobeMode(false, false)
        tryCompare(clock, "zoom", 0, 3000)
        clock.startAdding()
        var search = findChild(clock, "citySearch")
        verify(search.active)
        verify(search.matches.length > 0)
        search.pick(search.matches[0])
        compare(clock.zones.length, 4)
        verify(!search.active)
        clock.removeCityAt(3)
        fixture.grabToImage(function(result) { result.saveToFile(Qt.resolvedUrl("../clocks.png").toString().replace("file://", "")) })
        wait(300)
    }

    function test_weather() {
        tryVerify(function() {
            var f = clock.facts["São Paulo|America/Sao_Paulo"];
            return f && f.lat !== undefined && f.c !== undefined;
        }, 45000)
        fixture.grabToImage(function(result) { result.saveToFile(Qt.resolvedUrl("../clocks.png").toString().replace("file://", "")) })
        wait(300)
    }
}
