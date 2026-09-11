import com.vector.cfg.automation.scripting.api.IScriptCreationApi
import com.vector.cfg.automation.scripting.api.IScriptFactory
import com.vector.cfg.automation.scripting.api.IScriptTaskTypeApi.DV_PROJECT
import com.vector.cfg.model.pai.api.transaction
import com.vector.ecusdk.appint.diag.configureDiagnosticStack

class ConfigureDiagnosticStack : IScriptFactory {
    override fun createScript(creationApi: IScriptCreationApi) {
        creationApi.scriptTask("configureDiagStack", DV_PROJECT) {
            taskDescription("Execute the Diagnostic Top Down Service Configuration.")
            code {
                transaction {
                    configureDiagnosticStack(project, LoggerAdapter(scriptLogger))
                }
            }
        }
    }
}
