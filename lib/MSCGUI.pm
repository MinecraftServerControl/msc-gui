=head1 NAME

  MSC GUI - Creates a Graphical User Interface for MSC.

=head1 SYNOPSIS

  Creates a Graphical User Interface for MSC.

=head1 DESCRIPTION

  This package creates a GUI object.

=head1 DEPENDENCIES

  This package depends on various packages in the MSC hierarchy.

=head1 FEEDBACK

=head2 Mailing Lists

  No mailing list currently exists.

=head2 Reporting Bugs

  Report bugs to the author directly.

=head1 AUTHOR - Jason Wood

  Email sandain@hotmail.com

=head1 COPYRIGHT AND LICENSE

  Copyright (c) 2016  Jason M. Wood <sandain@hotmail.com>

  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice,
     this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.

=head1 APPENDIX

  The rest of the documentation details each of the object methods.

=cut

package MSCGUI;

use strict;
use warnings;

use MSCGUI::Theme;

our $TITLE = 'Minecraft Server Control';
our $VERSION = '0.01';

my %menu = (
  'dashboard' => { function => \&_dashboard, order => 0 }
);

=head2 new

  Title    : new
  Usage    : 
  Function : 
  Returns  : New MSC GUI object
  Args     : theme
             uri

=cut

sub new {
  my $invocant = shift;
  my %params = @_;
  my $class = ref ($invocant) || $invocant;
  my $self = {
    params => undef,
    theme => undef,
    theme => '',
    uri => ''
  };
  bless $self => $class;
  # Get URI
  die "Error: URI undefined" unless (defined $params{uri});
  $self->{uri} = $params{uri};

  if (defined $params{theme}) {
    $self->{theme} = $params{theme};
  }
  else {
    $self->{theme} = 'themes/default';
  }
  # Load the worlds/
  _add_worlds ();
  # Load the Theme.
  $self->{theme} = new MSCGUI::Theme (
    uri => $self->{uri},
    theme => $self->{theme},
    menu => \%menu
  );
  return $self;
}

=head2 _mscs

  Title    : _mscs
  Usage    : 
  Function : 
  Returns  : 
  Args     : 

=cut

sub _mscs {
  return `mscs @_`;
}

=head2 _add_worlds

  Title    : _add_worlds
  Usage    : 
  Function : 
  Returns  : 
  Args     : 

=cut

sub _add_worlds {
  foreach my $line (_mscs ("ls")) {
    if ($line =~ /^\s*(\w+):/) {
      my $function = _display_world ($1);
      my $order = scalar keys %menu;
      $menu{$1}{function} = $function;
      $menu{$1}{order} = $order;
    }
  }
}

=head2 _dashboard

  Title    : _dashboard
  Usage    : 
  Function : 
  Returns  : 
  Args     : 

=cut

sub _dashboard {
  my $dashboard = "<p>Displaying Content: Dashboard</p>\n";
  $dashboard .= "<p>Version: " . $VERSION . "</p>\n";
  return $dashboard;
}

=head2 _display_world

  Title    : _display_world
  Usage    : 
  Function : 
  Returns  : 
  Args     : 

=cut

sub _display_world {
  my $world = shift;
  return sub {
    my $display = '<p>Displaying World: ' . $world . '</p>';
    $display .= "<pre>";
    $display .= join "", _mscs ("status", $world);
    $display .= "</pre>";
    return $display;
  };
}

1;
__END__
