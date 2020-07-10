$file=$ARGV[0];

open(IN,$file)or die "$!";
while(<IN>){
	$line=$_;
	if($line =~ /\*\*(.*)/){
		$head=$1;
		#print "head!:$line\n";
	}
	elsif($line =~ /> \((\d*)-(\d*)-(\d*)/){
		$date=$1.$2.$3."_";
		warn "$date\n";
		#print "date!\n";
		print "**$date$head\n";
		print "$line";
	}
	else{
		print "$line";
	}
}
close(IN);
