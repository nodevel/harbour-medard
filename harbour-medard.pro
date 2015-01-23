TARGET = harbour-medard

CONFIG += sailfishapp


lupdate_only{
SOURCES += \
        qml/*.qml \
        qml/cover/*.qml \
        qml/pages/*.qml \
}


SOURCES += src/harbour-medard.cpp

OTHER_FILES += qml/harbour-medard.qml \
    qml/cover/CoverPage.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-medard.spec \
    rpm/harbour-medard.yaml \
    harbour-medard.desktop \
    qml/pages/AboutView.qml \
    images/icon-cover-wind.png \
    images/icon-cover-temperature.png \
    images/icon-cover-pressure.png \
    i18n/harbour-medard_en_US.qm \
    i18n/harbour-medard_cs_CZ.qm \
    qml/pages/FlickableView.qml \
    qml/pages/ForecastView.qml

LANGUAGES = cs_CZ en_US
# var, prepend, append
#defineReplace(prependAll) {
#    for(a,$$1):result += $$2$${a}$$3
#    return($$result)
#}
#LRELEASE = lrelease
#TRANSLATIONS = i18n/harbour-medard_cs_CZ.ts \
#               i18n/harbour-medard_en_US.ts

qmfiles.files = harbour-medard_cs_CZ.qm \
                harbour-medard_en_US.qm
qmfiles.path = /usr/share/$${TARGET}/i18n
#qmfiles.CONFIG += no_check_exist
INSTALLS += qmfiles

#CODECFORTR = UTF-8
#CODECFORSRC = UTF-8
