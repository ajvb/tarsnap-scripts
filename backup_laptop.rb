# Backup script for ajvb's laptop using tarsnap and Kala for scheduling.

require "json"

if __FILE__ == $0
    config_hash = JSON.parse(File.read("config.json"))

    config_hash['dir_list'].each do |target|
        # Extract "target_name" from target.
        # "/home/ajvb/.myfile/ -> "myfile"
        target_name = target.split(File::SEPARATOR)[-1].gsub(/\./, "")

        current_date = Time.new.strftime("%Y-%m-%d")
        # Example: "backup-bashrc-2015-12-10"
        backup_name = "backup-#{target_name}-#{current_date}"

        cmd = "tarsnap -c --cachedir #{config_hash['cachedir']} --keyfile #{config_hash['keyfile']} -f #{backup_name} #{target}"
        puts "Backing up #{target}"
        resp = system(cmd)
        if !resp
            puts "Error with backing up #{target}"
            exit
        end
    end

end
