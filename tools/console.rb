require_relative '../config/environment.rb'
require 'pry'

def reload
  load 'config/environment.rb'
end
# Insert code here to run before hitting the binding.pry
# This is a convenient place to define variables and/or set up new object instances,
# so they will be available to test and play around with in your console

class Cult
  attr_accessor :name, :location, :followers
  attr_reader :founding_year, :slogan, :minimum_age

  @@all = []

  def initialize(name, location, founding_year, slogan, minimum_age)
    @name = name
    @location = location
    @founding_year = founding_year
    @slogan = slogan
    @minimum_age = minimum_age
    @followers = []

    @@all << self
  end

  def recruit_follower(follower)
    if follower.age >= self.minimum_age
      @followers << follower
      follower.join_cult(self) unless follower.cults.include?(self)
    else
      puts "Sorry you're too young"
    end
  end

  def self.all
    @@all
  end

  def cult_population
    @followers.size
  end

  def self.find_by_name(name)
    @@all.find { |cult| cult.name == name}
  end

  def self.find_by_location(location)
    @@all.find { |cult| cult.location == location}
  end

  def self.find_by_founding_year(year)
    @@all.find { |cult| cult.founding_year == year}
  end

  def average_age
    sum = 0.0
    @followers.each do |follower|
      sum += follower.age
    end
    sum / self.cult_population
  end

  def my_followers_mottos
    @followers.each do |follower|
      puts follower.life_motto
    end
  end

  def self.least_popular
    least = self.all.map do |cult|
      cult.cult_population
    end.min
    self.all.each do |cult|
      if least == cult.cult_population
        return cult
      end
    end
  end

  def self.most_common_location
    new_array = self.all.map do |cult|
      cult.location
    end
    new_array.max_by { |element| new_array.count(element) }
  end

  def minimum_age=(minimum_age)
    @minimum_age = minimum_age
  end

end


class Follower
  attr_accessor :cults
  attr_reader :name, :age, :life_motto

  @@all = []

  def initialize(name, age, life_motto)
    @name = name
    @age = age
    @life_motto = life_motto
    @cults = []

    @@all << self
  end

  def join_cult(cult)
    if self.age >= cult.minimum_age
      @cults << cult
      cult.recruit_follower(self) unless cult.followers.include?(self)
    else
      puts "Sorry you're too young"
    end
  end

  def self.all
    @@all
  end

  def self.of_a_certain_age(age)
    @@all.select { |follower| follower.age>=age}
  end

  def my_cults_slogans
    @cults.each do |cult|
      puts cult.slogan
    end
  end

  def fellow_cult_members
    all_cult_members = @@all.select { |follower| follower.cults == self.cults}
    all_cult_members.delete_if { |follower| follower == self}
  end

  def follower_population
    @cults.size
  end

  def self.most_active
    most = self.all.map do |follower|
      follower.follower_population
    end.max
    self.all.each do |follower|
      if most == follower.follower_population
        return follower
      end
    end
  end

  def self.top_ten
    number_of_cults_joined = self.all.map do |follower|
      follower.follower_population
    end.sort.reverse
    number_of_cults_spliced = number_of_cults_joined[0..9]
    follow_me = []
    self.all.each do |follower|
      number_of_cults_spliced.each do |value|
        if value == follower.follower_population
          follow_me << follower
        end
      end
    end
    follow_me
  end

end


class BloodOath
  attr_accessor :cult, :follower, :time

  @@all = []

  def initialize(cult, follower)
    @cult = cult
    @follower = follower
    @time = Time.now

    @@all << self
  end

  def initiation_date
    date = @time.to_s.split(" ")
    date[0]
  end

  def self.all
    @@all
  end

  def self.first_oath
  end

end




cult_x = Cult.new("Cult X", "Flatiron School", 2019, "Yo", 18)
cult_y = Cult.new("Cult Y", "Brooklyn", 2018, "Hey", 50)
cult_z = Cult.new("Cult Z", "Brooklyn", 2018, "Hey", 50)

follower_a = Follower.new("Follower A", 18, "okay")
follower_b = Follower.new("Follower B", 20, "alright")
follower_c = Follower.new("Follower C", 2109, "mmkey")
follower_d = Follower.new("Follower D", 12308, "fine")
follower_e = Follower.new("Follower E", 4158, "sure")
follower_f = Follower.new("Follower F", 12, "what")
follower_g = Follower.new("Follower G", 9, "about")
follower_h = Follower.new("Follower H", 1, "you")
follower_i = Follower.new("Follower I", 10, "are")
follower_j = Follower.new("Follower J", 18, "the")
follower_k = Follower.new("Follower K", 16, "best")
follower_l = Follower.new("Follower L", 15, "around")
follower_m = Follower.new("Follower M", 210, "Kevin")

cult_x.recruit_follower(follower_a)
cult_y.recruit_follower(follower_a)
cult_z.recruit_follower(follower_a)

cult_x.recruit_follower(follower_b)
cult_z.recruit_follower(follower_b)

cult_x.recruit_follower(follower_c)


follower_a.join_cult(cult_y)
follower_a.join_cult(cult_x)

bloodoath_a = BloodOath.new(cult_x, follower_b)
bloodoath_b = BloodOath.new(cult_y, follower_c)
puts ""
puts Follower.top_ten
puts ""
puts "Mwahahaha!" # just in case pry is buggy and exits
