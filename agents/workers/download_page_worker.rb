require_relative "download_page"

SmartPrompt.define_worker :download_page do
  downloader = HtmlDownloader.new(params[:url])
  downloader.safe_download
end
