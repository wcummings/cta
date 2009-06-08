#!/usr/bin/perl
use CGI qw/:standard/;
use DBD::SQLite;
use DBI;
use strict;

# Config
my $dbfile = 'cta.sqlite';

# Real shit
my $name = param('name');
my $text = param('text');

my $id   = url_param('id');
my $op   = url_param('op');


my $db = DBI->connect("dbi:SQLite:dbname=$dbfile", "", "") 
    or die "Couldn't connect to db: $DBI::errstr";

print header;

if($id && $op) {
    my $operator = ($op eq "up") ? "+" : "-";
    my $rows_affected = $db->do("UPDATE cta SET rating = rating $operator 1 WHERE id = '$id'");
} elsif($name && $text) {
    $name = escapeHTML($name);
    $text = escapeHTML($text);

    # 'date' should be 'time'. I DON'T GIVE A FUCK.
    # FUCK OFF
    # IT'S TOO MUCH WORK TO CHANGE IT
    # EAT A BAG OF DICKS
    my $query = $db->prepare("INSERT INTO cta (name, text, date) VALUES (?, ?, ?)");
    $query->execute($name, $text, time()) or die "Failed to execute query";
    my $url = url(-full => 1);
}

print "<html>\n";
print "<head><title>Chicago Transit Authority</title></head>\n";
print "<body>\n";
print "<h2>CTA - Insert Quotes Here</h2>\n";
print "<form method='post' action='cta.cgi' name='cta_input'>\n";
print "<label for='name'>Username (HONOR SYSTEM FTW!)</label>\n";
print "<input type='text' name='name' value='$name' size='20'/><br/>\n";
print "<textarea rows='10' cols='80' name='text'></textarea><br/>\n";
print "<input type='submit'/>\n";
print "</form>\n";

my $query = $db->prepare("SELECT id, name, text, date, rating FROM cta ORDER BY date DESC");
$query->execute();

while(my @row = $query->fetchrow_array) {
    my $up_url = url(-full => 1) . "?id=$row[0]&op=up";
    my $down_url = url(-full => 1) . "?id=$row[0]&op=down";

    print "<p>\n";
    print "<u>\#$row[0]</u> by $row[1] at $row[3]<br/>\n";
    print "<pre>$row[2]</pre>\n";
    print "<small><i>Rated $row[4]</i> (<a href='$up_url'>up</a>/<a href='$down_url'>down</a>)</small>";
    print "</p>\n";
}

print "</body>\n";
print "</html>\n";
