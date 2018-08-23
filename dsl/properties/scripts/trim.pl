#######################################################################
# trim - deletes blank spaces before and after the entered value in
# the argument
#
# Arguments:
#   -untrimmedString: string that will be trimmed
#
# Returns:
#   trimmed string
#
########################################################################
sub trim($) {

  my ($untrimmedString) = @_;

  my $string = $untrimmedString;

  #removes leading spaces
  $string =~ s/^\s+//;

  #removes trailing spaces
  $string =~ s/\s+$//;

  #returns trimmed string
  return $string;
}
