#!/usr/bin/perl

##
# search.pl
# 検索単語（複数可）を与えると，単語が含まれた文書を検索し，weightの大きい順に文書を表示する．
# また，その文書に含まれている他の単語も表示する．
##

BEGIN{
    push @INC,'./';
}
use Getopt::Std;
use Tool;
use Encode qw/encode decode/;

getopts("hd:q:n:m:");

if ($opt_h){
    print <<EOF;
usage: perl search.pl [-h] [-d db] [-q query] [-n n]
  -h : show this message
  -d : database
  -q : query
  -n : number of results, default n=5
  -m : number of results, default m=5
EOF
    exit 0
}

my $db = $opt_d ? $opt_d : "data";
my $q  = $opt_q ? $opt_q : "z";
my $n  = $opt_n ? $opt_n : 5;
my $m  = $opt_m ? $opt_m : 5;

&Tool::init($db);

my ($doc,$word) = &Tool::getdocword($q);

printf("検索ワード: %s\n", $q);
printf("ヒットした文書数: %d\n", scalar @$doc);
printf("文書に含まれた単語数: %d\n", scalar @$word);

for(my $i = 0; ($i < $n) && ($i < @$doc); $i++) {

    my ($doci, $wordi) = &Tool::getdocword("i:$doc->[$i]{name}");
    
    printf("%2d ID: %s\n", $i+1, $doc->[$i]{name});
    
    for (my $j = 0; ($j < @$wordi) && ($j < $m); $j++) {
	$name = encode('utf8', decode('ISO-2022-JP', $wordi->[$j]{name}));
	printf("  %2d %7.4f %s\n", $j+1, $wordi->[$j]{weight}, $name);
    }
    print "\n";
}

