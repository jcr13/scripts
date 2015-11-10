#!/usr/bin/perl

$cur = 0;
$pre = 0;

$rst = 'RST/rst.0';
$size0 = -s $rst;
#$size0 = (-s $rst) / (1024 * 1024);
print "size is ", $size0, "\n";

if ($size0 == 0) {

    $size = 0;
    for ($i=1; $size == 0 && $i < 9999; $i++) {

	$pre = $i;
	$rst = "RST/rst.".$i;
	$size = -s $rst;
	#$size = (-s $rst) / (1024 * 1024);
    }

    printf("Missing rst.0; found rst.%i size is %i\n", $pre, $size);
    $size0 = $size;
}	

for ($i=$pre+1; $cur == 0; $i++) {

    $rst = "RST/rst.".$i;
#    print "file is ", $rst, "\n";
    $size = -s $rst;
    #$size = (-s $rst) / (1024 * 1024);

    if ( $size && $size == $size0 ) {
        $pre = $i;
    } else {
        $cur = $i;
    }

}

#system("ls -ltr rst.*");

printf("%i\n", $cur);
