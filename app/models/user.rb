class User < ActiveRecord::Base
  require 'digest/sha2'
  
  attr_accessible :hashed_password, :name, :login,:email,:salt,:password,:password_confirmation
  
  validates :name, :presence => true, :uniqueness =>true
  validates :login,:presence =>true,:uniqueness =>true
  validates :password, :confirmation =>true
  validates :email, :uniqueness =>true,:presence => true
 
  attr_accessor :password_confirmation
  attr_reader :password
  
  validate :password_must_be_present
  after_destroy :ensure_an_admin_remains
  
  belongs_to :role
  
  def password=(password)
    @password = password
    
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password,salt)
    end
  end
  
  def User.authenticate(login,password)
    if user = User.find_by_login(login)
      if user.hashed_password == encrypt_password(password,user.salt)
        user
      end
    end
  end
    
  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "bebecool" + salt)
  end
  
  def ensure_an_admin_remains
    if User.where(:role_id => 1).count.zero?
      raise "Can't Delete Admin User"
    end
  end
  
  def is_store_admin?
    self.role_id == 1
  end
  def is_employee_admin?
    self.role_id == 2
  end
  
  def is_employee_delivery?
    self.role_id == 3
  end
  
  # def logged_in?  
  #     !current_user.nil?
  #   end
 
  private
 
  def password_must_be_present
    errors.add(:password, "Missing Password") unless hashed_password.present?
  end
  
  def generate_salt
    self.salt = 'self.object_id_to_s' + rand.to_s
  end
  
end
