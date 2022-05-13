package DBH;
# DBH: BSE banknotes system database access
# Author: Hristo Grigorov <hgrigorov@gmail.com>
# Copyright (c) 2011-2012 Busoft Engineering. All right reserved.
# ----------------------------------------------------------------------------------------
# Credentials are loaded from DATABASE_CREDIT_FILE
# User access control is bit packed in the database under CURRENCY.USERS.ADMIN  
# Author: Kaloyan Krastev <kaloyansen@gmail.com>
# Copyright (c) 2022-2023 Busoft Engineering. All right reserved.
# ----------------------------------------------------------------------------------------
#
use strict; 
use warnings;
use DBI;
use Data::Dumper;
use DateTime::Format::MySQL; # yum install perl-DateTime-Format-MySQL
use constant SESSION_EXPIRATION => '+123m';
use constant SUPERSESSION_EXPIRATION => '+123m'; #'+10m';
use constant DATABASE_CREDIT_FILE => '/var/www/.db';

my %global_access_control_mask = ();       # user access control mask
$global_access_control_mask{ADM} = 2 ** 0; # administrator can modify users and change their access level
$global_access_control_mask{BGN} = 2 ** 1; # lev bulgarian read access
$global_access_control_mask{CAD} = 2 ** 2; # dollar canadian read access
$global_access_control_mask{CHF} = 2 ** 3; # frank read access
$global_access_control_mask{DKK} = 2 ** 4; # krona read access
$global_access_control_mask{USD} = 2 ** 5; # dollar read access
$global_access_control_mask{TRY} = 2 ** 6; # lira read access
$global_access_control_mask{EUR} = 2 ** 7; # euro read access
$global_access_control_mask{GBP} = 2 ** 8; # pound read access
$global_access_control_mask{NOK} = 2 ** 9; # kroni read access
$global_access_control_mask{RUB} = 2 ** 10; # rubli read access
$global_access_control_mask{B11} = 2 ** 11; # bit 11 available
$global_access_control_mask{B11} = 2 ** 12; # bit 12 available
$global_access_control_mask{B11} = 2 ** 13; # bit 13 available
$global_access_control_mask{B11} = 2 ** 14; # bit 14 available
$global_access_control_mask{FOX} = 2 ** 15; # counterfeit banknotes/faux billets/фалшиви банкноти

my $debuglevel = 4;
my $DBH = undef; 

while (<DATA>) {
    # process the line
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

sub db_connect {

    if (defined $DBH) {
        print "DBH already defined!!!\n";
        return;
    }

    my %credit = database_credit_from(DATABASE_CREDIT_FILE);

    my $DB_DRVR = $credit{'DRVR'};
    my $DB_HOST = $credit{'HOST'};
    my $DB_BASE = $credit{'BASE'};
    my $DB_USER = $credit{'USER'};
    my $DB_PASS = $credit{'PASS'};

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
    my $results = $DBH->selectall_arrayref($query, { Slice => {} });

    return $results;    
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

sub db_insert($$) {

    my ($user, $pass) = @_;
    my $sql = "INSERT INTO USERS(USER, PASSWORD) VALUES(?, MD5(?))";

    my $sth = $DBH->prepare($sql);
    my $result = $sth->execute($user, $pass);
    if ($result) {
        DBH::db_update_column('CREATED', DBH::now(), $user); 
    } else {
        die $!;
    }

    $sth->finish();
    return $result;
}

sub db_delete($) {

    my $sql = "DELETE FROM USERS WHERE USER LIKE ?";

    my $sth = $DBH->prepare($sql);
    my $result = $sth->execute(shift);
    if ($result) {
        ;
    } else {
        die $!;
    }

    $sth->finish();
    return $result;
}

sub db_update_column($$$) {

    my ($column, $value, $user) = @_; 
    my $sql = "UPDATE USERS SET $column = ? WHERE USER LIKE ?";

    my $sth = $DBH->prepare($sql);
    my $result = $sth->execute($value, $user);
    if ($result) {
        ;
    } else {
        return $!;
    }

    $sth->finish();
    return $result;
}

sub db_update($) {

    my $sth = $DBH->prepare(shift);
    my $result = $sth->execute();
    if ($result) {
        ;
    } else {
        die $!;
    }

    $sth->finish();
    return $result;
}

sub control($) {

    my $code = shift // 'all';
    return $code eq 'all' ? %global_access_control_mask : $global_access_control_mask{$code};
}

sub now() {

    return DateTime::Format::MySQL->format_datetime(DateTime->now);
}

sub auth_user($$) {

    my ($user, $password) = @_;

    my $from = "FROM USERS WHERE USER = \'$user\'";
    my $result = DBH::db_select_row("SELECT * $from");  
    my $fine = DBH::db_select_array("SELECT COUNT(*) $from AND PASSWORD = MD5(\'$password\')");

    if ($fine) {
        DBH::db_update_column('ACTIVE', 1, $user); 
        DBH::db_update_column('LOGGED', DBH::now(), $user); 
        return $result->{ADMIN};
    } else {
        # print STDERR "User $user NOT authorized with password $password\n";
        return 0;
    }
}

sub auth_superuser($$) {

    my ($user, $password) = @_;
    #return DBH::auth_user($user, $password) == 1 ? 1 : 0;
    return (DBH::auth_user($user, $password) & DBH::access_code('ADM')) ? 1 : 0;
}    

sub auth_admin($$) {

    my ($user, $password) = @_;
    my $from = "FROM USERS WHERE USER = \'$user\'";
    my $result = DBH::db_select_row("SELECT * $from");  
    my $fine = DBH::db_select_array("SELECT COUNT(*) $from AND PASSWORD = MD5(\'$password\')");

    if ( ($fine) && ($result->{ADMIN} == 1) ) {
        #print STDERR "User $user authorized with password $password\n";
        return 1;
    } else {
        #print STDERR "User $user NOT authorized with password $password\n";
        return 0;
    }
}


1;

__DATA__



