## Description

This is a simple GCS (Ground Control Station) application for DJI drones which
is supposed to make standard quad copters execute mapping missions.

## Todos

Conceptual:
* ~~Redesign and refactor the entire view system. Consider using Swift UI~~
* ~~Refactor Logger class~~
* ~~Access environment via static function instead of passing it around~~
* ~~Create one unified telemetry service~~
* ~~Consider using callbacks instead of delegates for internal component communication~~
* ~~Start telemetry services only if aircraft is connected (not the remote controller)~~
* ~~Control initialization order of static variables~~
* ~~Hook up all services and ensure error handling~~
* ~~Consider sending telemetry as patches~~
* ~~Consider splitting Constants file~~
* ~~Add telemetry view~~
* Rephrase log messages
* Change app name

Controls:
* ~~Move simulator button out of settings~~
* ~~Make multistate control buttons~~

Map:
* ~~Replace map icons and make them show direction~~
* ~~Extend MapViewController with adding polygons on the map~~
* ~~Transform polygon's area into grid coordinates suitable for mission planning~~
* ~~Make polygons draggable~~
* ~~Limit polygon update rate~~
* ~~Add grid lines distance adjustment~~
* ~~Fix or remove compass button completely~~
* ~~Fix grid distance bug~~
* ~~Don't show mission polygon when the mission is already uploaded~~
* ~~Center map with an offset if the menu is open~~
* ~~Fix zoom when locking on the moving object~~
* ~~Add home position dashed line~~
* ~~Add mission start and stop points~~
* ~~Use callbacks instead of delegates for objects interaction~~
* Reposition apple legal labels

Mission:
* ~~Subclass UITableViewCell for different settings types~~
* ~~Add custom images to the UISwitch and UISlider~~
* ~~Consider splitting settings view into tabs~~
* ~~Add global constants for mission parameter constraints~~
* ~~Activate mission upload button~~
* ~~Relocate view and add slide animation~~
* ~~Resolve table view slider cell update issue~~
* ~~Add commands for mission upload and execution~~
* ~~Make CommandService report result via delegate~~
* ~~Add mission start/stop/pause buttons~~
* ~~Log progress into the console view~~
* ~~Provide extended controls for setting mission parameters~~
* ~~Fix return home altitude (maybe don't return home at all; add parameter?)~~
* ~~Switch back to editing state when mission is finished~~
* ~~Do not allow upload if aircraft gps is not locked~~

Telemetry:
* ~~Fix flight mode appearance~~
* ~~Display aircraft horizontal velocity~~

Style:
* ~~Split console view into several labels~~
* ~~Rework button selection style~~
* ~~Rework color scheme~~
* Finilize general app style

Future versions:
* Add and remove points from the mission polygon with a tap
* Consider adding live view from the drone (interfere with shooting photos?)
* Add grid lines angle adjustment
* Create mission history
* Record mission time
* Draw copter trace on the map when executing a mission
