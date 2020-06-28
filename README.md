## Project Overview

This is a simple GCS (Ground Control Station) iOS app for DJI drones that allows execution of mapping missions.

Current functionality includes:
* Connection to the DJI product via DJI's iOS SDK. Only USB remote controller connection is supported.
* Mission editor that allows the adjustment of different mission parameters.
* Simulator integration. Allows running missions without flying which is very useful for testing.
* Executing missions with the given parameters.
* Tracking user and aircraft positions.
* Displaying telemetry.
* Outputing log messages in the console for better user experience.

The app is tested on Phantom 4 V2 and Mavic Pro models but theoretically all DJI drones should be supported.

### Create Mission

Is enabled by tapping the "Mission" button. The "mission" polygon will be added to the map at the user position.
It then can be adjusted by dragging the verticies or the polygon itself. Once the editing is finished the mission can
be uploaded on the drone.

![Alt Text](Screenshots/edit-mission.GIF)

Please note that the aircraft has to be connected in order to run the simulator or upload the mission.

### Run Mission

If the upload finished succesfully the drone can safely start the mission. During the mission execution the status
will be reported via the console. Once finished the "mission" polygon will return to the editing state.

![Alt Text](Screenshots/run-mission.GIF)

At every stage the mission can be safely paused/resumed or stopped completely. In the latter case the aircraft will
hover at the current position allowing the user to either execute a new mission or use a remote controller directly.
