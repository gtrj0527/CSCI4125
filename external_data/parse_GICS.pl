my $in_file = "GICS.csv";
my $out_file = "GICS_Inserts.sql";

open IN, "<${in_file}";
open OUT, ">${out_file}";

my $junk = <IN>;
$junk = <IN>;
$junk = <IN>;
$junk = <IN>;

my @parent_stack;

while(<IN>) {

	my @vals = split ",";

	for(my $i = 0; $i < scalar(@vals); $i += 2) {

		if($vals[$i] =~ /^\d{2}$/) {
			my $sector_code = $vals[$i];
			my $sector_name = $vals[$i+1];
			$sector_name =~ s/\"//g;
			$sector_name =~ s/\n//g;
			$sector_name =~ s/\s*$//g;
			$sector_name =~ s/\&/and/g;
			print OUT "INSERT INTO GICS (primary_sector_code, code_name) VALUES ('${sector_code}', '${sector_name}');\n";
			#push @parent_stack, $sector_code;
			$parent_stack[0] = $sector_code;
		} elsif ($vals[$i] =~ /^\d{4}$/) {
			my $sector_code = $vals[$i];
			my $sector_name = $vals[$i+1];
			$sector_name =~ s/\"//g;
			$sector_name =~ s/\n//g;
			$sector_name =~ s/\s*$//g;
			$sector_name =~ s/\&/and/g;
			my $parent_code = $parent_stack[0];
			print OUT "INSERT INTO GICS (primary_sector_code, code_name, parent_sector_code) VALUES ('${sector_code}', '${sector_name}', '${parent_code}');\n";
			$parent_stack[1] = $sector_code;
		} elsif ($vals[$i] =~ /^\d{6}$/) {
			my $sector_code = $vals[$i];
			my $sector_name = $vals[$i+1];
			$sector_name =~ s/\"//g;
			$sector_name =~ s/\n//g;
			$sector_name =~ s/\s*$//g;
			$sector_name =~ s/\&/and/g;
			my $parent_code = $parent_stack[1];
			print OUT "INSERT INTO GICS (primary_sector_code, code_name, parent_sector_code) VALUES ('${sector_code}', '${sector_name}', '${parent_code}');\n";
			$parent_stack[2] = $sector_code;
		} elsif ($vals[$i] =~ /^\d{8}$/) {
			my $sector_code = $vals[$i];
			my $sector_name = $vals[$i+1];
			$sector_name =~ s/\"//g;
			$sector_name =~ s/\n//g;
			$sector_name =~ s/\s*$//g;
			$sector_name =~ s/\&/and/g;
			my $parent_code = $parent_stack[2];
			my $desc_line = <IN>;
			my @desc_vals = split ",", $desc_line;
			my $sector_desc = $desc_vals[7];
			$sector_desc =~ s/\"//g;
			$sector_desc =~ s/\n//g;
			$sector_desc =~ s/\s*$//g;
			$sector_desc =~ s/\&/and/g;
			print OUT "INSERT INTO GICS (primary_sector_code, code_name, parent_sector_code, code_description) VALUES ('${sector_code}', '${sector_name}', '${parent_code}', '${sector_desc}');\n";
		}
	}
}
