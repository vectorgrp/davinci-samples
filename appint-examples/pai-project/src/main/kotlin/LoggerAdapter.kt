class LoggerAdapter(val cfgLogger: com.vector.cfg.util.log.ILogger) : com.vector.ecusdk.appint.base.ILogger {
    override fun trace(message: String) {
        cfgLogger.trace(message)
    }

    override fun debug(message: String) {
        cfgLogger.debug(message)
    }

    override fun info(message: String) {
        cfgLogger.info(message)
    }

    override fun warn(message: String) {
        cfgLogger.warn(message)
    }

    override fun error(message: String) {
        cfgLogger.error(message)
    }
}
