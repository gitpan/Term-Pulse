use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Term::Pulse',
    license             => 'perl',
    dist_author         => 'Alec Chen <alec@cpan.org>',
    dist_version_from   => 'lib/Term/Pulse.pm',
    build_requires => {
        'Test::More'  => 0,
        'Time::HiRes' => 1.9715,
        'version'     => 0.76,
    },
    add_to_cleanup      => [ 'Term-Pulse-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
