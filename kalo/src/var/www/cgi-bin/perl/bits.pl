#!/usr/bin/perl
use strict; 
use warnings;
use constant BR => "\n";
use Config;

my %code_val;
$code_val{'BGN'} = 1;
$code_val{'CAD'} = 2;
$code_val{'CHF'} = 4;
$code_val{'DKK'} = 8;
$code_val{'USD'} = 16;
$code_val{'TRY'} = 32;
$code_val{'EUR'} = 64;
$code_val{'GBP'} = 128;
$code_val{'NOK'} = 256;
$code_val{'RUB'} = 512;

print "size(int) = ", $Config{intsize}, ' bytes/octets  =  ', $Config{intsize} * 8, ' bits', BR;

my $access = 0;
$access |= $code_val{'DKK'};
$access |= $code_val{'NOK'};
$access |= $code_val{'TRY'};

print where_from_access($access), BR;

my $cid = undef;
$cid = 'EUR';

print $cid, BR;
print $access & $code_val{$cid}, BR;

$cid = 'NOK';

print $cid, BR;
print $access & $code_val{$cid}, BR;


sub cidFilter($$) {

    my $oldcid = shift;
    if ($oldcid) {

        my $droit = shift;
        if ($droit & $code_val{$oldcid}) {
            return $oldcid;
        } else {

            my $newcid = $oldcid;
            foreach my $clef (keys %code_val) {

                if ($droit & $code_val{$clef}) {

                    $newcid = $clef;
                }
            }
            return $newcid;
        }
    } else {

        return $oldcid;
    }
}


sub open_cid($) {

    my $droit = shift;

    foreach my $clef (keys %code_val) {

        if ($droit & $code_val{$clef}) {
            return $clef;
        }
    }

    return 0;
}



sub where_from_access {

    my $droit = shift;
    my $where = 0;

    foreach my $clef (keys %code_val) {
        print $clef, ': ', $code_val{$clef}, BR;
        if ($droit & $code_val{$clef}) {
            if ($where) {
                $where = "$where OR BCODEVAL LIKE \"$clef\"";
            } else {
                $where = "WHERE BCODEVAL LIKE \"$clef\"";
            }    
        }
    }

    return $where;
}

sub setAccess($$) {
    my ($code, $bit) = @_;
    return $code | $bit; 
}

sub getAccess($$) {
    my ($code, $bit) = @_;
    return $code & $bit ? 1 : 0; 
}