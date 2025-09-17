SmartPrompt.define_worker :get_embedding do
  use "SiliconFlow"
  model "Qwen/Qwen3-Embedding-0.6B"
  prompt params[:text]
  embeddings(1024)
end
