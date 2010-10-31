require "spec_helper"
require "ruby-debug"

describe "SwedishPluralize" do
  
  before(:all) do
    @result = []
  end
  
  File.open("spec/test_support/words.txt").each do |line|
    line = line.split("|")
    word = line[0]
    plural = line[1].sub("\n", "")
    
      it "should pluralize " + word + " correctly" do
          SwedishPluralize.pluralize(word).should == plural
          @result << word + " -> " + plural
      end
  end
  
  after(:all) do
    
    saved_state = []
    if File.exists?("spec/test_support/saved_state.txt")
      File.read("spec/test_support/saved_state.txt").each do |line|
        saved_state << line.sub("\n", "")
      end
    end
        
    File.open("spec/test_support/result.txt", "w+") do |file|
      @result.each do |word|
        file.puts word
      end
    end
    
    additional_passes = @result.reject{|line| saved_state.include?(line) }
    additional_failures = saved_state.reject{|line| @result.include?(line) }
    
    puts "\n"
    puts "Changes introduced #{additional_passes.length} additional passing tests"
    puts "Changes introduced #{additional_failures.length} additional failures"
    
    if additional_passes.length > 0
      puts green("Additional passing cases")
      additional_passes.each do |word|
        puts green(word)
      end
    end
    
    if additional_failures.length > 0
      puts red("Additional failing cases")
      additional_failures.each do |word|
        puts red("#{word} (now gets pluralized to #{SwedishPluralize.pluralize(word.split(' -> ')[0])})")
      end
    end
    
  end
end