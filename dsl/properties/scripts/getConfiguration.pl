##########################################################################
# getConfiguration - get the information of the configuration given
#
# Arguments:
#   -configName: name of the configuration to retrieve
#
# Returns:
#   -configToUse: hash containing the configuration information
#
#########################################################################
sub getConfiguration($){

  my ($configName) = @_;

  # get an EC object
  my $ec = new ElectricCommander();
  $ec->abortOnError(0);

  my %configToUse;

  my $proj = "$[/myProject/projectName]";
  my $pluginConfigs = new ElectricCommander::PropDB($ec,"/projects/$proj/ec_plugin_cfgs");

  my %configRow = $pluginConfigs->getRow($configName);

  # Check if configuration exists
  unless(keys(%configRow)) {
      exit 1;
  }

  # Get user/password out of credential
  my $xpath = $ec->getFullCredential($configRow{credential});
  $configToUse{'DT_URL'} = $xpath->findvalue("//userName");
  $configToUse{'DT_TOKEN'} = $xpath->findvalue("//password");


  foreach my $c (keys %configRow) {

      #getting all values except the credential that was read previously
      if($c ne "credential"){
          $configToUse{$c} = $configRow{$c};
      } 

  }

  return %configToUse;

}
