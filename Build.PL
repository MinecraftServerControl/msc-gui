#! /usr/bin/perl

use Module::Build;

my $build = new Module::Build (
  module_name   => 'MSCGUI',
  license       => 'bsd',
  dist_abstract => 'Minecraft Server Control Script',
  requires      => {
    'perl'      => '5.6.1',
    'CGI'       => '4.20',
    'CGI::Ajax' => '0.700'
  }
);
$build->create_build_script;
