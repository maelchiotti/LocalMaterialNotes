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
    <b>Material Notes</b> est une application de prise de notes textuelles, qui vise la simplicité. Elle adopte le style
    Material Design. Elle stocke les notes localement et n'a aucune permission internet, vous êtes donc le seul à
    pouvoir accéder aux notes.
</p>

<p>
    <b>Prenez des notes</b>
</p>
<ul>
    <li>Rédigez des notes textuelles (titre et contenu)</li>
    <li>Tirez parti des options de formatage avancées, y compris les checklists</li>
    <li>Annulez et rétablissez vos modifications pendant l'édition</li>
    <li>Utilisez l'action rapide de votre écran d'accueil pour ajouter rapidement une note.</li>
</ul>

<p>
    <b>Organisez</b>
</p>
<ul>
    <li>Recherchez dans vos notes</li>
    <li>Triez vos notes par date ou par titre, par ordre croissant ou décroissant</li>
    <li>Affichez vos notes sous forme de liste ou de grille</li>
    <li>Épinglez vos notes</li>
    <li>Récupérez vos notes supprimées de la corbeille</li>
</ul>

<p>
    <b>Partagez & sauvegardez</b>
</p>
<ul>
    <li>Partagez du texte à partir d'autres applications pour l'ajouter directement à une note</li>
    <li>Partagez vos notes sous forme de texte</li>
    <li>Exportez vos notes au format JSON et importez-les à nouveau</li>
    <li>Exportez vos notes au format Markdown</li>
</ul>

<p>
    <b>Protégez</b>
</p>
<ul>
    <li>Ne vous inquiétez pas de la façon dont vos données sont traitées : elles ne peuvent pas quitter votre appareil
        car l'application n'a pas d'autorisations Internet</li>
</ul>

<p>
    <b>Personnalisez</b>
</p>
<ul>
    <li>Choisissez votre langue</li>
    <li>Choisissez votre thème (clair, foncé ou noir)</li>
    <li>Choisissez si vous voulez que votre thème soit dynamique (utilise les couleurs de votre arrière-plan)</li>
    <li>Choisissez si vous voulez activer le formatage avancé, seulement les checklists ou garder vos notes basiques
    </li>
</ul>