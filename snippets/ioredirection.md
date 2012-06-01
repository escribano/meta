<http://www.tuxfiles.org/linuxhelp/iodirection.html>

What if you'd like to scroll the output of grep? Well, because grep sends its results to standard output, you can just pipe them to less:
$ cat applist.txt | grep -i desktop | less
Of course you can redirect the output of grep to a file, if you want:
$ cat applist.txt | grep -i desktop > desktop.txt
