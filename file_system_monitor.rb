require 'rb-fsevent'
require 'optparse'

HELP_STRING = 'When filesystem changes are detected, run a command.
Kill any previous invocations of the command. Use with autosaving IDEs
for maximum benefit (e.g. IntelliJ\'s auto save after 1 second of inactivity)'

include_paths = []
exclude_paths = []
command = nil
OptionParser.new do |opts|
  opts.banner = "Usage: ruby file_system_monitor.rb [options]\n\n#{HELP_STRING}\n\n"

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end

  opts.on("-i", "--include-path p", "Add path to watch list. Multiple paths allowed.") do |p|
    include_paths << p
  end

  opts.on("-x", "--exclude-pattern r", "Don't consider changes to files containing this pattern.") do |x|
    exclude_paths << x
  end


  opts.on("-c", "--command c", "Run command when something in the paths changes.") do |c|
    command = c
  end

end.parse!

class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def blue
    colorize(34)
  end
end

puts "\nWatching paths #{include_paths}\n".blue
if exclude_paths.length > 0
  puts "but not paths containing #{exclude_paths}\n".blue
end

def run(command)
  puts "running #{command}".blue
  pid = Process.spawn (command)
end

def kill(pid)
  puts "-------------------------------------killing pid #{pid}---------------------------------".blue
  system("kill -INT #{pid}")
end

def matches_any_of(potential_matches, patterns)
  potential_matches.each do |potential_match|
    if patterns.any? { |pattern| potential_match.match(/#{pattern}/i) }
      return true
    end
  end
  return false
end

fsevent = FSEvent.new
last_pid = run(command)

fsevent.watch(include_paths) do |paths|
  if !matches_any_of(paths, exclude_paths)
    puts "\nfound change to #{paths}\n".blue
    kill(last_pid)
    last_pid = run(command)
  end
end
fsevent.run
