#!/usr/bin/perl -w
# A script to build the directories required for genomic analysis

# Ensure that the following bash command has been run if the csv file was made in DOS
# cat infilename.csv | tr ^M '\n' > infilename2.csv

use strict;
use Cwd;

my ($usage) = "Usage: build_dir.pl <projectname.csv>\n\nPlease enter a comma delimited file with data in the following format:\n\nnucleic_acid,library_type,species,strain\n";

my($infile) = @ARGV;
my(@tier1_dir)= ('raw_dna', 'qc_dna', 'raw_rna', 'qc_rna', 'assembly', 'gene_pred', 'analysis', 'annotation');
my($tier1_dir);
my($currentline);
my(@currentline);
my($linecount)=-1;




my(@project_name)= split('/', $infile);
my($project_name)= pop @project_name;
$project_name =~  s/.csv//;


####### Step 0  #########
#	Open			 	#
# 	Excel file			#
#########################



#	If input values are not entered, or contain whitespace print error messages and exit.
unless(@ARGV) {
	print $usage;
	exit;
}

unless ( open(INFILE, $infile) ) {
			print "cannot open the file \"$infile\" \n\n";
			exit;
}


#######  Step 1 #########
#	Make fixed	 		#
# 	directories 		#
#########################


mkdir $project_name;

foreach (@tier1_dir) {
	$tier1_dir = $_;
	mkdir "$project_name/$tier1_dir";
}

foreach (@tier1_dir[4 .. 7]) {
	$tier1_dir = $_;
	mkdir "$project_name/$tier1_dir/prog1";
}



#######  Step 2 #########
#	Read data in from	#
# 	excel file 		#
#########################



while ($currentline = <INFILE>) {
	print "\nThe current line is:\n$currentline\n";
	if ($linecount==-1){
		$linecount++;
	}
	else {
		$currentline =~ s/\n//;
		@currentline = split (',', $currentline);
		build_dir (@currentline, $project_name, @tier1_dir);
		$linecount++;
	}
}

print "The dataframe \"$project_name\" was constructed for $linecount samples provided in $infile.\n";



sub build_dir {
	my (@currentline);
		@currentline = @_[0 .. 3];
	my ($nucleic_acid) = $currentline[0];
	my ($library_type) = $currentline[1];
	my ($species) = $currentline[2];
	my ($strain) = $currentline[3];
#	my ($project_name) = $_[4];
#	my (@tier1_dir) = @_[5 .. 12]; 

	if ($nucleic_acid eq "dna") {
		foreach (@tier1_dir[0, 1]) {
			$tier1_dir = $_;
			mkdir "$project_name/$tier1_dir/$library_type";
			mkdir "$project_name/$tier1_dir/$library_type/$species";
			mkdir "$project_name/$tier1_dir/$library_type/$species/$strain";
			foreach ('F', 'R'){
				mkdir "$project_name/$tier1_dir/$library_type/$species/$strain/$_";
				print "Created directory: $project_name/$tier1_dir/$library_type/$species/$strain/$_\n"
			}
		}		
	}

	elsif ($nucleic_acid eq "rna") {
		foreach (@tier1_dir[2, 3]) {
			$tier1_dir = $_;
			mkdir "$project_name/$tier1_dir/$library_type";
			mkdir "$project_name/$tier1_dir/$library_type/$species";
			mkdir "$project_name/$tier1_dir/$library_type/$species/$strain";
			foreach ('F', 'R'){
				mkdir "$project_name/$tier1_dir/$library_type/$species/$strain/$_";
				print "Created directory: $project_name/$tier1_dir/$library_type/$species/$strain/$_\n"
			}
		}
	}

	foreach (@tier1_dir[4 .. 7]) {
		$tier1_dir = $_;
		mkdir "$project_name/$tier1_dir/prog1";
		mkdir "$project_name/$tier1_dir/prog1/$species";
		mkdir "$project_name/$tier1_dir/prog1/$species/$strain";
		print "Created directory: $project_name/$tier1_dir/$library_type/$species/$strain\n";
		}	
}
