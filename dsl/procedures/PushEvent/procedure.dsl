import java.io.File

def procName = 'PushEvent'
procedure procName,
        description: 'Push custom Event to Dynatrace Saas', {

    step 'PushEvent',
            command: new File(pluginDir, "dsl/procedures/$procName/steps/PushEvent.pl").text,
            errorHandling: 'failProcedure',
            exclusiveMode: 'none',
            releaseMode: 'none',
            shell: 'ec-perl',
            timeLimitUnits: 'minutes'

}
