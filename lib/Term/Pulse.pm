package Term::Pulse;

use warnings;
use strict;

=head1 NAME

Term::Pulse - show pulsed progress bar in terminal

=head1 VERSION

Version 0.02

=cut

use version; our $VERSION = qv('0.02');
our @ISA = qw(Exporter);
our @EXPORT = qw(pulse_start pulse_stop);

use Time::HiRes qw(usleep time);
require Exporter;

=head1 SYNOPSIS

    use Term::Pulse;
    pulse_start( name => 'Checking', rotate => 0, time => 1 ); # start the pulse
    sleep 3;
    pulse_stop()                                               # stop it

=head1 EXPORT

The following functions are exported by default.

=head2 pulse_start()

=head2 pulse_stop()

=head1 FUNCTIONS

=head2 pulse_start()

Use this functions to start the pulse. Accept the following arguments:

    Argument            Default
    ----------------------------
    name                'Working'
    rotate              0
    size                16
    time                0

=cut

my $pid;
my $global_name;
my $global_start_time;
my @mark = qw(- \ | / - \ | /);
$| = 1;

sub pulse_start {
    my %args = @_;
    my $name = defined $args{name}   ? $args{name}   : 'Working';
    my $type = defined $args{rotate} ? $args{rotate} : 0;
    my $size = defined $args{size}   ? $args{size}   : 16;
    my $time = defined $args{time}   ? $args{time}   : 0;
    my $start = time;
    $global_start_time = $start;

    $global_name = $name;

    $pid = fork and return;
    while (1) {
        foreach my $index (1..$size) {
            my $mark = $type ? $mark[$index % 8] : q{=};
            printf "$name...[%s%s%s]", q{ } x $index, $mark, q{ } x ($size - $index + 1);
            printf " (%f sec elapsed)\r", (time - $start) if $time;
            usleep 200000;
        }

        foreach my $index (1..$size) {
            my $mark = $type ? $mark[($index % 8) * -1] : q{=};
            printf "$name...[%s%s%s]", q{ } x ($size - $index + 1), $mark, q{ } x $index;
            printf " (%f sec elapsed)\r" , (time - $start ) if $time;
            usleep 200000;
        }
    }
}

=head2 pulse_stop()

Stop the pulse and return elapsed time

=cut

sub pulse_stop {
    kill 9 => $pid;
    my $length = length($global_name);
    printf "$global_name%sDone%s\n", q{.} x (35 - $length), q{ } x 43;
    my $elapsed_time = time - $global_start_time;
    return $elapsed_time;
}

=head1 KNOWN PROBLEMS

Not thread safe.

=head1 AUTHOR

Yen-Liang Chen, C<< <alec at cpan.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-tsmc-pulse at rt.cpan.org>, or through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=TSMC-Pulse>. I will be notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc TSMC::Pulse


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=TSMC-Pulse>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/TSMC-Pulse>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/TSMC-Pulse>

=item * Search CPAN

L<http://search.cpan.org/dist/TSMC-Pulse>

=back


=head1 COPYRIGHT & LICENSE

Copyright 2008 Alec Chen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of TSMC::Pulse