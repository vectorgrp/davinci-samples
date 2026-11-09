import com.vector.cfg.automation.scripting.api.IScriptCreationApi
import com.vector.cfg.automation.scripting.api.IScriptFactory
import com.vector.cfg.automation.scripting.api.IScriptTaskTypeApi.DV_PROJECT
import com.vector.cfg.model.access.AsrPath
import com.vector.cfg.model.mdf.model.autosar.ecucdescription.MIContainer
import com.vector.cfg.model.pai.api.mdfModel
import com.vector.cfg.model.pai.api.transaction
import com.vector.cfg.sysdesc.model.component.SIAtomicComponent
import com.vector.cfg.sysdesc.model.pai.sysDescModel
import com.vector.ecusdk.appint.os.OsAppMapping
import com.vector.ecusdk.appint.os.mapSwcsToOsApps

class MapSwcsToOsApps : IScriptFactory {
    override fun createScript(creationApi: IScriptCreationApi) {
        creationApi.scriptTask("mapSwcsToOsApps", DV_PROJECT) {
            taskDescription("Execute the SWC to OS Application Mapping.")
            code {
                val logger = LoggerAdapter(scriptLogger)
                transaction {
                     //TODO replace with concrete elements matching your project
                    val systemApplicationPath = "/ActiveEcuC/Os/SystemApplication_OsCore0"
                    val systemApplication = project.mdfModel(AsrPath.create(systemApplicationPath, MIContainer::class.java))
                        ?: error("OS application '$systemApplicationPath' not found.")

                    val mySwc = project.sysDescModel.flatComponentView
                        .filterIsInstance<SIAtomicComponent>().single { it.name == "MySwc" }

                    mapSwcsToOsApps(
                        project, logger, listOf(
                            OsAppMapping(component = mySwc, osApp = systemApplication)
                        )
                    )
                }
            }
        }
    }
}
