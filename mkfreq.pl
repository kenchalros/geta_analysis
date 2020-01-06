use lib "../../mecab-perl-0.996/src/.libs";
use lib $ENV{PWD} . "/blib/lib";
use lib $ENV{PWD} . "/blib/arch";
use MeCab;

my $model = new MeCab::Model(join " ", @ARGV);
my $c = $model->createTagger();

my $file = "20190403.txt";
my $ln = 1;
my %tf;

open(FF, $file) or die "$file not found";
while(my $line = <FF>){
    chomp $line;
    for (my $m = $c->parseToNode($line); $m; $m = $m->{next}) {
        if ($m->{feature} =~ /名詞/){
            $tf{$m->{surface}}++;
        }
    }
    printf "@%d\n", $ln;
    printf "1 z\n";
    printf "1 i:%d\n", $ln;
    map{ printf "%d %s\n", $tf{$_}, $_ }keys %tf;
    $ln++;
    %tf = ();
}
close(FF);
