module UnitAdv
  module DevelopUnit
    module ControllerSupport

      attr_accessor :controller_data

      # === === ===
      def init_controller(data = {})
        self.controller_data = {
          obj: arg_controller_obj,
          stdout: nil,
          status: nil,
          content_type: nil,
        }.merge(data)
      end

      def render_view

      end

      # === === ===
      def render_by_html
        [

        ]
      end

      def render_by_json
        [
          json: controller_data[:stdout].to_json
        ]
      end

      def render_by_text
        [
          test: controller_data[:stdout]
        ]
      end

      def render_by_file
        [
          controller_data[:stdout],
          {
            filename: "#{params[:script]}.#{params[:format]}",
            disposition: 'attachment',
            type: ( params[:format].present? ? params[:format].to_sym : 'text/plain')
          },
        ]
      end

      def render_by_error
        case controller_data[:content_type]
        when 'text/html'

        when 'text/plain'

        when 'image/jpeg'

        when 'application/x-tar'

        when 'text/csv'

        else

        end
      end

      def find_get
        view_pathfile = "#{controller_obj.params[:controller]}/#{controller_obj.params[:action]}_#{controller_obj.params[:id]}"

        # 如果 找不到 render 的 self name 的 file，會使用 superclass 的 name
        view = controller_obj.lookup_context.find_all(view_pathfile).any? ? self_class.underscore : superclass.self_class.underscore
      end

      # === === === === === === === === ===
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
  end
end
