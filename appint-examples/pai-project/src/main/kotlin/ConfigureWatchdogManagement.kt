import com.vector.cfg.automation.scripting.api.IScriptCreationApi
import com.vector.cfg.automation.scripting.api.IScriptFactory
import com.vector.cfg.automation.scripting.api.IScriptTaskTypeApi.DV_PROJECT
import com.vector.cfg.model.pai.api.transaction
import com.vector.ecusdk.appint.wdgm.WatchdogConfig
import com.vector.ecusdk.appint.wdgm.collectSupervisedEntityAppPatternInstances
import com.vector.ecusdk.appint.wdgm.configureWatchdogManagement

class ConfigureWatchdogManagement : IScriptFactory {
    override fun createScript(creationApi: IScriptCreationApi) {
        creationApi.scriptTask("configureWatchdogManagement", DV_PROJECT) {
            taskDescription("Execute the WdgM Top Down Service Configuration.")
            code {
                val logger = LoggerAdapter(scriptLogger)
                val matchingInstances = collectSupervisedEntityAppPatternInstances(project)
                transaction {
                    configureWatchdogManagement(project, logger, WatchdogConfig(matchingInstances))
                }
            }
        }
    }
}
