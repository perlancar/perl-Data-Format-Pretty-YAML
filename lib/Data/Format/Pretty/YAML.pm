package Data::Format::Pretty::YAML;

use 5.010;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(format_pretty);

# VERSION

sub content_type { "text/yaml" }

sub format_pretty {
    my ($data, $opts) = @_;
    $opts //= {};

    if ($opts->{color} // $ENV{COLOR} // (-t STDOUT)) {
        require YAML::Tiny::Color;
        local $YAML::Tiny::Color::LineNumber = 1;
        YAML::Tiny::Color::Dump($data);
    } else {
        require YAML::Syck;
        local $YAML::Syck::ImplicitTyping = 1;
        local $YAML::Syck::SortKeys       = 1;
        local $YAML::Syck::Headless       = 1;
        YAML::Syck::Dump($data);
    }
}

1;
# ABSTRACT: Pretty-print data structure as YAML
__END__

=head1 SYNOPSIS

 use Data::Format::Pretty::YAML qw(format_pretty);
 print format_pretty($data);

Some example output:

=over 4

=item * format_pretty({a=>1, b=>2})

  a: 1
  b: 2

=back


=head1 DESCRIPTION

This module uses L<YAML::Syck> to encode data as YAML.


=head1 FUNCTIONS

=head2 format_pretty($data, \%opts)

Return formatted data structure as YAML. Currently there are no known options.
YAML::Syck's settings are optimized for prettiness, currently as follows:

 $YAML::Syck::ImplicitTyping = 1;
 $YAML::Syck::SortKeys       = 1;
 $YAML::Syck::Headless       = 1;

Options:

=over

=item * color => BOOL

Whether to enable coloring. The default is the enable only when running
interactively. Currently also enable line numbering.

=back

=head2 content_type() => STR

Return C<text/yaml>.


=head1 ENVIRONMENT

=head2 COLOR => BOOL

Set C<color> option (if unset).


=head1 SEE ALSO

L<Data::Format::Pretty>

=cut

