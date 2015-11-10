Perl script that reads all the inputs and generates the gnuplot file
-----------------------------------------------------------------------------------------------------
#!/usr/bin/perl

# Script para crear el archivo de entrada para GNU-plot
# Toma una serie de archivos con la info de fluctuaciones (b-factors)
# creada con ptraj y formatea los datos para que sea
# compatible con GNU-plot


use Cwd;

#$sim="ddd_LiCl_200mM";
$sim=$ARGV[0];

################## By residue
$path = "/uufs/chpc.utah.edu/common/home/u0818159/salt/".$sim."/data/bfactors/";
chdir($path) or die "Cant chdir to $path $!";
system("rm fluct_byres_bfactor_".$sim.".dat");
system("touch fluct_byres_bfactor_".$sim.".dat");
open(OUTPUT, '>>fluct_byres_bfactor_'.$sim.'.dat');


my $pwd=cwd();
print "----------------------------\n by RES";
print $pwd."\n";

$input = "fluct_byres_bfactor_";

#### Cycle through the data files
$start = 0;
for($i=0; $i<1000;$i++){

   $end = $start+1000;
      $input_file = $input.$start."-".$end.".dat\n";
         $start = $start+1000;

            #### Read the file
               open(DAT, $input_file) || ($value="0");
               @raw_data=<DAT>;
               foreach $line(@raw_data){
                          ## Split each column from each line we are reading
                            ($a,$b,$c) = split(/\s+/, $line);
                              print OUTPUT $start."  ".$b."  ".$c."\n";
                              }
                                 close(DAT);

                                    print OUTPUT "\n";

                                    }

                                    close(OUTPUT);


                                    ################## By atom
                                    system("rm fluct_byatom_bfactor_".$sim.".dat");
                                    system("touch fluct_byatom_bfactor_".$sim.".dat");
                                    open(OUTPUT2, '>>fluct_byatom_bfactor_'.$sim.'.dat');


                                    my $pwd=cwd();
                                    print "----------------------------\n By ATOM ";
                                    print $pwd."\n";

                                    $input = "fluct_byatom_bfactor_";

                                    #### Cycle through the data files
                                    $start = 0;
                                    for($i=1; $i<1000;$i++){

                                       $end = $start+1000;
                                          $input_file = $input.$start."-".$end.".dat\n";
                                             $start = $start+1000;

                                                #### Read the file
                                                   open(DAT, $input_file) || ($value="0");
                                                   @raw_data=<DAT>;
                                                   foreach $line(@raw_data){
                                                              ## Split each column from each line we are reading
                                                                ($a,$b,$c) = split(/\s+/, $line);
                                                                  print OUTPUT2 $start."  ".$b."  ".$c."\n";
                                                                  }
                                                                     close(DAT);

                                                                        print OUTPUT2 "\n";

                                                                        }

                                                                        close(OUTPUT);
