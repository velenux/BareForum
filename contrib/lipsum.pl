#!/usr/bin/env perl

use strict;
use warnings;
use Carp;

my @WORDS = ();
my $TEMPLATE;
my $N;

unless(@ARGV > 0 and -r $ARGV[0]) {
	croak "Use $0 <template> [repetitions]";
}

$N = $ARGV[1] || 1;

open(LIPSUM, 'lipsum.dict') or croak "Can't open lipsum.dict, $!";

# load dict
my @tmpw;
my $c;
while(<LIPSUM>) {
	chomp($_);
	@tmpw = split(/\s+/, $_);
	foreach my $tw (@tmpw) {
		# add the word 20 times if it doesn't end in . or ,
		if($tw =~ /\w$/) {
			$c = 20;
			while($c > 0) { $c--; push @WORDS, $tw; }
		} else {
			push @WORDS, $tw;
		}
	}
}
close LIPSUM;

# load template
open(TEMPLATE, $ARGV[0]) or croak "Can't open template $ARGV[0], $!";
while(<TEMPLATE>) {
	chomp;
	$TEMPLATE .= $_;
}
close(TEMPLATE);

# main cycle
my $str;
while($N > 0) {
	$N--;
	$str = $TEMPLATE;
	$str =~ s/##LIPSUM(\d+)##/&lipsum($1)/eg;
	$str =~ s/##RANDN##/int(rand(3133731337))/eg;
	if(rand() > 0.8) { $str =~ s/##RANDB#(.*)##/$1/eg; } 
	else { $str =~ s/##RANDB#(.*)##//g; }
	print "$str\n";
}

sub lipsum {
	my $n = shift;
	my $ret = '';
	while(length $ret < $n) {
		$ret .= $WORDS[int(rand(@WORDS))] . ' ';
	}
  $ret =~ s/\s+$//;
	return ucfirst $ret;
}

