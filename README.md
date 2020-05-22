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
* Add telemetry view
* Consider adding live view from the drone
* Monitor current aircraft velocity

Map:
* ~~Replace map icons and make them show direction~~
* ~~Extend MapViewController with adding polygons on the map~~
* ~~Transform polygon's area into grid coordinates suitable for mission planning~~
* ~~Make polygons draggable~~
* ~~Limit polygon update rate~~
* ~~Add grid lines distance adjustment~~
* ~~Fix or remove compass button completely~~
* Add and remove points from the mission polygon with a tap
* Add grid lines angle adjustment
* Don't show mission polygon when the mission is already uploaded
* Center map with an offset if the menu is open
* Draw copter trace on the map when executing a mission
* Use callbacks instead of delegates for objects interaction
* Fix zoom when locking on the moving object

Controls:
* ~~Move simulator button out of settings~~
* ~~Make multistate control buttons~~

Mission Editor:
* ~~Subclass UITableViewCell for different settings types~~
* ~~Add custom images to the UISwitch and UISlider~~
* ~~Consider splitting settings view into tabs~~
* ~~Add global constants for mission parameter constraints~~

Mission:
* ~~Activate mission upload button~~
* ~~Relocate view and add slide animation~~
* ~~Resolve table view slider cell update issue~~
* ~~Add commands for mission upload and execution~~
* ~~Make CommandService report result via delegate~~
* ~~Add mission start/stop/pause buttons~~
* ~~Log progress into the console view~~
* ~~Provide extended controls for setting mission parameters~~
* Fix grid distance bug
* Fix return home altitude
* Create mission history
* Record mission time

Style:
* ~~Split console view into several labels~~
* ~~Rework button selection style~~
* Rework color scheme (1)
* Adapt map annotation views to the general style (2)
