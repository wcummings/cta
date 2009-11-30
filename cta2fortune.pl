#!/usr/bin/perl
use strict;
use DBD::SQLite;
use DBI;
use HTML::Entities qw(decode_entities);

my $sqlite_file = shift;

if(not $sqlite_file) {
    usage();
}

my $db = DBI->connect("dbi:SQLite:dbname=$sqlite_file", "", "")
    or die "Couldn't connecto db: $DBI::errstr";

my $query = $db->prepare("SELECT text FROM cta");
$query->execute();

open(FILE, ">cta");
print FILE "%\n";
while(my @row = $query->fetchrow_array) {
    my $text = decode_entities($row[0]);
    chomp $text;
    print FILE "$text\n%\n";
}
close(FILE);

system("strfile cta");

sub usage
{
    print STDERR "Usage: $0 file.sqlite\n";
    exit 1;
}
