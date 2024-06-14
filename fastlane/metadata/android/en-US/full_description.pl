#!/usr/bin/perl --
use strict;
use warnings;
use utf8;
use feature qw(say);

# read from __DATA__ section in this file.
local $/ = undef;
my $text = <DATA>;

############################################
# change spaces and line feeds to single space,
# it's required for F-droid android client.
# also remove head/tail spaces in whole text.

$text =~ s/[\x00-\x20]+/ /g;
$text =~ s/\A //;
$text =~ s/ \z//;

############################################
# trim spaces before/after open/close block tags. also <br>,<br/>,</br>

# HTML block elements and "br". joined with '|'
my $blockElements = join "|", qw(
    address article aside blockquote canvas dd div dl dt 
    fieldset figcaption figure footer form 
    h1 h2 h3 h4 h5 h6 header hr li 
    main nav noscript ol p pre section table tfoot ul video 
    br
);

# RegEx for block tag that may have attributes, and spaces before/after tag.
my $trimElementRe = qr!\s*(</?(?:$blockElements)\b(?:[^>/"]+|"[^"]*")*/?>)\s*!i;

## verbose debugging.
#say $trimElementsRe;
#while( $text =~ /$trimElementRe/g){
#    next if $& eq $1;
#    say "[$&] => [$1]";
#}

$text =~ s/$trimElementRe/$1/g;

############################################

# write to .txt file. $0 means path of the this script file.
my $file = $0;
$file =~ s/\.pl$/\.txt/ or die "can't make output filename. $0";
open(my $fh,">:utf8",$file) or die "$file $!";
say $fh $text;
close($fh) or die "$file $!";

# apt-cyg install tidy libtidy5
system qq(tidy -q -e $file);

__DATA__

<p>
    <b>Material Notes</b> is a text-based note-taking application, aimed at simplicity. It embraces Material Design. It
    stores the notes locally and doesn't have any internet permissions, so you are the only one that can access the
    notes.
</p>


<p>
    <b>Take notes</b>
</p>
<ul>
    <li>Write text notes (title and content)</li>
    <li>Take advantage of the advanced formatting options, including checklists</li>
    <li>Undo and redo your changes while editing</li>
    <li>Use the quick action from your home screen to quickly add a note</li>
</ul>

<p>
    <b>Organize</b>
</p>
<ul>
    <li>Search though your notes</li>
    <li>Sort your notes by date or title, in ascending or descending order</li>
    <li>Display your notes in a list or a grid view</li>
    <li>Pin your notes</li>
    <li>Recover your deleted notes from the bin</li>
</ul>

<p>
    <b>Share & backup</b>
</p>
<ul>
    <li>Share text from other applications to add it directly to a note</li>
    <li>Share your notes as text</li>
    <li>Export your notes as JSON and import them back</li>
    <li>Export your notes as Markdown</li>
</ul>

<p>
    <b>Protect</b>
</p>
<ul>
    <li>Never worry about how your data is handled: it cannot leave your device as the application doesn't have any
        internet permissions</li>
</ul>

<p>
    <b>Customize</b>
</p>
<ul>
    <li>Choose your language</li>
    <li>Choose your theme (light, dark or black)</li>
    <li>Choose if you want your theme to be dynamic (use colors from your background)</li>
    <li>Choose if you want to enable the advanced formatting, only the checklists or keep your notes basic</li>
</ul>