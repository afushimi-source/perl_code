my $file1=$ARGV[0];#fastqファイル
my $file2=$ARGV[1];

$text1=":(.*?:.*?:.*?:.*?) l";
$text2="SRR[\d*]\.(.*?) HWI";
$o1=0;
$i=0;
open(FILE,$file2)or die "$!";
while(<FILE>){
	if(($i+1)%4==1){
		$line=$_;
		$other1b[$o1]=$line;
  	$o1++;
	}
	$i++;
}
close(FILE);

$end=$o1;
for ($i=0;$i<$end;$i++){
	$line=$other1b[$i];
	$line=~/$text1/;
	$tmp=$1;
	#print "$tmp\n";
	$pair2{$tmp}=$i;
}
@other1b=();
$i=0;
open(IN,$file1)or die"$!";
while(<IN>){
	chomp;
	$line=$_;
	if(($i+1)%4==1){
		$l1=$line;
		$line=~/$text1/;
		$pair1=$1;
		#print "$pair1\n";
	}
	elsif(($i+1)%4==2){
		$l2=$line;
	}
	elsif(($i+1)%4==3){
		$l3=$line;
	}
	elsif(($i+1)%4==0){
		$l4=$line;
		if(exists($pair2{$pair1})){
			print "$l1\n$l2\n$l3\n$l4\n";
		} else {
			warn "$i is delete!!\n";
		}
	}
	$i++;
}
close(IN);
