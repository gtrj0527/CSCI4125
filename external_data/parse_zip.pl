my $zipcode_file = "free-zipcode-database-Primary.csv";
my $out_file = "zip_code_insert.sql";

open ZIP, "<$zipcode_file";
open OUT, ">$out_file";

my $header = <ZIP>;
$header =~ s/\"//g;

my @headers = split ",", $header;

my %zip_hash;
my $base_zip_sql = "INSERT INTO zip_code (zip, city, state) VALUES (ZIP, CITY, STATE)";
while(<ZIP>) {

	my ($zip_code, $a, $city, $state, $b) = split ",";
	my $zip_sql = $base_zip_sql;
	$zip_code =~ s/\"/\'/g;
	$city =~ s/\"/\'/g;
	$state =~ s/\"/\'/g;
	$zip_sql =~ s/ZIP/$zip_code/;
	$zip_sql =~ s/CITY/$city/;
	$zip_sql =~ s/STATE/$state/;

	print OUT $zip_sql . ";\n";

}
