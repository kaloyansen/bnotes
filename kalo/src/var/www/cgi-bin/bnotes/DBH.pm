package DBH;
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# DBH: BSE banknotes system database access                                             #
# Author: Hristo Grigorov <hgrigorov@gmail.com>                                         #
# Copyright (c) 2011-2012 Busoft Engineering. All right reserved.                       #
# ------------------------------------------------------------------------------------- #
# Credentials are loaded from DATABASE_CREDIT_FILE                                      #
# User access control is bit packed in the database under CURRENCY.USERS.ADMIN          #
# Author: Kaloyan Krastev <kaloyansen@gmail.com>                                        #
# Copyright (c) 2022-2023 Busoft Engineering. All right reserved.                       #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# use strict; 
# use warnings;
# use warnings FATAL => q @all@;

use POSIX qw(strftime);
use DBI;
# use Data::Dumper;

use constant SESSION_EXPIRATION => q @+30m@;
use constant SUPERSESSION_EXPIRATION => q @+10m@;
use constant DATABASE_CREDIT_FILE => q @/var/www/.db@;

our $DBH = undef; 
our %user_access_mask_definition = (); # for user access control bit mask see the __DATA__ section

sub default_access { return  DBH::control('BGN') | DBH::control('USD'); }
sub paraname { return 'motor'; }
sub control_fake { return DBH::control_country(); }
sub control_country { 

    return 1 if DBH::db_toggle_status(DBH::paraname());
    return 0;
}

sub control { # access mask definition

    my $code = shift // 'all';
    return $code eq 'all' ? %user_access_mask_definition : $user_access_mask_definition{$code};
}

sub db_connect {

    if (defined $::DBH) {
        print "DBH already defined!!!\n";
        return;
    }

    %user_access_mask_definition = DBH::load_access_definition(); # user access control mask
    my %credit = DBH::database_credit_from(DATABASE_CREDIT_FILE);

    my $DB_DRVR = $credit{DRVR};
    my $DB_HOST = $credit{HOST};
    my $DB_BASE = $credit{BASE};
    my $DB_USER = $credit{USER};
    my $DB_PASS = $credit{PASS};

    my $DB_SCHEMA = "DBI:$DB_DRVR:database=$DB_BASE;host=$DB_HOST";

    $DBH = DBI->connect($DB_SCHEMA, $DB_USER, $DB_PASS) ||
        die "Could not connect to database: $DBI::errstr";

    # this is needed to properly show cyrillic characters
    my $qhandle = $DBH->prepare("SET NAMES UTF8");
    $qhandle->execute();
}

sub db_disconnect {

    my $DBH = shift;

    if (defined $DBH) {
        $DBH->disconnect();
        undef $DBH;
    }
}

sub db_select($) {

    my $query = shift;
    my $result = $DBH->selectall_arrayref($query, { Slice => {} });

    return $result;    
}

sub db_select_array($) {

    my $query = shift;
    my $result = $DBH->selectrow_array($query);

    return $result;
}

sub db_select_row($) {

    my $query = shift;
    #print STDERR "QUERY: $query\n";
    my $sth = $DBH->prepare($query);
    $sth->execute();

    my $result = $sth->fetchrow_hashref();
    return $result;
}

sub db_toggle_status {

    my $option = shift;
    return DBH::db_select_array("SELECT `VALUE` FROM `CONTROL` WHERE `OPTION`='$option'");
}

sub db_toggle {

    my $option = shift;
    my $newval = undef;

    my $sql = "CREATE TABLE IF NOT EXISTS `CONTROL` ( `OPTION` VARCHAR(15), `VALUE` int(11) DEFAULT 0 )";
    my $sth = $DBH->prepare($sql);
    $sth->execute();
    $sth->finish();
    
    my $column = DBH::db_select_array("SELECT COUNT(*) FROM `CONTROL` WHERE `OPTION`='$option'");
    if ($column == 1) {

        # my $result = DBH::db_select_array("SELECT `VALUE` FROM `CONTROL` WHERE `OPTION`='$option'");
        my $result = DBH::db_toggle_status($option);
        $newval = $result ? 0 : 1;
        $sql = "UPDATE CONTROL SET `VALUE` = '$newval' WHERE `OPTION`='$option'";
    } else {    

        $newval = 1;
        $sql = "INSERT INTO CONTROL(`OPTION`, `VALUE`) VALUES('$option', $newval)";
    }

    $sth = $DBH->prepare($sql);
    $sth->execute();
    $sth->finish();
    
    return $newval;
}


sub db_insert($$) {

    my ($user, $pass) = @_;
    my $sql = "INSERT INTO USERS(USER, PASSWORD) VALUES(?, MD5(?))";

    my $sth = $DBH->prepare($sql);
    my $result = $sth->execute($user, $pass);
    $sth->finish();

    return $result ? DBH::db_update_column('CREATED', DBH::maintenant(), $user) : $!; 
}

sub db_delete($) {

    my $sql = "DELETE FROM USERS WHERE USER LIKE ?";

    my $sth = $DBH->prepare($sql);
    my $result = $sth->execute(shift);
    $sth->finish();

    return $result ? $result : $!;
}

sub db_update_column($$$) {

    my ($column, $value, $user) = @_; 
    my $sql = "UPDATE USERS SET $column = ? WHERE USER LIKE ?";

    my $sth = $DBH->prepare($sql);
    my $result = $sth->execute($value, $user);
    $sth->finish();

    
    return $result ? $result : $!;
}

sub db_update($) {

    my $sth = $DBH->prepare(shift);
    my $result = $sth->execute();
    $sth->finish();

    return $result ? $result : $!;
}

sub database_credit_from($) {

    my %data;

    open(FH, '<', shift) or die $!;
    while(<FH>) {
        chomp;
        my @word = split / /, $_;
        $data{$word[0]} = $word[1];
    }

    close(FH);
 
    return %data;
}

sub maintenant {

    return strftime "%F %X", localtime;
}

sub auth_user($$) {

    my ($user, $password) = @_;

    my $from = "FROM USERS WHERE USER = \'$user\'";
    my $result = DBH::db_select_row("SELECT * $from");  
    my $fine = DBH::db_select_array("SELECT COUNT(*) $from AND PASSWORD = MD5(\'$password\')");

    if ($fine) {
        DBH::db_update_column('ACTIVE', 1, $user); 
        DBH::db_update_column('LOGGED', DBH::maintenant(), $user); 
        return $result->{ADMIN};
    }

    return -1;
}

sub auth_superuser($$) {

    my ($user, $password) = @_;
    #return DBH::auth_user($user, $password) == 1 ? 1 : 0;

    my $check = DBH::auth_user($user, $password);
    if ($check > 0) {    
        if ($check & DBH::control('ADM')) {
            return 1;
        }
    }

    return 0;
}    

sub load_access_definition { # read access bit definition

    my %definition = ();

    while (<DATA>) {

        my @word = split / /, $_;
        if ($#word > 0) { # && index($word[0], '#') < 0) {
            $definition{$word[0]} = 2 ** $word[1];
        }
    }

    return %definition;
}

1;



# user access bit mask definition
# format: name bit description

__DATA__

ADM 0 administrator can modify users and change their access
BGN 1 lev bulgarian read access
CAD 2 dollar canadian read access
CHF 3 frank read access
DKK 4 krona read access
USD 5 dollar read access
TRY 6 lira read access
EUR 7 euro read access
GBP 8 pound read access
NOK 9 kroni read access
RUB 10 rubli read access
B11 11 bit 11 is available
B12 12 bit 12 is available
B13 13 bit 13 is available
B14 14 bit 14 is available
FOX 15 counterfeit banknotes/faux billets/фалшиви банкноти

