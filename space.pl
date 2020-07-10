$file=$ARGV[0];
open(IN,$file)or die "$!";
@text=<IN>;
close(IN);

$i=0;
foreach(@text){
	$line=$_;
	print "  ".$line;
}

