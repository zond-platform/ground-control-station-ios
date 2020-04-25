## Description

This is a simple GCS (Ground Control Station) application for DJI drones which
is supposed to make standard quad copters execute mapping missions.

## Todos

General:
* ~~Redesign and refactor the entire view system. Consider using Swift UI~~
* ~~Refactor Logger class~~
* ~~Access environment via static function instead of passing it around~~
* Consider adding live view from the drone
* Start telemetry services only if aircraft is connected (not the remote controller)
* Consider using callbacks instead of delegates for internal component communication
* Consider subclassing UITableViewCell
* Take control over initialization order of static variables

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
* Fix or remove compass button completely
* Center map with an offset if the menu is open
* Draw copter trace on the map when executing a mission

Mission:
* ~~Activate mission upload button~~
* ~~Relocate view and add slide animation~~
* ~~Resolve table view slider cell update issue (post on StackOverflow?)~~
* ~~Add commands for mission upload and execution~~
* ~~Make CommandService report result via delegate~~
* ~~Add mission start/stop/pause buttons~~
* Log progress into the console view
* Provide extended controls for setting mission parameters
* Fix return home altitude
* Create mission history
* Record mission time
