package DBH;

# DBH: BSE banknotes system data base access
# Author: Hristo Grigorov <hgrigorov@gmail.com>
# Copyright (c) 2011-2012 Busoft Engineering. All right reserved.

use strict; 
use warnings;
use DBI;
use Data::Dumper;
use constant DATABASE_CREDIT_FILE => '/var/www/.db';

# Credentials are loaded from DATABASE_CREDIT_FILE in a secure database connexion approach 
# Author: Kaloyan Krastev <kaloyansen@gmail.com>
# Copyright (c) 2021-2022 Busoft Engineering. All right reserved.

my $debuglevel = 4;
my $DBH = undef; 
my $SESSION_EXPIRATION = '+22m';

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

    #return $DBH;
}

sub db_disconnect {

    my $DBH = shift;

    if (defined $DBH) {
        $DBH->disconnect();
        undef $DBH;
    }

}

sub db_select($) {

    return $DBH->selectall_arrayref(shift, { Slice => {} });

    #my $query = shift;

    #print STDERR "QUERY: $query\n";

    #my $results = $DBH->selectall_arrayref($query, { Slice => {} });

    #return $results;
    
}

sub db_select_array($) {

    return $DBH->selectrow_array(shift);
    #my $query = shift;

    #print STDERR "QUERY: $query\n";

    #my $result = $DBH->selectrow_array($query);

    #return $result;
}

sub db_select_row($) {

    #my $query = shift;

    #print STDERR "QUERY: $query\n";

    #my $sth = $DBH->prepare($query);
    my $sth = $DBH->prepare(shift);
    $sth->execute();

    #my $result = $sth->fetchrow_hashref();
    return $sth->fetchrow_hashref();

    #return $result;
}

sub db_update($) {

    #my $query = shift;

    #print STDERR "QUERY: $query\n";

    #my $sth = $DBH->prepare($query);
    my $sth = $DBH->prepare(shift);
    $sth->execute();
    $sth->finish();
}

sub auth_user($$) {

    my ($user, $password) = @_;

    my $from = "FROM USERS WHERE USER = \'$user\'";
    my $result = DBH::db_select_row("SELECT * $from");  
    my $fine = DBH::db_select_array("SELECT COUNT(*) $from AND PASSWORD = MD5(\'$password\')");

    if ($fine) {
        return $result->{ADMIN};
        #if ( ($fine) && ($result->{ADMIN} == 1) ) {
        #print STDERR "User $user authorized with password $password\n";
        #return 1;
    } else {
        #print STDER  R "User $user NOT authorized with password $password\n";
        return 0;
    }
}

sub init_session($$) {

    my ($session, $cgi) = @_;
    
    if ($session->param("~logged-in")) {
        return 1;  # if logged in, don't bother going further
    }

    my $user = $cgi->param('user') or return 1;
    my $password = $cgi->param('password') or return 1;

    # if we came this far, user did submit the login form
    # so let's try to load his/her profile if name/psswds match

    my $auth_user = auth_user($user, $password);
#    if (auth_user($user, $password)) {
    if ($auth_user > 0) {
        $session->expire($SESSION_EXPIRATION);
        $session->param("~user", $user);
        $session->param("~access", $auth_user);
        return 1;
    }

    return 0;
}

1;

__END__
