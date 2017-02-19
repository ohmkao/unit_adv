module UnitAdv::FileTools

  def tmp_mkdir(init_tmp_dir = nil)
    self.tmp_dir = init_tmp_dir.present? ? init_tmp_dir : nil
    return tmp_dir if tmp_dir.present?
    self.tmp_dir ||= ["tmp", "script", "#{Time.now.to_i}_#{rand(9999).to_s.rjust(4, '0')}"].join('/')
    self.echo_log.cmd("mkdir(tmp/): #{tmp_dir}")
    FileUtils.mkdir_p(tmp_dir)
    tmp_dir
  end

  def tmp_rmdir(init_tmp_dir = nil)
    init_tmp_dir ||= tmp_dir
    self.echo_log.cmd("rm -rf: #{init_tmp_dir}")
    FileUtils.rm_rf init_tmp_dir if File.exists?( init_tmp_dir )
    self.tmp_dir = nil
  end

  def mkdir(dir)
    tmp_dir = File.dirname(dir)
    return false if File.exists?(tmp_dir)
    self.echo_log.cmd("mkdir: #{tmp_dir}")
    FileUtils.mkdir_p(tmp_dir)
  end

  def cp(src, dest, opts = {})
    self.echo_log.cmd("cp #{src} #{dest} #{opts}")
    FileUtils.cp(src, dest, opts)
  end

  def mv(src, dest, opts = {})
    self.echo_log.cmd("mv #{src} #{dest} #{opts}")
    FileUtils.mv(src, dest, opts)
  end

  def rm_rf(src, opts = {})
    self.echo_log.cmd("rm -rf #{src} #{opts}")
    FileUtils.rm_rf(src, opts)
  end

  def file_exist?(path_file)
    File.exist? path_file
  end

  def cp_r(src, dest, opts = {})
    # cp -r xxx/* zzz/
    self.echo_log.cmd("cp -r #{src} #{dest} #{opts}")
    FileUtils.cp_r(src, dest, opts)
  end

  def data_to_file(data, dist, opts = {})
    mkdir(dist)
    output_data = (["RecursiveOpenStruct", "OpenStruct"] & [data.class.name]).present? ? data.to_h : data
    output_data = output_data.send(opts.file_format.to_sym) if opts.file_format.present?
    self.echo_log.cmd("Data to File: #{dist}")
    File.open(dist, 'w:UTF-8') { |f| f.write(output_data) }
  end

  def download_to_file(url, dist)
    mkdir(dist)
    self.echo_log.cmd("url: #{url} #{dist}")
    IO.copy_stream(open(url), dist)
  end

end
