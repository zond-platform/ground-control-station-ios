## Description

This is a simple GCS (Ground Control Station) application for DJI drones which
is supposed to make standard quad copters execute mapping missions.

## Todos

General:
* ~~Redesign and refactor the entire view system. Consider using Swift UI~~ -> use standard table view
* ~~Refactor Logger class~~ -> removed
* Add control buttons to switch between map and live view
* Add control buttons to switch between map layers
* Add control buttons to zoom in and out on the map
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
* Find out how to remove compass when changing map orientation
* Replace connection service delegate with product service delegate
* Don't show mission polygon when the mission is already uploaded

Control View:
* Activate mission upload button
* Make section footers of the table view display performed action status
* Resolve table view slider cell update issue (post on StackOverflow?)
* Relocate view and add slide animation

Mission:
* ~~Add commands for mission upload and execution~~
* ~~Make CommandService report result via delegate~~
* Add mission start/stop/pause buttons (2)
* Provide extended controls for setting mission parameters (3)
