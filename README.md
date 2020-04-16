## Description

This is a simple GCS (Ground Control Station) application for DJI drones which
is supposed to make standard quad copters execute mapping missions.

## Todos

General:
* ~~Redesign and refactor the entire view system. Consider using Swift UI~~ -> use standard table view
* ~~Refactor Logger class~~ -> removed
* Add control buttons to switch between map layers and live view
* Draw copter trace on the map when executing a mission
* Access environment via static function instead of passing it around
* Integrate internal notification mechanism for failed commands
* Start telemetry services only if aircraft is connected (not the remote)
* Consider using callbacks instead of delegates for internal component communication

Map:
* ~~Replace map icons and make them show direction~~
* ~~Extend MapViewController with adding polygons on the map~~
* ~~Transform polygon's area into grid coordinates suitable for mission planning~~
* ~~Make polygons draggable~~
* ~~Limit polygon update rate~~
* ~~Add grid lines distance adjustment~~
* Add and remove points from the mission polygon with a tap
* Add grid lines angle adjustment
* Don't show mission polygon when the mission is already uploaded
* Fix or remove compass button completelyo
* Center map with an offset if the menu is open

Control View:
* ~~Activate mission upload button~~
* ~~Relocate view and add slide animation~~
* Make section footers of the table view display performed action status
* Resolve table view slider cell update issue (post on StackOverflow?)
* Create mission history
* Record mission time

Mission:
* ~~Add commands for mission upload and execution~~
* ~~Make CommandService report result via delegate~~
* ~~Add mission start/stop/pause buttons~~
* Provide extended controls for setting mission parameters
* Fix return home altitude
