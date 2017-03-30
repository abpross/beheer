#!/usr/bin/perl 
#=============================
#Declaration variables
#=============================
sub get_variables
{
	$tot=0;
	our @tabel;
	if ( @ARGV == 0  )
	{
		print "no argument \n";
		exit 2; 
	}
}

$argumenenten=join(' ', @ARGV);


#=============================
# FUNVTION:GET DIR
#=============================
sub get_dir_list
{
	@list=`ls -la $argumenenten`; 
	$z=0;
	for ($i=0;$i<=$#list;$i++)
	{ 
		@array=split(' ', $list[$i]);
		if ( @array == 9 && $array[-1] ne '.' && $array[-1] ne '..' && $array[0] ne 'total')
		{
			$tabel[$z]=[ @array ];
			$arraysize=$z;
			$z=$z+1;
		}
	}
}
#=============================

#=============================
# OUTPUT
#=============================
sub output
{
	for ($j=0;$j<=$arraysize;$j++)
	{
		$filekb=($tabel[$j][4])/(1024);
	        printf("%-20s\t%10d kB\n", $tabel[$j][-1], $filekb);
	        $tot=$tot+$tabel[$j][4];
	}
	$totkb=$tot/(1024);
	$totgb=$tot/(1024**2);
        printf ("%-20s\t%6.2f kB = \t%6.2f GB\n", "",$totkb,$totgb);
}
#=============================

#start program 
#=============================
&get_variables;
&get_dir_list;
&output;
