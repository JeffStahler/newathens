class Header < ActiveRecord::Base
  
  include PaperclipSupport
  
  attr_accessible :description
  
  belongs_to :user
  
  if CONFIG['s3']
    has_attached_file :attachment, :storage => :s3, :path => "headers/:filename", :bucket => CONFIG['s3_bucket_name'],
                      :s3_host_alias => CONFIG['s3_host_alias'], :url => CONFIG['s3_host_alias'] ? ':s3_alias_url' : nil,
                      :s3_credentials => { :access_key_id => CONFIG['s3_access_id'], :secret_access_key => CONFIG['s3_secret_key'] },
                      :s3_headers => { 'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate }
  else
    has_attached_file :attachment, :storage => :filesystem, :url => "/headers/:filename"
  end
  
  validates_attachment_size :attachment, :less_than => 500.kilobytes
  validates_attachment_content_type :attachment, :content_type => /image/
  
  def self.random
    headers = all(:conditions => ['votes >= 0'], :order => 'created_at') # find eligible headers
    return nil if headers.blank? # use default header if none available
    total_votes = headers.inject(0){|sum, header|header.votes + sum}
    methodology_selector = rand # used to choose one of the 3 methodologies for selecting a random header
    if (methodology_selector < 0.333) || (total_votes == 0) # pick a random header with votes >= 0
      headers[rand(headers.count)]
    elsif methodology_selector < 0.666 # pick a random header from the 5 newest headers
      headers[rand([headers.count,5].min)]
    else # pick a random header favoring headers with more votes (roulette wheel selection algorithm)
      weighted_array = headers.inject([]) { |sum, header| sum << header.votes + (sum.last || 0) }
      picker = rand(total_votes)
      index = weighted_array.index(weighted_array.detect {|i| picker <= i})
      if index == nil
        headers[headers.count]  
      else
        headers[index]
      end

    end
  end
  
  def vote_up
    self.votes = self.votes + 1
    self.save(false)
  end

  def vote_down
    self.votes = self.votes - 1
    self.save(false)
  end
end