## Conceptual:
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
* ~~Rephrase log messages~~
* ~~Change app and repository name~~
* ~~Add app to the App Store Connect~~
* Write proper readme file with screenshots and docs

## Controls:
* ~~Move simulator button out of settings~~
* ~~Make multistate control buttons~~

## Map:
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
* ~~Reposition apple legal labels~~

## Mission:
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
* Change mission parameter ranges reliably

## Telemetry:
* ~~Fix flight mode appearance~~
* ~~Display aircraft horizontal velocity~~

## Style:
* ~~Split console view into several labels~~
* ~~Rework button selection style~~
* ~~Rework color scheme~~

## Future versions:
* Add PointSpan class
* Finilize general app style
* Add and remove points from the mission polygon with a tap
* Consider adding live view from the drone (interfere with shooting photos?)
* Add grid lines angle adjustment
* Store missions
* Record mission time
* Draw copter trace on the map when executing a mission
* Write UI tests
* Handle mission interruptions
* Consider trajectory overshooting on turns
* Make photo shooting more agile e.g. do not take pictures on turns
* Include mission name and parameters into the picture file name
* Add map ruler
* Further scale the vertex size with the zoom
* Consider adding intermediate waypoints between "long" travel distances
