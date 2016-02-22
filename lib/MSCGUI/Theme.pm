=head1 NAME

  Theme - Theme specific methods used in the MSC GUI.

=head1 SYNOPSIS

  Private usage by the MSC GUI.

=head1 DESCRIPTION

  This package holds Theme specific methods used by the MSC GUI.

=head1 DEPENDENCIES

  This package depends on CGI, and CGI::Ajax.

=head1 FEEDBACK

=head2 Mailing Lists

  No mailing list currently exists.

=head2 Reporting Bugs

  Report bugs to the author directly.

=head1 AUTHOR - Jason M. Wood

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

package MSCGUI::Theme;

use strict;
use warnings;

use CGI qw/:standard/;
use CGI::Ajax;

our $CONTENT_TYPE = 'application/xhtml+xml';
our $COMPATIBLE_CONTENT_TYPE = 'text/html';

my %menu;

=head2 new

  Title    : new
  Usage    : 
  Function : 
  Returns  : New Theme object
  Args     : theme
             uri

=cut

sub new {
  my $invocant = shift;
  my %params = @_;
  my $class = ref ($invocant) || $invocant;
  my $self = {
    cgi => undef,
    ajax => undef,
    params => undef,
    theme => '',
    uri => '',
    style => '',
    menu => '',
    fonts => '',
    tags => '',
    header => '',
    body => '',
    footer => ''
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
  # Load the menu from the parameters.
  %menu = %{$params{menu}};
  # Create CGI and CGI::Ajax objects
  $self->{cgi} = new CGI;
  $self->{ajax} = new CGI::Ajax (
    display_content => \&display_content,
    modify_content  => \&modify_content
  );
  # Grab CGI parameters
  $self->{params} = $self->{cgi}->Vars;
  # Installed fonts
  $self->{fonts} = {
    'Bitstream Vera' => '/usr/share/fonts/bitstream-vera/Vera.ttf',
    'Bitstream Vera Bold' => '/usr/share/fonts/bitstream-vera/VeraBd.ttf'
  };
  # Load stylesheet
  $self->{style} = $self->load_theme (
    file => $self->{theme} . '/stylesheet.css'
  );
  # Generate menu
  $self->{menu} = $self->create_menu ();
  # Generate tags
  $self->_generate_tags ();
  # Load header.
  $self->{header} = $self->load_theme (
    file => $self->{theme} . '/header.xhtml'
  );
  # Load body.
  $self->{body} = $self->load_theme (
    file => $self->{theme} . '/body.xhtml'
  );
  # Load footer.
  $self->{footer} = $self->load_theme (
    file => $self->{theme} . '/footer.xhtml'
  );
  $self->print_theme ();
  return $self;
}

=head2 display_content

  Title    : display_content
  Usage    : 
  Function : 
  Returns  : 
  Args     : 

=cut

sub display_content {
  my ($input) = @_;
  return &{$menu{$input}{function}};
}

=head2 create_title_box

  Title    : create_title_box
  Usage    :
  Function : 
  Returns  : XHTML to display the title.
  Args     : title {Title to display}

=cut

sub create_title_box {
  my $self = shift;
  my %params = @_;
  my $title = "<div id='title_box'><img id='title_image' " . 
    "src='" . $self->{theme} . "/title-image.png' alt='Title Image'/></div>";
  if (defined $params{title}) {
    $title .= "<div id='title'>$params{title}</div>";
  }
  return $title;
}

=head2 create_menu

  Title    : create_menu
  Usage    :
  Function :
  Returns  : XHTML to display the menu.
  Args     : list { Hash of Menu Items }

=cut

sub create_menu {
  my $self = shift;
  my %params = @_;
  my $menu = "<div id='menu_box'>\n";
  foreach my $item (sort {$menu{$a}{order} <=> $menu{$b}{order}} keys %menu) {
    $menu .= "<a id='msc_menu_" . $item . "' class='menu_item' " .
      "href='" . $self->{uri} . "index.pl?display_content=" . $item . "' " .
      "onclick='display_content(" .
        "[\"msc_menu_" . $item . "\"], [\"content_box\"]" .
      "); return false'>" . $item . "</a>\n";
  }
  $menu .= "</div>\n";
  return $menu;
}

=head2 create_content_box

  Title    : create_content_box
  Usage    : 
  Function : 
  Returns  : XHTML to display the content.
  Args     : 

=cut

sub create_content_box {
  my $self = shift;
  my %params = @_;
  my $content = '';
  $content .= "<div id='content_box'>";
  # Check if content needs to be displayed.
  if (defined $self->{params}{display_content}) {
    $content .= &{$menu{$self->{params}{display_content}}{function}};
  }
  else {
    # Otherwise default to the first item on the menu.
    my @keys = sort {$menu{$a}{order} <=> $menu{$b}{order}} keys %menu;
    $content .= &{$menu{$keys[0]}{function}};
  }
  $content .= "</div>";
  return $content;
}

=head2 load_theme

  Title    : load_theme
  Usage    : 
  Function : Loads and renders the given theme file.
  Returns  : The rendered theme file
  Args     : file {Theme file to load}

=cut

sub load_theme {
  my $self = shift; 
  my %params = @_;
  my $theme = '';
  open (THEME, $params{file}) or
    die "Can't open theme " . $params{file} . ": $!";
  while (my $line = <THEME>) {
    while ($line =~ /<\?msc_(\w*)\?>/) {
      my $t = '';
      if (defined $self->{tags}{$1}) {
        $t = $self->{tags}{$1};
      }
      $line =~ s/(<\?msc_$1\?>)/$t/; 
    }
    $theme .= $line;
  }
  close (THEME);
  return $theme;
}

=head2 print_theme

  Title    : print_theme
  Usage    : 
  Function : 
  Returns  : 
  Args     : 

=cut

sub print_theme {
  my $self = shift;
  my %params = @_;
  my $content_type;
  if (defined $self->{cgi}->user_agent && (
    $self->{cgi}->user_agent =~ /MSIE/ || $self->{cgi}->user_agent =~ /Lynx/
  )) {
    $content_type = $COMPATIBLE_CONTENT_TYPE;
  }
  else {
    $content_type = $CONTENT_TYPE;
  }
  print $self->{ajax}->build_html (
    $self->{cgi},
    $self->{header} . $self->{body} . $self->{footer},
    { -type => $content_type }
  );
}

=head2 modify_content

  Title    : modify_content
  Usage    : 
  Function : 
  Returns  : 
  Args     : 

=cut

sub modify_content {
  my @input = @_;
  my $output = '';
  foreach my $input (@input) {
    $output .= "Modify Content: $input<br/>\n";
  }
  return $output;
}

=head2 _generate_tags

  Title    : _generate_tags
  Usage    : private
  Function : 
  Returns  : 
  Args     : 

=cut

sub _generate_tags {
  my $self = shift;
  # Setup Tags.
  $self->{tags} = {
    'title'             => $MSCGUI::TITLE,
    'version'           => $MSCGUI::VERSION,
    'uri'               => $self->{uri},
    'theme'             => $self->{theme} . "/",
    'favicon'           => $self->{uri} . $self->{theme} . '/favicon.ico',
    'xhtml_favicon'     => "<link rel='icon' href='" . $self->{theme} .
                           "/favicon.ico' type='image'/>",
    'title_image'       => $self->{theme} . "/title-image.png",
    'xhtml_title_image' => "<img id='title_image' src='" . $self->{theme} .
                           "/title-image.png' alt='Title Image'/>",
    'xhtml_title'       => $self->create_title_box (title => $MSCGUI::TITLE),
    'xhtml_menu'        => $self->{menu},
    'xhtml_content'     => $self->create_content_box (),
    'xhtml_style'       => "<style type='text/css'>" . $self->{style} .
                           "</style>"
  };
}

1;
__END__
