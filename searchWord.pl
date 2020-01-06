#!/usr/bin/perl

##
# searchWordでは，引数に単語（複数も可）を与えることでその単語が含まれている文書を検索し，
# 検索した文書に含まれている他の単語を結果として表示する．
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
  -n : number of results, default n=10
EOF
    exit 0
}
my $db = $opt_d ? $opt_d : "data";
my $q  = $opt_q ? $opt_q : "z";
my $n  = $opt_n ? $opt_n : 10;
my $m  = $opt_m ? $opt_m : 10;

&Tool::init($db);

my ($doc,$word) = &Tool::getdocword($q);

# 検索結果のソート（降順） & grepで単語以外の要素を除く
my @ws = sort {$b->{DF_d} <=> $a->{DF_d}} grep {($_->{name} !~ /:/) && ($_->{name} ne "z")} @$word;

printf("検索ワード: %s\n", $q);
printf "ヒットした文書数: %d\n", scalar @$doc;

printf("\n");

# 結果のヘッダー
printf("no\tDf_d\tweight\t\tname\n");

for(my $i = 0; ($i < @ws) && ($i < $n); $i++) {
    $name = encode('utf8', decode('ISO-2022-JP', $ws[$i]->{name}));
    printf "%2d\t%3d\t%7.4f\t\t%s\n", $i+1, $ws[$i]->{DF_d}, $ws[$i]->{weight}, $name;
}

