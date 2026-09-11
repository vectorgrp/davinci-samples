import com.vector.cfg.automation.scripting.api.IScriptCreationApi
import com.vector.cfg.automation.scripting.api.IScriptFactory
import com.vector.cfg.automation.scripting.api.IScriptTaskTypeApi.DV_PROJECT
import com.vector.cfg.model.pai.api.transaction
import com.vector.ecusdk.appint.ecum.collectModeManagementAppPatternInstances
import com.vector.ecusdk.appint.ecum.configureEcuModeManagement

class ConfigureEcuStateManagement : IScriptFactory {
    override fun createScript(creationApi: IScriptCreationApi) {
        creationApi.scriptTask("configureEcuStateManagement", DV_PROJECT) {
            taskDescription("Execute the EcuM Top Down Service Configuration.")
            code {
                val logger = LoggerAdapter(scriptLogger)
                val matchingInstances = collectModeManagementAppPatternInstances(project, logger)
                transaction {
                    configureEcuModeManagement(project, logger, matchingInstances)
                }
            }
        }
    }
}
