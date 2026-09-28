# Setup

Take the exemplary `build.gradle` and adapt the tasks to your liking in your own DaVinci Application Integration Gradle project (former DaVinci Team).

At the moment you could replace the following tasks:
- ConfigureMemStack -> CustomScriptTask calling "configureMemStack" script task from the pai-project
- ConfigureDiagStack -> CustomScriptTask calling "configureDiagStack" script task from the pai-project
- ConfigureEcuStateManagement -> CustomScriptTask calling "configureEcuStateManagement" script task from the pai-project

Make sure that the task order is kept in place.

Keep in mind, that the JSON instructions are not considered in the CustomScriptTask.

Either you parse them yourself in the script task or you rewrite the instructions as shown in the pai-project.

