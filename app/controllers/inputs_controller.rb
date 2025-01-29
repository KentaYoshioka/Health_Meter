class InputsController < ApplicationController
  def create
    uploaded_file = params[:video_file]

    if uploaded_file.nil?
      flash[:alert] = "ファイルを選択してください。"
      Rails.logger.info "Flash Alert: #{flash[:alert]}"
      redirect_to inputs_path
      return
    end

    # ファイルを保存
    save_path = Rails.root.join('public', 'video', uploaded_file.original_filename)
    FileUtils.mkdir_p(File.dirname(save_path))
    File.open(save_path, 'wb') { |file| file.write(uploaded_file.read) }

    # パスをデータベースに保存
    video = Video.new(path: "video/#{uploaded_file.original_filename}")
    if video.save
      flash[:notice] = "動画がアップロードされ、データベースに保存されました。"
      Rails.logger.info "Flash Notice: #{flash[:notice]}"

      # Pythonスクリプトを呼び出す
      script_path = Rails.root.join('./python/detect_video.py')
      output_image_path = Rails.root.join('public', 'output', "#{SecureRandom.hex(8)}.jpg")
      video_path = save_path.to_s

      result = `python3 #{script_path} #{video_path} #{output_image_path}`

      # JSON形式でPythonから返されたデータを処理
      begin
        bounding_boxes = JSON.parse(result.match(/Bounding Box Data: (.+)/)[1])
        flash[:notice] += "<br>YOLO解析が完了しました。画像を確認してください。".html_safe
        @output_image_url = "/output/#{File.basename(output_image_path)}"
        @bounding_boxes = bounding_boxes
      rescue JSON::ParserError => e
        flash[:alert] = "解析結果の読み込みに失敗しました: #{e.message}"
        Rails.logger.error "Flash Alert: #{flash[:alert]}"
      end
    else
      flash[:alert] = "動画のアップロードに成功しましたが、データベースへの保存に失敗しました。"
      Rails.logger.error "Flash Alert: #{flash[:alert]}"
    end

    redirect_to inputs_path
  rescue => e
    flash[:alert] = "動画のアップロード中にエラーが発生しました: #{e.message}"
    Rails.logger.error "Flash Alert: #{flash[:alert]}"
    redirect_to inputs_path
  end
end
