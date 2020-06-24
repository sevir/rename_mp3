# RenameMP3 helps you to full rename a list of mp3 in folders
require "logger"
require "option_parser"
require "dir"
require "file_utils"

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

  ENV["SOURCE_DIR"] ||= "./"
  ENV["DESTINATION_DIR"] ||= "./"
  ENV["PREFIX"] ||= "music_"
  ENV["FILES"] ||= "0"
  files = 1

  # Search all mp3
  Dir.glob("#{ENV["SOURCE_DIR"]}**/*.mp3") do |file|
    if ENV["FILES"] == "0"
      # Move files
      FileUtils.mv file, "#{ENV["DESTINATION_DIR"]}#{ENV["PREFIX"]}#{files.to_s}.mp3"
    else
      subfolder_number = files // ENV["FILES"].to_i
      subfolder_path = %Q(#{ENV["DESTINATION_DIR"]}#{ENV["PREFIX"]}_#{subfolder_number.to_s}/)

      if (ENV["FILES"].to_i % files == 0) || files == 1
        # mkdir subfolder
        Dir.mkdir_p subfolder_path
      end

      # Move file
      FileUtils.mv file, "#{subfolder_path}#{ENV["PREFIX"]}#{files.to_s}.mp3"
    end

    files += 1
  end

  puts "Moved #{files-1} files"
end
