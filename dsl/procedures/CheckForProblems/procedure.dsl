import java.io.File

def procName = 'CheckForProblems'
procedure procName,
        description: 'Check for problems found in Dynatrace Saas', {

    step 'CheckForProblems',
            command: new File(pluginDir, "dsl/procedures/$procName/steps/CheckForProblems.pl").text,
            errorHandling: 'failProcedure',
            exclusiveMode: 'none',
            releaseMode: 'none',
            shell: 'ec-perl',
            timeLimitUnits: 'minutes'

}
