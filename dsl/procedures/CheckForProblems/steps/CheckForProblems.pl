#
#  Copyright 2018 Electric Cloud, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
$[/myProject/scripts/preamble]

use EC::DynatraceSaas::ClientREST;
use ElectricCommander;
use JSON;
use Data::Dumper;
my $ec = new ElectricCommander();

$[/myProject/scripts/trim]
$[/myProject/scripts/getConfiguration]

#Get the parameters values into global variables
$::gConfigName = trim($ec->getProperty("/myCall/config")-> findvalue("//value")->value());

sub main() {
    my %configuration;

    ##The configuration settings are retrieved
    if($::gConfigName ne ''){
        %configuration = getConfiguration($::gConfigName);
    }
        
    #inject config...
    if(%configuration){
        #Checks that the configuration parameters are not null
        if($configuration{'DT_URL'} ne '' && $configuration{'DT_TOKEN'} ne '' ){

            my $DT_URL = $configuration{'DT_URL'};
            my $DT_TOKEN  = $configuration{'DT_TOKEN'};
           
            my $clientREST = EC::DynatraceSaas::ClientREST->new(url => $DT_URL, apitoken => $DT_TOKEN);
            my $text = $clientREST->get_problems;
            my $data = decode_json($text);
            my $problem_count= $data->{result}->{totalOpenProblemsCount};
            print "Dynatrace Problems Found: ${problem_count}";
            exit ${problem_count};
        }
    }
}

main();
