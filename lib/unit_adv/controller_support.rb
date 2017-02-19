module ControllerSupport

  attr_accessor :controller_obj, :stdout, :status

  # === === ===
  # 輸出 method
  def controller_render_and_file
    if status?
      args.controller_obj.send_data(*(self.file_download))
    else
      args.controller_obj.render(res_error)
    end
  end

  def controller_render
    args.controller_obj.render( status? ? res_success : res_failure )
  end

  # === === ===
  # 輸出 opts method
  def file_download
    [
      stdout,
      {
        filename: "#{params[:script]}.#{params[:format]}",
        disposition: 'attachment',
        type: ( params[:format].present? ? params[:format].to_sym : 'text/plain')
      },
    ]
  end

  def res_error
    {
      nothing: true,
      status: 404,
      content_type: 'text/plain'
    }
  end

  def res_success
    {
      text: {
        "status" => "success",
        "data" => stdout
      }.to_json,
      status: 200,
      content_type: 'text/plain'
    }
  end

  def res_failure
    {
      text: {
        "status" => "failure",
        "message" => "#{errors.join(', ')}"
      }.to_json,
      status: 404,
      content_type: 'text/plain'
    }
  end

end
