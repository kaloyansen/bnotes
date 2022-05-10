package DBH;

# DBH: BSE banknotes system data base access
# Author: Hristo Grigorov <hgrigorov@gmail.com>
# Copyright (c) 2011-2012 Busoft Engineering. All right reserved.
#
# Secure database login credentials from a file
# Author: Kaloyan Krastev <kaloyansen@gmail.com>
# Copyright (c) 2021-2022 Busoft Engineering. All right reserved.

use strict; 
use warnings;
use DBI;
use Data::Dumper;
use constant CREDIT_DATA => '/var/www/.db';

my $debuglevel = 4;
my $DBH = undef; 
my $SESSION_EXPIRATION = '+10m';

sub db_connect {

    if (defined $DBH) {
        print "DBH already defined!!!\n";
        return;
    }

    # database login credentials
    my %db__credit = db_credit();
    my $DB_DRVR = $db__credit{'DRVR'};
    my $DB_HOST = $db__credit{'HOST'};
    my $DB_BASE = $db__credit{'BASE'};
    my $DB_USER = $db__credit{'USER'};
    my $DB_PASS = $db__credit{'PASS'};

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

    my $query = shift;

    #print STDERR "QUERY: $query\n";

    my $results = $DBH->selectall_arrayref($query, { Slice => {} });

    return $results;
}

sub db_select_array($) {

    my $query = shift;

    #print STDERR "QUERY: $query\n";

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

sub db_update($) {

    my $query = shift;

    #print STDERR "QUERY: $query\n";

    my $sth = $DBH->prepare($query);
    $sth->execute();
    $sth->finish();
}

sub db_credit() {

    my %data;

    open(FH, '<', CREDIT_DATA) or die $!;
    while(<FH>) {
        chomp;
        my @word = split / /, $_;
        $data{$word[0]} = $word[1];
    }

    close(FH);
 
    return %data;
}

sub db_credit_json() {

    my $json_text = do {

        open(my $json_fh, '<:encoding(UTF-8)', CREDIT_DATA) or die $!;
        local $/;
        <$json_fh>
    };

    use JSON;
    my $data = decode_json($json_text);
    if ($debuglevel > 3) { print Dumper($data); }

    return $data;
}

sub auth_user($$) {

    my ($user, $password) = @_;

    my $from = "FROM USERS WHERE USER = \'$user\'";
    my $result = DBH::db_select_row("SELECT * $from");  
    my $authorized = DBH::db_select_array("SELECT COUNT(*) $from AND PASSWORD = MD5(\'$password\')");

        if ( ($authorized) && ($result->{ADMIN} == 1) ) {
        #print STDERR "User $user authorized with password $password\n";
        return 1;
    } else {
        #print STDERR "User $user NOT authorized with password $password\n";
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
    if (auth_user($user, $password)) {
        $session->expire($SESSION_EXPIRATION);
        $session->param("~user", $user);
        $session->param("~logged-in", 1);
        return 1;
    }

    return 0;
}


1;

__END__
