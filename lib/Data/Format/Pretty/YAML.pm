package Data::Format::Pretty::YAML;

use 5.010001;
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

    my $interactive = (-t STDOUT);
    my $pretty = $opts->{pretty} // 1;
    my $color  = $opts->{color} // $ENV{COLOR} // $interactive //
        $opts->{pretty};
    my $linum  = $opts->{linum} // $ENV{LINUM} // 0;

    if ($color) {
        require YAML::Tiny::Color;
        local $YAML::Tiny::Color::LineNumber = $linum;
        YAML::Tiny::Color::Dump($data);
    } else {
        require YAML::Syck;
        local $YAML::Syck::ImplicitTyping = 1;
        local $YAML::Syck::SortKeys       = 1;
        local $YAML::Syck::Headless       = 1;
        if ($linum) {
            require SHARYANTO::String::Util;
            SHARYANTO::String::Util::linenum(YAML::Syck::Dump($data));
        } else {
            YAML::Syck::Dump($data);
        }
    }
}

1;
# ABSTRACT: Pretty-print data structure as YAML

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

=item * color => BOOL (default: from env or 1)

Whether to enable coloring. The default is the enable only when running
interactively.

=item * pretty => BOOL (default: 1)

Whether to focus on prettyness. If set to 0, will focus on producing valid YAML
instead of prettiness.

=item * linum => BOOL (default: from env or 0)

Whether to enable line numbering.

=back

=head2 content_type() => STR

Return C<text/yaml>.


=head1 ENVIRONMENT

=head2 COLOR => BOOL

Set C<color> option (if unset).

=head2 LINUM => BOOL

Set C<linum> option (if unset).


=head1 FAQ


=head1 SEE ALSO

L<Data::Format::Pretty>

=cut
