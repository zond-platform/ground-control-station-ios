## Description

This is a GCS (Ground Control Station) application for DJI Drones which is intended
to be used for mapping missions. So far only the core functionality is there:
* Establishing drone connection and registering DJI SDK
* Displaying telemetry status and logging to console
* Running DJI on-board simulator
* Executing take off and land commands

The code conforms to Apple's version of the MVC architectural pattern i.e. the
view and the model communicate exclusively via the controller. In the context
of this application the model is represented by a bunch of services that connect
to the aircraft and notify view controllers which update the views.

## Todos

General:
* Remove Logger class and replace functionality with delegates (7)
* Refactor Environment class by adding public properties instead of getters (6)
* Rearrange the views to use tabs: one tab with the video feed and console and one with mission controls (1)

Map:
* ~~Replace map icons and make them show direction~~
* ~~Extend MapViewController with adding polygons on the map~~
* ~~Transform polygon's area into grid coordinates suitable for mission planning~~
* ~~Make polygons draggable~~
* ~~Limit polygon update rate~~
* Build default polygon based on current map region (3)
* Dynamically add and remove points from the polygon (5)
* Set grid lines distance in meters (4)

Mission:
* Add commands for mission upload and execution (2)
