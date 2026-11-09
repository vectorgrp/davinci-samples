import com.vector.cfg.automation.scripting.api.IScriptCreationApi
import com.vector.cfg.automation.scripting.api.IScriptFactory
import com.vector.cfg.automation.scripting.api.IScriptTaskTypeApi.DV_PROJECT
import com.vector.cfg.model.pai.api.transaction
import com.vector.ecusdk.appint.base.replaceValuesByAlias
import com.vector.ecusdk.appint.nvm.*

class ConfigureMemStack : IScriptFactory {
    override fun createScript(creationApi: IScriptCreationApi) {
        creationApi.scriptTask("configureMemStack", DV_PROJECT) {
            taskDescription("Execute the NvM Top Down Service Configuration.")
            code {
                val logger = LoggerAdapter(scriptLogger)

                val memStackConfig = MemStackConfig(
                    globalConfig = MemStackConfig.GlobalConfig(),

                    //TODO replace with instructions matching your needs
                    nvBlockDescriptors = collectNvBlockDescriptors(project, logger).replaceValuesByAlias(
                        { it.name },
                        "ControlNvData_NvDescriptor" to MemStackConfig.NvMInstruction(writingPriority = 10),
                        "CodingParameters_NvDescriptor" to MemStackConfig.NvMInstruction(writingPriority = 7)
                    ),
                    pimAppPatternInstances = collectPimAppPatternInstances(project, logger),
                    bulkNvDataDescriptors = collectBulkNvDataDescriptors(project)
                )

                transaction {
                    configureMemStack(project, logger, memStackConfig)
                }
            }
        }
    }
}
