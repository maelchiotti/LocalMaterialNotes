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
    <b>Material Notes</b> basitliği hedefleyen metin tabanlı bir not alma uygulamasıdır. Materyal Tasarımı benimser.
    Notları yerel olarak saklar ve internet izni yoktur, böylece notlara erişebilen tek kişi sizsiniz.
</p>

<p>
    <b>Not alın</b>
</p>
<ul>
    <li>Metin notları yazın (başlık ve içerik)</li>
    <li>Kontrol listeleri de dahil olmak üzere gelişmiş biçimlendirme seçeneklerinden yararlanın</li>
    <li>Düzenleme sırasında değişikliklerinizi geri alma ve yineleme</li>
    <li>Hızlı bir şekilde not eklemek için ana ekranınızdaki hızlı eylemi kullanın</li>
</ul>

<p>
    <b>Organize Et</b>
</p>
<ul>
    <li>Notlarınızda arama yapın</li>
    <li>Notlarınızı tarihe veya başlığa göre, artan veya azalan sırada sıralayın</li>
    <li>Notlarınızı bir liste veya ızgara görünümünde görüntüleyin</li>
    <li>Notlarınızı sabitleyin</li>
    <li>Silinen notlarınızı çöp kutusundan kurtarın</li>
</ul>

<p>
    <b>Paylaş ve yedekle</b>
</p>
<ul>
    <li>Doğrudan bir nota eklemek için diğer uygulamalardan metin paylaşın</li>
    <li>Notlarınızı metin olarak paylaşın</li>
    <li>Notlarınızı JSON olarak dışa aktarın ve geri alın</li>
    <li>Notlarınızı Markdown olarak dışa aktarın</li>
</ul>

<p>
    <b>Koruyun</b>
</p>
<ul>
    <li>Verilerinizin nasıl işlendiği konusunda asla endişelenmeyin: uygulama herhangi bir internet iznine sahip
        olmadığı için cihazınızdan ayrılamaz</li>
</ul>

<p>
    <b>Özelleştirme</b>
</p>
<ul>
    <li>Dilinizi seçin</li>
    <li>Temanızı seçin (açık, koyu veya siyah)</li>
    <li>Temanızın dinamik olmasını isteyip istemediğinizi seçin (arka planınızdaki renkleri kullanın)</li>
    <li>Gelişmiş biçimlendirmeyi, yalnızca kontrol listelerini etkinleştirmek veya notlarınızı basit tutmak isteyip
        istemediğinizi seçin</li>
</ul>