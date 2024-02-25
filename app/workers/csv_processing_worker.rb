require 'csv'

class CsvProcessingWorker
    include Sidekiq::Worker
  
    def perform(file_path, user_id)
        user = User.find(user_id)
        if user
            batch_size = 1000
            current_batch = []
        
            CSV.foreach(file_path, headers: true) do |row|
                current_batch << row.to_h
        
                if current_batch.length >= batch_size
                process_batch(current_batch, user)
                current_batch = []
                end
            end
        
            process_batch(current_batch, user) unless current_batch.empty?
        end
    end
  
    private
  
    def process_batch(batch, user)
        ActiveRecord::Base.transaction do
            batch.each do |row|
               blog = user.blogs.create!(title: row["title"], body: row["body"], user_id: row["user_id"])
            end
        end
    end
  end
  