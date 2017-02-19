module Package

  def add_file_by_taz(taz_file, add_files, path = tmp_dir)
    tar_file = taz_file.sub('.gz', '')
    run_command([
        [
          "cd #{path}",
          "gunzip #{taz_file}",
          "tar rf #{tar_file} #{add_files.join(' ')}",
          "gzip #{tar_file}",
        ]
      ])
  end

  def update_file_by_taz(taz_file, add_files, path = tmp_dir)
    tar_file = taz_file.sub('.gz', '')
    run_command([
        [
          "cd #{path}",
          "gunzip #{taz_file}",
          "tar uvf #{tar_file} #{add_files.join(' ')}",
          "gzip #{tar_file}",
        ]
      ])
  end

  def uncompress_by_taz(taz_file, fetch_files = [], path = tmp_dir)
    run_command([
        [
          "cd #{path}",
          "tar zxf #{taz_file} #{fetch_files.join(' ')}",
        ],
      ])
  end

  def compress_by_taz(taz_file, fetch_files, path = tmp_dir)
    run_command([
        [
          "cd #{path}",
          "tar zcf #{taz_file} #{fetch_files.join(' ')}",
        ],
      ])
  end

end
