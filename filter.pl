use warnings;

my (@text,@nuc,@qv,@other1,@other2,);
my ($nuc,$qv,$o1,$o2,)=(0,0,0,0);
my $i=1;
$adapt=$ARGV[0];

open(FILE,$adapt)or die "$!";
@text=<FILE>;
=pod
while(<FILE>){
	chomp;
  $line=$_;
  if($i%4==0){
    $qv[$qv]=$line;
    $qv++;
  }elsif(($i+2)%4==0){
    $nuc[$nuc]=$line;
    $nuc++;
  }elsif(($i+1)%4==0){
    $other2[$o2]=$line;
    $o2++;
  }else{
    $other1[$o1]=$line;
    $o1++;
  }
  $i++;
}
=cut
close(FILE);


foreach(@text){
  if($i%4==0){
    $qv[$qv]=$text[$i-1];
    $qv++;
  }elsif(($i+2)%4==0){
    $nuc[$nuc]=$text[$i-1];
    $nuc++;
  }elsif(($i+1)%4==0){
    $other2[$o2]=$text[$i-1];
    $o2++;
  }else{
    $other1[$o1]=$text[$i-1];
    $o1++;
  }
  $i++;
}

my ($n1,$n2,$n3,$n4)=(scalar(@nuc),scalar(@qv),scalar(@other1),scalar(@other2));

($i,$nuc,$qv,$o1,$o2)=0;

for($i=0;$i<$n1;$i++){
#print("$i");
  #改行削除
# print $qv[$i];
chomp($qv[$i]);
chomp($nuc[$i]);

my @qvw=split('',$qv[$i]);
my @nucw=split('',$nuc[$i]);

#print "$qvw[-1]\n";

#ASCII
my @asc=();
#$asc[0]=0;
my $ascC=0;
foreach(@qvw){
  $asc[$ascC]=(ord($_)-33);
  $ascC++;
}
# scalar(@asc);

#削除
my $n=0;
my $num=0;
my @delN=();
$delN[0]="x";

foreach(@asc){
  last if($_ >= 10);
  if($_ < 10){
    $delN[$num]=$n;
    $num++;
  }
  $n++;
}

my $ascn=scalar(@asc);

#print "$i>$delN[-1]:$ascn\n";

if(not $delN[0] eq "x"){
if($delN[-1]==$ascn-1){
	splice(@asc,$delN[0],$delN[-1]+1,"\n");
	splice(@qvw,$delN[0],$delN[-1]+1,"\n");
	splice(@nucw,$delN[0],$delN[-1]+1,"\n");
	#print "$i:delete all/";
}else{
	splice(@asc,$delN[0],$delN[-1]+1);
	splice(@qvw,$delN[0],$delN[-1]+1);
	splice(@nucw,$delN[0],$delN[-1]+1);
	#print "$i:delete a part/";
}
}

#逆も削除

#print join(',',@asc);
#print "$i:$asc[0]\n";

if ($qvw[0] eq "\n"){
	$qv[$i]=join('',@qvw);
	$nuc[$i]=join('',@nucw);
	next;
}

my @Rasc=reverse(@asc);
my @Rqvw=reverse(@qvw);
my @Rnucw=reverse(@nucw);


#print "$i:$Rasc[0]:$Rqvw[0],";
$n=0;
$num=0;
@delN=();
$delN[0]="x";
foreach(@Rasc){
  if($_ >= 10){

    last;
  };
  if($_ < 10){
    $delN[$num]=$n;
    $num++;
  }
  $n++;
}
if(not $delN[0] eq "x"){
if($delN[-1]==$ascn-1){
	splice(@Rasc,$delN[0],$delN[-1]+1,"\n");
	splice(@Rqvw,$delN[0],$delN[-1]+1,"\n");
	splice(@Rnucw,$delN[0],$delN[-1]+1,"\n");
	#print "$i:R:delete a all/";
}else{	
	splice(@Rasc,$delN[0],$delN[-1]+1);
	splice(@Rqvw,$delN[0],$delN[-1]+1);
	splice(@Rnucw,$delN[0],$delN[-1]+1);
	#print "$i:R:delete a part/";
}
}
#結果を統合
@asc=reverse(@Rasc);
@qvw=reverse(@Rqvw);
@nucw=reverse(@Rnucw);

if($qvw[0] eq "\n"){
	$qv[$i]=join('',@qvw);
	$nuc[$i]=join('',@nucw);
	next;
}

##割り算以下をコメントアウトするときにコメントアウトしない（した）
=pod
push(@qvw,"\n");
push(@nucw,"\n");

$qv[$i]=join('',@qvw);
$nuc[$i]=join('',@nucw);
=cut
#-------------------------------------------------------------------------------------------------------------------------------
#割り算
my $sum=0;
foreach(@asc){
	$sum+=$_;
}

my $length=scalar(@qvw);
if(scalar(@qvw)==0){
	#print "$i is no qv\n";
	splice(@asc,0,$length,"\n");
	splice(@qvw,0,$length,"\n");
	splice(@nucw,0,$length,"\n");
	$qv[$i]=join('',@qvw);
	$nuc[$i]=join('',@nucw);
	next;
}else{
my $average=$sum/scalar(@qvw);

if($average<17){	
	splice(@asc,0,$length,"\n");
	splice(@qvw,0,$length,"\n");
	splice(@nucw,0,$length,"\n");
	$qv[$i]=join('',@qvw);
	$nuc[$i]=join('',@nucw);
	next;
}
}
#20bp以上
if($length<20){
	splice(@asc,0,$length,"\n");
	splice(@qvw,0,$length,"\n");
	splice(@nucw,0,$length,"\n");
	$qv[$i]=join('',@qvw);
	$nuc[$i]=join('',@nucw);
	next;
}

#低QV領域
my $lowqv=0;
foreach(@asc){
	if($_<10){
		$lowqv++;
	}
}
my $range=$lowqv/$length;
if($range>0.1){	
	splice(@asc,0,-$length,"\n");
	splice(@qvw,0,$length,"\n");
	splice(@nucw,0,$length,"\n");
	$qv[$i]=join('',@qvw);
	$nuc[$i]=join('',@nucw);
	next;
}

#N or . がはいっていないかどうか
my $Nn=0;
foreach(@nucw){
	if($_ eq "N" or $_ eq "."){
		splice(@asc,0,-$length,"\n");
		splice(@qvw,0,$length,"\n");
		splice(@nucw,0,$length,"\n");
		$qv[$i]=join('',@qvw);
		$nuc[$i]=join('',@nucw);
		$Nn=1;
		last;
	}
}
next if($Nn==1);
	
push(@qvw,"\n");
push(@nucw,"\n");
$qv[$i]=join('',@qvw);
$nuc[$i]=join('',@nucw);


}

#----------------------------削除おわり-----------------------------------------------------------------------------
my $count=0;
foreach(@nuc){
  $count+=length($_);
}
my $wxy=0;
my @deleteBox=();
for($i=0;$i<$n1;$i++){
	if($qv[$i] eq "\n"){
		$deleteBox[$wxy]=$i;
		$wxy++;
	}
}
#最後から消していけば配列に影響なし
@deleteBox=reverse(@deleteBox);
foreach(@deleteBox){
	splice(@other1,$_,1);
	splice(@other2,$_,1);
	splice(@qv,$_,1);
	splice(@nuc,$_,1);
}

#print "delete:@deleteBox\n";
my ($n1,$n2,$n3,$n4)=(scalar(@nuc),scalar(@qv),scalar(@other1),scalar(@other2));
#print "nuc:$n1,qv;$n2,o1:$n3,o2:$n4\n";

$i=0;
for($i=0;$i<$n1;$i++){
  print $other1[$i];
  print $nuc[$i];
  print $other2[$i];
  print $qv[$i];
}
#print "\n$count\n"
