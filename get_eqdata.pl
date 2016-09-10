#!/usr/bin/perl
use strict;
use utf8;
use LWP::Simple;
use Encode;
use DateTime;

if (@ARGV == 1){
    my $today = $ARGV[0];
    die if ($today !~ /[0-9]{8}/);
    retrieveData($today);
}else{
    for(my $i=1;$i<31; $i++){
	my $dt = DateTime->now;
	my $ddt= $dt->subtract( days=> $i );
	my $tdate = $ddt->strftime("%Y%m%d");
	retrieveData($tdate);
    }
}

sub retrieveData{
    my $tdate = shift;
    my $outfile = $tdate . ".txt";
    
    eval{
	if (! -f $outfile){
	    my $baseurl = "http://www.data.jma.go.jp/svd/eqev/data/daily_map/";
	    my $url = $baseurl . $tdate . ".html";
	    my $html = get($url) or die "$tdate : $!";
	    
	    my @lines = split /\n/, $html;
	    my $flg = 0;
	    my $cnt=0;
	    my $outline = "";

	    open my $fhOut, '>:encoding(utf-8)', $outfile or die $!;
	    
	    for (my $l=0;$l<=$#lines;$l++){
		my $line = $lines[$l];
		chomp($line);
		$flg = 0 if $line =~ /<\/pre>/;
		if ($flg == 1){
		    if ($cnt==0){
			$outline = "date\ttime\tlatitude\tlongitude\tdepth\tmagnitude\tepicenter\r\n";
		    }else{
			$outline .= formatLine($line);
		    }
		    $cnt++;
		}
		$flg = 1 if $line =~ /<pre>/;
	    }
	    print $fhOut $outline;
	    close $fhOut;
	    print " => $outfile\n";
	}
    };
    if($@){
	print STDERR "ERROR: $@\n";
    }
}
sub formatLine{
    my $line = shift;
    my $outline;
    if (($line !~ /^\-+$/) && length($line) != 0){
	my $yy = substr($line,0,4)+0;
	my $mm = trim(substr($line,5,2))+0;
	my $dd = trim(substr($line,8,2))+0;
	my $hm = substr($line, 11,5)."";
	my $ss = trim(substr($line, 17,2))+0;
	my $date = sprintf("%d-%02d-%02d\t%s:%02d", $yy, $mm, $dd, $hm, $ss);
	
	my $lat1 = trim(substr($line,22,3))+0.0;
	my $lat2 = substr($line,26,2)+0.0;
	my $lat3 = substr($line,29,1)+0.0;
	my $latitude = $lat1+$lat2/60+$lat3/60**2;
	
	my $lon1 = trim(substr($line,33,3))+0.0;
	my $lon2 = substr($line,37,2)+0.0;
	my $lon3 = substr($line,40,1)+0.0;
	my $longitude = $lon1+$lon2/60+$lon3/60**2;

	my $depth = trim(substr($line,44,4));
	my $magnitude = trim(substr($line, 49,7));
	my $epicenter = substr($line, 58);
	
	$outline = "$date\t$latitude\t$longitude\t$depth\t$magnitude\t$epicenter\r\n";
    }
    return $outline;
}

sub trim{
    my $str = shift;
    $str =~ s/\s+//g;
    return $str;
}
__END__
