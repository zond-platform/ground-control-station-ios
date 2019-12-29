## Description

This is a simple GCS (Ground Control Station) application for DJI drones which
is supposed to make standard quad copters execute mapping missions.

## Todos

General:
* Redesign and refactor the entire view system. Consider using Swift UI (1)
* Refactor Logger class (?)

Map:
* ~~Replace map icons and make them show direction~~
* ~~Extend MapViewController with adding polygons on the map~~
* ~~Transform polygon's area into grid coordinates suitable for mission planning~~
* ~~Make polygons draggable~~
* ~~Limit polygon update rate~~
* Add and remove points from the mission polygon with a tap (3)
* Add grid lines angle adjustment (5)
* Add grid lines distance adjustment (4)

Mission:
* ~~Add commands for mission upload and execution~~
* Provide extended controls for setting mission parameters (2)
