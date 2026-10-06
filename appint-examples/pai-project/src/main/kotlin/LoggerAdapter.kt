class LoggerAdapter(val scriptLogger: com.vector.cfg.util.log.ILogger) : com.vector.ecusdk.appint.base.ILogger {
    override fun trace(message: String) = scriptLogger.info("[TRACE] $message") // trace message are hidden by default in the PAI logging
    override fun debug(message: String) = scriptLogger.info("[DEBUG] $message") // debug message are hidden by default in the PAI logging
    override fun info(message: String) = scriptLogger.info(message)
    override fun warn(message: String) = scriptLogger.warn(message)
    override fun error(message: String) = scriptLogger.error(message)
}
