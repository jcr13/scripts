#!/usr/bin/perl

$cur = 0;
$pre = 0;

$img = 'cpptraj.0';
$size0 = -s $img;
#print "size is ", $size0, "\n";

if ($size0 == 0) {

    $size = 0;
    for ($i=1; $size == 0 && $i < 9999; $i++) {

	$pre = $i;
	$img = "autoimage/cpptraj.".$i;
	$size = -s $img;
    }

#    printf("Missing rst.0; found img.%i size is %i\n", $pre, $size);
    $size0 = $size;
}	

for ($i=$pre+1; $cur == 0; $i++) {

    $img = "autoimage/cpptraj.".$i;
#    print "file is ", $img, "\n";
    $size = -s $img;

    if ( $size && $size == $size0 ) {
        $pre = $i;
    } else {
        $cur = $i;
    }

}

#system("ls -ltr img.*");

printf("%i\n", $cur);
