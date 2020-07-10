$data=$ARGV[0];
open(IN,$data)or die "$!";
while(<IN>){
	chomp;
 $line=$_;
	if($line =~ m/\s/){
		$line =~ s/\s+/|/g;
		print "|$line|\n";
	}else{
	print "$line\n";
}
}
close(IN);
