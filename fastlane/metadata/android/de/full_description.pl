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
    <b>Material Notes</b> ist eine Anwendung zur Erstellung von Textnotizen, die auf Einfachheit ausgerichtet ist. Sie
    verwendet das Material Design. Sie speichert die Notizen lokal und hat keine Internetberechtigung, sodass nur Sie
    auf die Notizen zugreifen können.
</p>


<p>
    <b>Notizen machen</b>
</p>
<ul>
    <li>Verfassen von Textnotizen (Titel und Inhalt)</li>
    <li>Nutzen Sie die erweiterten Formatierungsoptionen, einschließlich Checklisten</li>
    <li>Rückgängig machen und Wiederherstellen von Änderungen während der Bearbeitung</li>
    <li>Verwenden Sie die Schnellaktion auf Ihrem Startbildschirm, um schnell eine Notiz hinzuzufügen</li>
</ul>

<p>
    <b>Organisieren Sie</b>
</p>
<ul>
    <li>Durchsuchen Sie Ihre Notizen</li>
    <li>Sortieren Sie Ihre Notizen nach Datum oder Titel, in aufsteigender oder absteigender Reihenfolge</li>
    <li>Anzeige Ihrer Notizen in einer Liste oder einem Raster</li>
    <li>Anheften von Notizen</li>
    <li>Wiederherstellen gelöschter Notizen aus dem Papierkorb</li>
</ul>

<p>
    <b>Freigeben & Sichern</b>
</p>
<ul>
    <li>Teilen Sie Text aus anderen Anwendungen, um ihn direkt in eine Notiz einzufügen</li>
    <li>Teilen Sie Ihre Notizen als Text</li>
    <li>Exportieren Sie Ihre Notizen als JSON und importieren Sie sie wieder</li>
    <li>Exportieren Sie Ihre Notizen als Markdown</li>
</ul>

<p>
    <b>Schützen Sie</b>
</p>
<ul>
    <li>Machen Sie sich keine Gedanken darüber, wie Ihre Daten gehandhabt werden: Sie können Ihr Gerät nicht verlassen,
        da die Anwendung keine Internetberechtigungen hat.</li>
</ul>

<p>
    <b>Anpassen von</b>
</p>
<ul>
    <li>Wählen Sie Ihre Sprache</li>
    <li>Wählen Sie Ihr Thema (hell, dunkel oder schwarz)</li>
    <li>Legen Sie fest, ob Ihr Thema dynamisch sein soll (verwenden Sie die Farben Ihres Hintergrunds)</li>
    <li>Wählen Sie, ob Sie die erweiterte Formatierung, nur die Checklisten oder nur die einfachen Notizen aktivieren
        möchten</li>
</ul>