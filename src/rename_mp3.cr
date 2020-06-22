# RenameMP3 helps you to full rename a list of mp3 in folders
require "logger"
require "option_parser"
require "dir"

module RenameMp3
  VERSION = "0.1.0"

  # Configure logger
  log = Logger.new(STDOUT)
  log.level = Logger::WARN
  log.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
    label = severity.unknown? ? "ANY" : severity.to_s
    io << "[" << datetime << "] "
    io << label.rjust(5) << " -- " << progname << ": " << message
  end

  OptionParser.parse! do |parser|
    parser.banner = "Usage: rename_mp3 [arguments]"

    parser.on("-s","--source=SOURCE_DIR", "Set source directory folder") { |source_dir| ENV["SOURCE_DIR"] = source_dir  }
    parser.on("-d", "--destination=DESTINATION_DIR", "Set destination directory folder to save") { |destination_dir| ENV["DESTINATION_DIR"] = destination_dir }
    parser.on("-p", "--prefix=PREFIX", "Prefix name of target folders") { |prefix| ENV["PREFIX"] = prefix }
    parser.on("-f", "--files=FILES", "Number of files in the folder") { |files| ENV["FILES"] = files }

    parser.on("--vv", "Show INFO logs") { log.level = Logger::INFO }
    parser.on("--vvv", "Show DEBUG logs") { log.level = Logger::DEBUG }

    parser.on("-h", "--help", "Show this help") do
      puts parser
      exit 0
    end
    parser.invalid_option do |flag|
      STDERR.puts "ERROR: #{flag} is not a valid option."
      STDERR.puts parser
      exit(1)
    end
  end

  ENV["SOURCE_DIR"] = "./" unless ENV.has_key? "SOURCE_DIR"
  ENV["DESTINATION_DIR"] = "./" unless ENV.has_key? "DESTINATION_DIR"


  # Search all mp3
  Dir.glob("#{ENV["SOURCE_DIR"]}**/*.mp3") do |file|
    puts file
  end
end
