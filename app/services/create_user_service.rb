class CreateUserService
  attr_reader :params

  def initialize(args)
    @params = args[:params]
  end

  def call
    user = User.new(params)
    user.save!
    user
  end
end