## Description

This is a GCS (Ground Control Station) application for DJI Drones which is intended
to be used for mapping missions. So far only the core functionality is there:
* Establishing drone connection and registering DJI SDK
* Displaying telemetry status and logging to console
* Running DJI on-board simulator
* Executing take off and land commands

The code conforms with Apple's MVC pattern architecture as much as possible i.e.
"View" and "Model" communicate exclusively via the "Controller". In the context of
this application the "Model" is represented by a bunch of services that connect
to the aircraft and notify view controllers.

## Todo

* Remove Logger class and replace functionality with delegates
* Refactor Environment class by adding public properties instead of getters
* ~~Replace map icons and make them show direction~~
* Extend MapViewController with adding polygons on the map
* Transform polygon's area into grid coordinates suitable for mission planning
* Add commands for mission upload and execution
