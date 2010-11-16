require 'rubygems'
require 'trollop'
require 'terminal-table/import'
require 'zencoder'
require 'zencoder/cli/helpers'
require 'zencoder/cli/auth'
require 'zencoder/cli/plugin'
require 'zencoder/cli/command'
require 'zencoder/cli/response'
ZencoderCLI::Plugin.load!

global_options = Trollop::options do
  version "Zencoder #{Zencoder::GEM_VERSION}"
  banner <<-EOS
#{"-" * (14 + Zencoder::GEM_VERSION.length)}
Zencoder CLI v#{Zencoder::GEM_VERSION}
#{"-" * (14 + Zencoder::GEM_VERSION.length)}

== Usage

zencoder [global-options] command [command-options]

== Available Commands

#{
  ZencoderCLI::Command.commands.sort.map{|group, commands|
    commands.map{|command, description|
      command.ljust(22)+" # "+(description.is_a?(String) ? description : description[:description])
    }.join("\n")
  }.join("\n\n")
}

== Global Options
EOS
  opt :environment, "Sets the environment to use (optional: defaults to production)", :type => String
  stop_on ZencoderCLI::Command.commands.map{|k, v| v.keys }.flatten
end

if ARGV.empty?
  puts "You must specify a command. Use --help for more information."
  exit(1)
end

command = ARGV.shift.strip
args = ARGV


flat_commands = ZencoderCLI::Command.commands.values.inject({}){|memo,group| memo.merge!(group) }
command_options = Trollop::options do
  banner <<-EOS
== Usage

zencoder [global-options] #{command} [options]

== Command Options
EOS
  if flat_commands[command] && flat_commands[command][:options]
    flat_commands[command][:options].call(self)
  end
end


ZencoderCLI::Command.run(command, args, global_options, command_options)
