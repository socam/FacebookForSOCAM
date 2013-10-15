# Add more folders to ship with the application, here
folder_01.source = qml/FacebookForSOCAM
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# Avoid auto screen rotation
#DEFINES += ORIENTATIONLOCK

# Needs to be defined for Symbian
DEFINES += NETWORKACCESS

symbian:TARGET.CAPABILITY += NetworkServices Location LocalServices ReadUserData WriteUserData
symbian:TARGET.UID3 = 0xE1BEAB81
PACKAGENAME = es.zed.socam.facebook

!symbian: {
    DEFINES += HAVE_GLWIDGET
    QT += opengl
}
symbian {
    # TARGET.UID3 = 0x20041106
    # DEPLOYMENT.installer_header=0x2002CCCF

    vendorinfo = \
    "%{\"Tommi Laukkanen\"}" \
    ":\"Tommi Laukkanen\""

    my_deployment.pkg_prerules = vendorinfo
    DEPLOYMENT += my_deployment
}


# Define QMLJSDEBUGGER to allow debugging of QML in debug builds
# (This might significantly increase build time)
# DEFINES += QMLJSDEBUGGER

# If your application uses the Qt Mobility libraries, uncomment
# the following lines and add the respective components to the 
# MOBILITY variable. 
#CONFIG += mobility
#MOBILITY += location
maemo5 {
  CONFIG += mobility11 qdbus
} else {
  CONFIG += mobility
}
MOBILITY += location

VERSION = 1.2.2

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    windowhelper.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    windowhelper.h

OTHER_FILES += \
    qtc_packaging/debian_fremantle/changelog \
    qtc_packaging/debian_fremantle/control \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    FacebookForSOCAM.desktop

desktopfile.files = $${TARGET}.desktop
desktopfile.path = /usr/share/applications
INSTALLS += desktopfile

icon.files = FacebookForSOCAM.png
icon.path = /usr/share/themes/base/meegotouch/icons/
INSTALLS += icon



