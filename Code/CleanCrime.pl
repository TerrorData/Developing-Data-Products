open(INP, "<CrimeStatebyState.csv");
open(OUTP, ">CleanCrime.csv");
$prthdr=1;
while ($InpLine = <INP>) {
	chomp($InpLine);
	@DataLine = split(/,/,$InpLine);
	if ($InpLine =~ m:^Estimated crime in :) {
		$State = $InpLine;
		$State =~ s:^Estimated crime in ::;
		$State =~ s:,*::g;
		print("$State\n");
	}
	if ($InpLine =~ m:^Year\,Population\,: && $prthdr == 1) {
		print(OUTP "State,$InpLine\n");
		$prthdr = 0;
	}
	if ($DataLine[0] >= 1960 && $DataLine[0] <= 2012) {
		print(OUTP "$State,$InpLine\n");
	}
}
close(INP);
close(OUTP);
