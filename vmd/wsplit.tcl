proc wsplit {str sep} {
    split [string map [list $sep \0] $str] \0
}
