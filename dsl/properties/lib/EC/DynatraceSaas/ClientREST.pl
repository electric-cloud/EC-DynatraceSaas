package EC::DynatraceSaas::ClientREST;


use strict;
use warnings;
use LWP::UserAgent;
use Data::Dumper;
use HTTP::Request;
use XML::Simple;


sub new {
    my ($class, %params) = @_;

    my $self = {
        url => $params{url},
        apitoken => $params{apitoken},
    };

    return bless $self, $class;
}


sub _ua {
    my ($self) = @_;

    unless($self->{_ua}) {
        $self->{_ua} = LWP::UserAgent->new;
    }
    return $self->{_ua};
}

sub _request {
    my ($self, $method, $url, $params, $payload) = @_;

    $url = qq{$self->{url}/api/v1/$url};
    my $uri = URI->new($url);
    $uri->query_form(%$params);
    print "Requesting uri: $uri\n";
    my $request = HTTP::Request->new($method => $uri);

    if ($payload) {
        $request->content($payload);
    }
    
    $request->header('Content-Type' => 'application/json');
    $request->header('Authorization' => qq{Api-Token $self->{apitoken}});

    my $response = $self->_ua->request($request);
    unless ($response->is_success) {
        die Dumper $response->content;
    }

    my $data = $response->content;
    return $data;
}

sub get_problems {
    my ($self, %params) = @_;
    return $self->_request('GET', 'problem/status', \%params);
}

sub push_event {
    my ($self, %params) = @_;
    my %req_param=();
    my $PAYLOAD=qq{
        {
          "eventType": "CUSTOM_DEPLOYMENT",
          "attachRules" : {
            "tagRule" : [
              {
                "meTypes" : ["$params{ENTITYTYPE}"],
                "tags" : [
                  {
                    "context" : "$params{TAGCONTEXT}",
                    "key" : "$params{TAGNAME}",
                    "value" : "$params{TAGVALUE}"
                  }]
              }]
          },
          "deploymentName" : "$params{DEPLOYMENTNAME}",
          "deploymentVersion" : "$params{DEPLOYMENTVERSION}",
          "deploymentProject" : "$params{DEPLOYMENTPROJECT}",
          "source" : "Electric Flow",
          "ciBackLink" : "$params{CILINK}",
          "customProperties" : {
            "BuildUrl" : "$params{BUILDURL}",
            "GitCommit" : "$params{GITCOMMIT}"
          }
        }
    };
	
    #print Dumper $PAYLOAD;
    return $self->_request('POST', 'events', \%req_param, $PAYLOAD);
}

1;
