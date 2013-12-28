use strict;
use warnings;
use diagnostics;

# shell color
my $red    = "\033[31m";
my $green  = "\033[32m";
my $yellow = "\033[33m";
my $blue   = "\033[34m";
my $clear  = "\033[0m";
my $italic = "\033[3m";
my $blink  = "\033[5m";

# initialization variables
my $required_rvm = 'ruby-2.0.0-p353@railstutorial_rails_4_0';
use Cwd 'abs_path';
my $name = $ARGV[0];
my $script_path = abs_path();
my %copy_files = ("Gemfile"=>".");

# check rvm gemset
print $green."checking rvm gemset...\n";
if (!(`rvm-prompt` eq $required_rvm . "\n")) {
   print "This script requires gems (might be just rails) known to be contained in the rvm-gemset:\n";
   print $required_rvm . ' on alex@macbook' . "\n";
   print $red."Your current gemset is\n" . `rvm-prompt` . "or rvm is unsupported on your system\n";
   print "This script is untested in this environment.\n";
   print $yellow."Would you like to continue? [yes/return to abort]\n";
   exit 0 if !(<STDIN> eq "yes\n");
   print $green."Continuing...\n";
}
else {
   print "Enviromnent Supported.\n";
}

# print pre-run information
print $green;
print "Script path:" . abs_path($0) . "\n";
print "Working in " . `pwd`;
print "Program: \Urails\n\033[0m";
if ($name eq "") {
   print $red."App name argument not specified.\n";
   print "Usage: rails_init [AppName]\n";
   print "Terminating..\n";
   exit 0;
}
print $blue;
print "Job: rails init for $name\n";
print "Config with Git\nDeployment: Heroku\n";
print "Development: sqlite\nProduction: postgres\n";

print $clear.$italic.$blink."Press enter to continue. Input any character to exit.$clear";
exit 0 if !(<STDIN> eq "\n");

#generate command array
#copy template files: all stored in files subdirectory
my @commands = ("rails new $name");
my @git_init = ("git init","touch README", "git add .", "git commit -m 'initialized using rails script'",
                'git remote add origin git@github.com:alexbhandari/'."$name.git", "git push -u origin master",
                "heroku create");
while (my($file, $loc) = each %copy_files) {
   #add copy params
   push(@commands, "cp $script_path/files/$file $loc");
}
push(@commands, "bundle install");

# Stage 1: Initialization
system("clear");
print "run: clear\n";
foreach (@commands) {
   print "run: $_\n";
   system($_);
   if($_ eq "rails new $name") {
      print "chdir $name\n";
      chdir $name;
   }
}
#add git and heroku
print "\033[33mInitialize a git repo with heroku? [yes/no]\n\033[0m";
if (<STDIN> eq "yes\n") {
   foreach (@git_init) {
      print "run: $_\n";
      system($_);
   }
}
# Stage 2: Pages and Testing
print $green."Initialization Complete\n\033[0m";
print "-----------------------------------------------------\n";
print $yellow."Continue with step 2: Setup pages and testing? [yes/no]\n\033[0m";
exit 0 if !(<STDIN> eq "yes\n");
print $blue."Generating controllers:\n";
my $loop = 1;
while($loop) {
   print $yellow."$loop) Generate controller #$loop? [yes]\n";
   last if !(<STDIN> eq "yes\n");
   print "Enter name\n";
   my $cname = <STDIN>;
   print "Enter pages separated by spaces:\n";
   my $cpages = <STDIN>;
   my $cmd = "rails generate controller $cname $cpages";
   print $italic.$blink."Confirm command: ".$clear.$blue." $cmd [enter to confirm/anything else to abort]\n";
   if (<STDIN> eq "\n") {
      print $clear."run: $cmd\n";
      system($cmd);
      $loop++;
   }
}
print $green."Done!\n";
