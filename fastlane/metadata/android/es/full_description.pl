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
    <b>Material Notes</b> es una aplicación de toma de notas basadas en texto, orientada a la simplicidad, diseñada
    adoptando Material Design. Material Notes almacena las notas localmente y no requiere ningún permiso de internet, siendo
    tú el único que puede acceder a las notas.
</p>

<p>
    <b>Tomar notas</b>
</p>
<ul>
    <li>Escriba notas de texto (título y contenido)</li>
    <li>Aproveche las opciones avanzadas de formato, incluidas las listas de comprobación</li>
    <li>Deshacer y rehacer los cambios durante la edición</li>
    <li>Utiliza la acción rápida de la pantalla de inicio para añadir rápidamente una nota</li>
</ul>

<p>
    <b>Organiza</b>
</p>
<ul>
    <li>Busca en tus notas</li>
    <li>Ordena tus notas por fecha o título, en orden ascendente o descendente</li>
    <li>Visualiza tus notas en una lista o en una cuadrícula</li>
    <li>Anclar tus notas</li>
    <li>Recupera tus notas borradas de la papelera</li>
</ul>

<p>
    <b>Compartir y hacer copias de seguridad</b>
</p>
<ul>
    <li>Comparte texto desde otras aplicaciones para añadirlo directamente a una nota</li>
    <li>Comparte tus notas como texto</li>
    <li>Exporta tus notas como JSON e impórtalas de nuevo</li>
    <li>Exporta tus notas como Markdown</li>
</ul>

<p>
    <b>Protege</b>
</p>
<ul>
    <li>No te preocupes por el tratamiento de tus datos: no pueden salir de tu dispositivo, ya que la aplicación no
        tiene permisos de Internet</li>
</ul>

<p>
    <b>Personaliza</b>
</p>
<ul>
    <li>Elige tu idioma</li>
    <li>Elige tu tema (claro, oscuro o negro)</li>
    <li>Elige si quieres que tu tema sea dinámico (usa los colores de tu fondo)</li>
    <li>Elige si quieres activar el formato avanzado, sólo las listas de control o mantener tus notas básicas</li>
</ul>