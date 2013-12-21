use strict;
use warnings;
use diagnostics;

#initialization variables
use Cwd 'abs_path';
my $name = $ARGV[0];
my $script_path = abs_path();
my %copy_files = ("Gemfile",".");

#print pre-run information
print "\033[32m";
print "Script path:" . abs_path($0) . "\n";
print "Working in " . `pwd`;
print "Program: \Urails\n\033[0m";
if ($name eq "") {
   print "\033[31mApp name argument not specified.\n";
   print "Usage: rails_init [AppName]\n";
   print "Terminating..\n";
   exit 0;
}
print "\033[34mJob: rails init for $name\n";
print "Config with Git\nDeployment: Heroku\n";
print "Development: sqlite\nProduction: postgres\n";

print "\033[0;3;5mPress enter to continue. Input any character to exit.\033[0m";
exit 0 if !(<STDIN> eq "\n");

#generate command array
#copy template files: all stored in files subdirectory
my @commands = ("rails new $name","cd $name");
my @git_init = ("git init","touch README", "git add .", "git commit -m 'initialized using rails script'",
                'git remote add origin git@github.com:alexbhandari/'."$name.git", "git push -u origin master", 
                "heroku create");
while (my($file, $loc) = each %copy_files) {
   #add copy params
   push(@commands, "cp $script_path/files/$file $loc");
}
push(@commands, "bundle install");

#run commands
system("clear");
print "run: clear\n";
foreach (@commands) {
   print "run: $_\n";
   #system($_);
}
#add git and heroku
print "\033[33mInitialize a git repo with heroku? [yes/no]\n\033[0m";
if (<STDIN> eq "yes\n") {
   foreach (@git_init) {
      print "run: $_\n";
      #system($_);
   }
}
