List the contents of a tar or tar.gz file
by VIVEK GITE on SEPTEMBER 28, 2006 · 15 COMMENTS

Q. How do I list the contents of a tar or tar.gz file?

A. GNU/tar is an archiving program designed to store and extract files from an archive file known as a tarfile. You can create a tar file or compressed tar file tar. However sometime you need to list the contents of a tar or tar.gz file on screen before extracting the all files.

Task: List the contents of a tar file

Use the following command:
$ tar -tvf file.tar

Task: List the contents of a tar.gz file

Use the following command:
$ tar -ztvf file.tar.gz

Task: List the contents of a tar.bz2 file

Use the following command:
$ tar -jtvf file.tar.bz2

Where,

t: List the contents of an archive
v: Verbosely list files processed (display detailed information)
z: Filter the archive through gzip so that we can open compressed (decompress) .gz tar file
j: Filter archive through bzip2, use to decompress .bz2 files.
f filename: Use archive file called filename