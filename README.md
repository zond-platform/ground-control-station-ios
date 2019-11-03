## Description

This is a GCS (Ground Control Station) application for DJI Drones which is intended
to be used for mapping missions. So far only the core functionality is there:
* Establishing drone connection and registering DJI SDK
* Displaying telemetry status and logging to console
* Running DJI on-board simulator
* Executing take off and land commands

The code conforms to Apple's MVC architectural pattern i.e. the "View" and the "Model"
communicate exclusively via the "Controller". In the context of this application
the "Model" is represented by a bunch of services that connect to the aircraft
and notify view controllers.

## Todo

General:
* Remove Logger class and replace functionality with delegates
* Refactor Environment class by adding public properties instead of getters
* Rearrange the views to use tabs: one tab with the video feed and console and one with mission controls (5)

Map:
* ~~Replace map icons and make them show direction~~
* ~~Extend MapViewController with adding polygons on the map~~
* ~~Transform polygon's area into grid coordinates suitable for mission planning~~
* Make polygons draggable (3)
* Limit polygon update rate (1)
* Build default polygon based on current map region (2)
* Dynamically add and remove points from the polygon (4)
* Set grid lines distance in meters (6)

Mission:
* Add commands for mission upload and execution
