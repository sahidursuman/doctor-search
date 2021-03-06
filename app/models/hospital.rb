class Hospital < ActiveRecord::Base
  attr_accessible :address, :city, :description, :image, :name, :phone1, :phone2, :department_ids

  has_attached_file :image,
    :storage => :dropbox,
    :dropbox_credentials => "#{Rails.root}/config/dropbox.yml",
    :styles => { :medium => "300x300", :thumb => "100x100", :banner => "770x500" },
    :default_url => "hospital.gif",
    :dropbox_options => {
      :path => proc { |style| "#{style}/#{id}_#{image.original_filename}" }
    }

  belongs_to :user
  
  validates_presence_of :name, :address, :city, :phone1
  validates_numericality_of :phone1, :only_integer => true
  validates_numericality_of :phone2, :only_integer => true, :allow_blank => true
  validates_length_of :phone1, :phone2, :in => 6..7, :allow_blank => true

  has_many :services, :dependent => :destroy
  has_many :departments, :through => :services, :dependent => :destroy
  has_many :involvements, :dependent => :destroy
  has_many :doctors, :through => :involvements, :dependent => :destroy
  has_one :featured_hospital, :dependent => :destroy

  scope :hos_like, lambda{|h| where(["hospitals.name ILIKE ?", "%#{h}%"])}

end
