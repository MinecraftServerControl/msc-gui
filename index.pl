#! /usr/bin/perl

=head1 NAME

  MSC GUI.

=head1 SYNOPSIS

  Creates a web-based GUI for MSC.

=head1 DESCRIPTION

  This program creates a web-based Graphical User Interface (GUI) for
  Minecraft Server Control (MSC).

=head1 DEPENDENCIES

  This program depends on CGI and CGI::Ajax.

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

use strict;
use warnings;

use CGI qw/:standard/;
use CGI::Ajax;

my $URI = '';
my $THEME = 'themes/default';

my $TITLE = 'Minecraft Server Control';

my $CONTENT_TYPE = 'application/xhtml+xml';
my $COMPATIBLE_CONTENT_TYPE = 'text/html';

my $CGI = new CGI;
my $AJAX = new CGI::Ajax (display_content => \&display_content);

# Refresh the content every thirty seconds.
my $REFRESH_TIMER = 30 * 1000;

# Create the menu.
my %menu = (
  'dashboard' => { function => \&create_dashboard_content, order => 0 }
);

# Figure out the best content-type to use. Use a backward-compatible
# content-type for certain user-agents.
my $content_type = $CONTENT_TYPE;
$content_type = $COMPATIBLE_CONTENT_TYPE if (
  defined $CGI->user_agent &&
  ($CGI->user_agent =~ /MSIE/ || $CGI->user_agent =~ /Lynx/)
);

# Add the worlds to the menu.
foreach my $line (mscs ("ls")) {
  if ($line =~ /^\s*(\w+):/) {
    my $function = create_world_content ($1);
    my $order = scalar keys %menu;
    $menu{$1}{function} = $function;
    $menu{$1}{order} = $order;
  }
}

# Generate the tags.
my %tags = (
  'title'             => $TITLE,
  'uri'               => $URI,
  'theme'             => $THEME . "/",
  'favicon'           => $URI . $THEME . '/favicon.ico',
  'title_image'       => $URI . $THEME . "/title-image.png"
);

# Load the stylesheet.
my $style = load_theme ($THEME . '/stylesheet.css');

# Add some preformated XHTML to the tags.
$tags{'xhtml_favicon'} = "<link rel='icon' href='" . $tags{'favicon'} .
  "' type='image'/>";
$tags{'xhtml_title_image'} = "<img id='title_image' src='" .
  $tags{'title_image'} . "' alt='Title Image'/>";
$tags{'xhtml_title'} = "<div id='title_box'>" . $tags{'xhtml_title_image'} .
  "</div><div id='title'>$TITLE</div>";
$tags{'xhtml_menu'} = create_menu_content ();
$tags{'xhtml_content'} = create_main_content ();
$tags{'xhtml_style'} = "<style type='text/css'>$style</style>";
$tags{'xhtml_script'} = "<script type='text/javascript'>\n//<![CDATA[\n" .
  "var mscInterval;" .
  "function display_menu(item) { " .
    "clearInterval(mscInterval);" .
    "display_content ([item], [\"content_box\"]);" .
    "mscInterval=setInterval (function () { " .
      "display_content ([item], [\"content_box\"]);" .
    " }, " . $REFRESH_TIMER . ");" .
  " }" .
  "\n//]]>\n</script>";

# Load the header.
my $header = load_theme ($THEME . '/header.xhtml');
# Load the body.
my $body = load_theme ($THEME . '/body.xhtml');
# Load the footer.
my $footer = load_theme ($THEME . '/footer.xhtml');

# Output the XHTML.
print $AJAX->build_html (
  $CGI, $header . $body . $footer, { -type => $content_type }
);


=head2 create_dashboard_content

  Title    : create_dashboard_content
  Usage    :
  Function : Creates the dashboard content.
  Returns  : The content for the dashboard.
  Args     :

=cut

sub create_dashboard_content {
  my $dashboard = "<p>Displaying Content: Dashboard</p>\n";
  return $dashboard;
}

=head2 create_main_content

  Title    : create_main_content
  Usage    :
  Function :
  Returns  : XHTML to display the content.
  Args     :

=cut

sub create_main_content {
  my $content = "<div id='content_box'>";
  # Check if content needs to be displayed.
  my %vars = $CGI->Vars;
  if (defined $vars{display_content}) {
    $content .= &{$menu{$vars{display_content}}{function}};
  }
  else {
    # Otherwise default to the dashboard.
    my @keys = sort {$menu{$a}{order} <=> $menu{$b}{order}} keys %menu;
    $content .= &{$menu{'dashboard'}{function}};
  }
  $content .= "</div>";
  return $content;
}

=head2 create_menu_content

  Title    : create_menu_content
  Usage    :
  Function :
  Returns  : XHTML to display the menu.
  Args     :

=cut

sub create_menu_content {
  my $menu = "<div id='menu_box'>\n";
  foreach my $item (sort {$menu{$a}{order} <=> $menu{$b}{order}} keys %menu) {
    $menu .= "<a id='msc_menu_" . $item . "' class='menu_item' " .
      "href='" . $URI . "index.pl?display_content=" . $item . "' " .
      "onclick='display_menu(\"msc_menu_" . $item . "\"); return false;'" .
      ">" . $item . "</a>\n";
  }
  $menu .= "</div>\n";
  return $menu;
}

=head2 create_world_content

  Title    : create_world_content
  Usage    :
  Function : Creates the world content for a world of interest.
  Returns  : The content for the world of interest.
  Args     : world - The world of interest.

=cut

sub create_world_content {
  my $world = shift;
  return sub {
    my $display = '<p>Displaying World: ' . $world . '</p>';
    $display .= "<pre>";
    $display .= join "", mscs ("status", $world);
    $display .= "</pre>";
    return $display;
  };
}

=head2 display_content

  Title    : display_content
  Usage    :
  Function : Returns the content to be displayed.
  Returns  : The content of interest.
  Args     : item - The menu item for the content of interest.

=cut

sub display_content {
  my ($item) = @_;
  return &{$menu{$item}{function}};
}

=head2 load_theme

  Title    : load_theme
  Usage    :
  Function : Loads and renders the given theme file.
  Returns  : The rendered theme file.
  Args     : file - The theme file to load.

=cut

sub load_theme {
  my ($file) = @_;
  my $theme = '';
  open (THEME, $file) or
    die "Can't open theme " . $file . ": $!";
  while (my $line = <THEME>) {
    while ($line =~ /<\?msc_(\w*)\?>/) {
      my $t = '';
      if (defined $tags{$1}) {
        $t = $tags{$1};
      }
      $line =~ s/(<\?msc_$1\?>)/$t/;
    }
    $theme .= $line;
  }
  close (THEME);
  return $theme;
}

=head2 mscs

  Title    : mscs
  Usage    :
  Function : Run the mscs command with the provided arguments.
  Returns  :
  Args     : args - The command line arguments for mscs.

=cut

sub mscs {
  return `mscs @_`;
}
